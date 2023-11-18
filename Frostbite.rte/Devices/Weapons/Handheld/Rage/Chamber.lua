require("FrostbiteSettings");

function Create(self)

	self.parentSet = false;
	
	-- Sounds --
	
	self.switchAutoSound = CreateSoundContainer("SwitchAuto Rage Frostbite", "Frostbite.rte");
	self.switchSingleSound = CreateSoundContainer("SwitchSingle Rage Frostbite", "Frostbite.rte");
	
	self.preSound = CreateSoundContainer("Pre Rage Frostbite", "Frostbite.rte");
	
	self.addSound = CreateSoundContainer("Add Rage Frostbite", "Frostbite.rte");
	self.addAutoSound = CreateSoundContainer("AddAuto Rage Frostbite", "Frostbite.rte");
	self.addAutoEndSound = CreateSoundContainer("AddAutoEnd Rage Frostbite", "Frostbite.rte");
	
	self.reflectionIndoorsSound = CreateSoundContainer("ReflectionIndoors Rage Frostbite", "Frostbite.rte");
	self.reflectionOutdoorsSound = CreateSoundContainer("ReflectionOutdoors Rage Frostbite", "Frostbite.rte");
	
	self.reloadPrepareSounds = {}
	self.reloadPrepareSounds.Raise = nil;
	self.reloadPrepareSounds.MagOut = CreateSoundContainer("MagOutPrepare Rage Frostbite", "Frostbite.rte");
	self.reloadPrepareSounds.MagIn = CreateSoundContainer("MagInPrepare Rage Frostbite", "Frostbite.rte");
	self.reloadPrepareSounds.Shoulder = CreateSoundContainer("ShoulderPrepare Rage Frostbite", "Frostbite.rte");
	
	self.reloadPrepareLengths = {}
	self.reloadPrepareLengths.Raise = 0
	self.reloadPrepareLengths.MagOut = 370
	self.reloadPrepareLengths.MagIn = 875
	self.reloadPrepareLengths.Shoulder = 750
	
	self.reloadPrepareDelay = {}
	self.reloadPrepareDelay.Raise = 100
	self.reloadPrepareDelay.MagOut = 600
	self.reloadPrepareDelay.MagIn = 1500
	self.reloadPrepareDelay.Shoulder = 850
	
	self.reloadAfterSounds = {}
	self.reloadAfterSounds.Raise = CreateSoundContainer("Raise Rage Frostbite", "Frostbite.rte");
	self.reloadAfterSounds.MagOut = CreateSoundContainer("MagOut Rage Frostbite", "Frostbite.rte");
	self.reloadAfterSounds.MagIn = CreateSoundContainer("MagIn Rage Frostbite", "Frostbite.rte");
	self.reloadAfterSounds.Shoulder = CreateSoundContainer("Shoulder Rage Frostbite", "Frostbite.rte");
	
	self.reloadAfterDelay = {}
	self.reloadAfterDelay.Raise = 200
	self.reloadAfterDelay.MagOut = 650
	self.reloadAfterDelay.MagIn = 400
	self.reloadAfterDelay.Shoulder = 550
	
	self.lastAge = self.Age
	
	self.originalSharpLength = self.SharpLength
	
	self.originalStanceOffset = Vector(math.abs(self.StanceOffset.X), self.StanceOffset.Y)
	self.originalSharpStanceOffset = Vector(self.SharpStanceOffset.X, self.SharpStanceOffset.Y)
	
	self.originalSupportOffset = Vector(self.SupportOffset.X, self.SupportOffset.Y)
	
	self.rotation = 0
	self.rotationTarget = 0
	self.rotationSpeed = 6
	
	self.reloadSupportOffsetTarget = Vector(0, 0);
	self.reloadSupportOffsetSpeed = 20
	
	self.reloadingVector = Vector(0, 0)
	
	self.frameAnimFactor = 0;
	
	self.horizontalAnim = 0
	self.verticalAnim = 0
	
	self.angVel = 0
	self.lastRotAngle = self.RotAngle
	
	self.FireTimer = Timer();
	self.smokeDelayTimer = Timer();
	self.canSmoke = false
	
	self.BaseReloadTimer = Timer();
	
	self.reloadPhase = 0;
	
	self.BaseReloadTime = 9999;
	
	self.fireDelayTimer = Timer();
	self.delayedFire = false
	self.delayedFireTimer = Timer();
	self.delayedFireTimeMS = 60
	self.delayedFireEnabled = true
	self.activated = false
	
	-- Progressive Recoil System 
	self.recoilAcc = 0 -- for sinous
	self.recoilStr = 0 -- for accumulator
	self.recoilStrength = 40 -- multiplier for base recoil added to the self.recoilStr when firing
	self.recoilPowStrength = 0.2 -- multiplier for self.recoilStr when firing
	self.recoilRandomUpper = 2 -- upper end of random multiplier (1 is lower)
	self.recoilDamping = 0.6
	
	self.recoilMax = 12 -- in deg.
	self.originalSharpLength = self.SharpLength
	-- Progressive Recoil System 
end

function Update(self)

	if UInputMan:KeyPressed(6) then
		self:ReloadScripts();
		PresetMan:ReloadAllScripts();
	end

	self.rotationTarget = 0 -- ZERO IT FIRST AAAA!!!!!
	
	if self.ID == self.RootID then
		self.parent = nil;
		self.parentSet = false;
	elseif self.parentSet == false then
		local actor = MovableMan:GetMOFromID(self.RootID);
		if actor and IsAHuman(actor) then
			self.parent = ToAHuman(actor);
			self.parentSet = true;
		end
	end
	
    -- Smoothing
    local min_value = -math.pi;
    local max_value = math.pi;
    local value = self.RotAngle - self.lastRotAngle
    local result;
    local ret = 0
    
    local range = max_value - min_value;
    if range <= 0 then
        result = min_value;
    else
        ret = (value - min_value) % range;
        if ret < 0 then ret = ret + range end
        result = ret + min_value;
    end
    
    self.lastRotAngle = self.RotAngle
    self.angVel = (result / TimerMan.DeltaTimeSecs) * self.FlipFactor
    
    if self.lastHFlipped ~= nil then
        if self.lastHFlipped ~= self.HFlipped then
            self.lastHFlipped = self.HFlipped
            self.angVel = 0
        end
    else
        self.lastHFlipped = self.HFlipped
    end
	
	-- Check if switched weapons/hide in the inventory, etc.
	if self.Age > (self.lastAge + TimerMan.DeltaTimeSecs * 2000) then
		if self.delayedFire then
			self.delayedFire = false
		end
		self.fireDelayTimer:Reset()
	end
	self.lastAge = self.Age + 0
	
	-- PAWNIS RELOAD ANIMATION HERE
	if self:IsReloading() then

		self.fireDelayTimer:Reset()
		self.activated = false;
		self.delayedFire = false;	

		if self.reloadPhase == 0 then
		
			self.reloadSupportOffsetSpeed = 16
		
			self.reloadSupportOffsetTarget = Vector(-4, 5)
		
			self.reloadingVectorTarget = Vector(5, -2);
		
			self.reloadDelay = self.reloadPrepareDelay.Raise;
			self.afterDelay = self.reloadAfterDelay.Raise;		
			
			self.prepareSound = self.reloadPrepareSounds.Raise;
			self.prepareSoundLength = self.reloadPrepareLengths.Raise;
			self.afterSound = self.reloadAfterSounds.Raise;
			
			self.rotationTarget = 10;
			
		elseif self.reloadPhase == 1 then
		
			self.reloadSupportOffsetSpeed = 16
		
			self.reloadSupportOffsetTarget = Vector(-4, 5)
		
			self.reloadingVectorTarget = Vector(5, -2);
		
			self.reloadDelay = self.reloadPrepareDelay.MagOut;
			self.afterDelay = self.reloadAfterDelay.MagOut;		
			
			self.prepareSound = self.reloadPrepareSounds.MagOut;
			self.prepareSoundLength = self.reloadPrepareLengths.MagOut;
			self.afterSound = self.reloadAfterSounds.MagOut;
			
			self.rotationTarget = 10;
			
		elseif self.reloadPhase == 2 then
		
			self.reloadSupportOffsetTarget = Vector(-4, 8)
		
			self.reloadDelay = self.reloadPrepareDelay.MagIn;
			self.afterDelay = self.reloadAfterDelay.MagIn;		
			
			self.prepareSound = self.reloadPrepareSounds.MagIn;
			self.prepareSoundLength = self.reloadPrepareLengths.MagIn;
			self.afterSound = self.reloadAfterSounds.MagIn;
			
			self.rotationTarget = 10;
		
		elseif self.reloadPhase == 3 then
			
			self.reloadSupportOffsetTarget = Vector(-7, -2)
			
			self.reloadDelay = self.reloadPrepareDelay.Shoulder;
			self.afterDelay = self.reloadAfterDelay.Shoulder;		
			
			self.prepareSound = self.reloadPrepareSounds.Shoulder;
			self.prepareSoundLength = self.reloadPrepareLengths.Shoulder;
			self.afterSound = self.reloadAfterSounds.Shoulder;
			
			self.rotationTarget = 0;
			
		end
		
		if self.BaseReloadTimer:IsPastSimMS(self.reloadDelay - self.prepareSoundLength) and self.prepareSoundPlayed ~= true then
			self.prepareSoundPlayed = true;
			if self.prepareSound then
				self.prepareSound:Play(self.Pos)
			end
		end
	
		if self.BaseReloadTimer:IsPastSimMS(self.reloadDelay) then
		
			if self.reloadPhase == 1 then
			
				self.reloadSupportOffsetTarget = Vector(-5, 9)
			
				self:SetNumberValue("MagRemoved", 1);
			elseif self.reloadPhase == 2 then
			
				self.reloadSupportOffsetTarget = Vector(-4, 4)
			
				self:RemoveNumberValue("MagRemoved");

			end
			
			if self.afterSoundPlayed ~= true then
			
				if self.reloadPhase == 0 then
					self.horizontalAnim = self.horizontalAnim + 1;
					self.angVel = self.angVel - 15;
			
				elseif self.reloadPhase == 1 then
					local fake
					fake = CreateMOSRotating("Fake Magazine MOSRotating Rage Frostbite");
					fake.Pos = self.Pos + Vector(-5 * self.FlipFactor, 6):RadRotate(self.RotAngle);
					fake.Vel = self.Vel + Vector(0.5*self.FlipFactor, 2):RadRotate(self.RotAngle);
					fake.RotAngle = self.RotAngle;
					fake.AngularVel = self.AngularVel + (-1*self.FlipFactor);
					fake.HFlipped = self.HFlipped;
					MovableMan:AddParticle(fake);
					
					self.angVel = self.angVel + 2;
					self.verticalAnim = self.verticalAnim + 1
					
				elseif self.reloadPhase == 2 then
					self.angVel = self.angVel - 2;
					self.verticalAnim = self.verticalAnim - 1	
					self:RemoveNumberValue("MagRemoved");
					
				elseif self.reloadPhase == 3 then
					self.horizontalAnim = self.horizontalAnim + 1;
					self.angVel = self.angVel + 15;
				end
			
				self.afterSoundPlayed = true;
				if self.afterSound then
					self.afterSound:Play(self.Pos);
				end
			end
			if self.BaseReloadTimer:IsPastSimMS(self.reloadDelay + self.afterDelay) then
				self.BaseReloadTimer:Reset();
				self.prepareSoundPlayed = false;
				self.afterSoundPlayed = false;
				if self.reloadPhase == 0 then
					if self:NumberValueExists("Mag Removed") then
						self.reloadPhase = 2;
					elseif not self.newMagReloaded then
						self.reloadPhase = 1
					else
						self.reloadPhase = 3;
					end
				elseif self.reloadPhase == 3 then
					self.BaseReloadTime = 0;
					self.reloadPhase = 0;
					self.reloadingVectorTarget = nil;
					self.rotationSpeed = 9
					self.reloadSupportOffsetTarget = self.originalSupportOffset;
				else
					self.reloadPhase = self.reloadPhase + 1;
				end
			end
		end		
	else
		
		self.BaseReloadTimer:Reset();
		self.prepareSoundPlayed = false;
		self.afterSoundPlayed = false;
		if self.reloadPhase == 3 then
			self.reloadPhase = 2;
		end
		self.BaseReloadTime = 9999;
	end
	
	if self:DoneReloading() then
		self.fireDelayTimer:Reset()
		self.Magazine.RoundCount = 10;
	end	


	local fire = self:IsActivated() and self.RoundInMagCount > 0;

	if self.parent and self.delayedFirstShot == true then
	
		if self.RoundInMagCount > 0 then
			self:Deactivate()
		end
		
		--if self.parent:GetController():IsState(Controller.WEAPON_FIRE) and not self:IsReloading() then
		if fire and not self:IsReloading() then
			if not self.Magazine or self.Magazine.RoundCount < 1 then
				--self:Reload()
				self:Activate()
			elseif not self.activated and not self.delayedFire and self.fireDelayTimer:IsPastSimMS(1 / (self.RateOfFire / 60) * 1000) then
				self.activated = true
				
				self.preSound:Play(self.Pos);
				
				self.fireDelayTimer:Reset()
				
				self.delayedFire = true
				self.delayedFireTimer:Reset()
			end
		else
			if self.activated then
				self.activated = false
			end
		end
	elseif fire == false then
		self.delayedFirstShot = true;
	end
	
	if self.FiredFrame then
	
		self.horizontalAnim = 5;
	
		self.FireTimer:Reset();
	
		self.angVel = self.angVel - RangeRand(0.7,1.1) * 7
		
		self.canSmoke = true
		
		local xSpread = 0
		
		local smokeAmount = 25
		local particleSpread = 21
		
		local smokeLingering = math.sqrt(smokeAmount / 8)
		local smokeVelocity = (1 + math.sqrt(smokeAmount / 8) ) * 0.5
		
		local shot = CreateAEmitter("Rage Frostbite Shot", "Frostbite.rte");
		shot.Pos = self.MuzzlePos + Vector(2 * self.FlipFactor,0):RadRotate(self.RotAngle);
		shot.RotAngle = self.RotAngle
		shot.HFlipped = self.HFlipped
		shot.Vel = self.Vel + Vector(80 * self.FlipFactor,0):RadRotate(self.RotAngle);
		shot.Team = self.Team;
		shot.IgnoresTeamHits = true;
		
		if self.autoFireMode then
			self.addAutoSound:Play(self.Pos);
			self.addAutoEndSound:Play(self.Pos);			
			shot.Vel = self.Vel + Vector(45 * self.FlipFactor,0):RadRotate(self.RotAngle);
			smokeAmount = 7
			
			-- heat vent smoke
		
			for i = 1, math.ceil(smokeAmount / (math.random(2,4))) do
				local spread = math.pi * RangeRand(-1, 1) * 0.05
				local velocity = 110 * RangeRand(0.1, 0.9) * 0.4;
				
				local particle = CreateMOSParticle((math.random() * particleSpread) < 19 and "Tiny Smoke Ball 1" or "Small Smoke Ball 1");
				particle.Pos = self.Pos + Vector(0, -2):RadRotate(self.RotAngle);
				particle.Vel = self.Vel + Vector(0 * self.FlipFactor, -20):RadRotate(self.RotAngle + spread)
				particle.Lifetime = particle.Lifetime * RangeRand(0.9, 1.6) * 0.3 * smokeLingering
				particle.AirThreshold = particle.AirThreshold * 0.5
				particle.GlobalAccScalar = 0
				MovableMan:AddParticle(particle);
			end
			
			-- Muzzle scary smoke
			for i = 1, math.ceil(smokeAmount / (math.random(8,12))) do
				local spread = math.pi * RangeRand(-1, 1) * 0.05
				local velocity = 110 * RangeRand(0.1, 0.9) * 0.4;
				
				local particle = CreateMOSParticle("Side Thruster Blast Ball 1", "Base.rte");
				particle.Pos = self.Pos + Vector(0, -2):RadRotate(self.RotAngle);
				particle.Vel = self.Vel + Vector(0 * self.FlipFactor, -20):RadRotate(self.RotAngle + spread)
				particle.Lifetime = particle.Lifetime * RangeRand(0.9, 1.6) * 0.3 * smokeLingering
				particle.AirThreshold = particle.AirThreshold * 0.5
				particle.GlobalAccScalar = 0
				MovableMan:AddParticle(particle);
			end
			
			
		else
			self.addSound:Play(self.Pos);
			shot.Vel = self.Vel + Vector(100 * self.FlipFactor,0):RadRotate(self.RotAngle);	
		end
		
		MovableMan:AddParticle(shot);
		
		-- Muzzle main smoke
		for i = 1, math.ceil(smokeAmount / (math.random(2,4))) do
			local spread = math.pi * RangeRand(-1, 1) * 0.05
			local velocity = 110 * RangeRand(0.1, 0.9) * 0.4;
			
			local particle = CreateMOSParticle((math.random() * particleSpread) < 15 and "Tiny Smoke Ball 1" or "Small Smoke Ball 1");
			particle.Pos = self.MuzzlePos
			particle.Vel = self.Vel + Vector(velocity * self.FlipFactor,0):RadRotate(self.RotAngle + spread) * smokeVelocity
			particle.Lifetime = particle.Lifetime * RangeRand(0.9, 1.6) * 0.3 * smokeLingering
			particle.AirThreshold = particle.AirThreshold * 0.5
			particle.GlobalAccScalar = 0
			MovableMan:AddParticle(particle);
		end
		
		-- Muzzle lingering smoke
		for i = 1, math.ceil(smokeAmount / (math.random(2,4))) do
			local spread = math.pi * RangeRand(-1, 1) * 0.05
			local velocity = 110 * RangeRand(0.1, 0.9) * 0.4;
			
			local particle = CreateMOSParticle((math.random() * particleSpread) < 10 and "Tiny Smoke Ball 1" or "Small Smoke Ball 1");
			particle.Pos = self.MuzzlePos
			particle.Vel = self.Vel + Vector(velocity * self.FlipFactor,0):RadRotate(self.RotAngle + spread) * smokeVelocity
			particle.Lifetime = particle.Lifetime * RangeRand(0.9, 1.6) * 0.3 * smokeLingering * 3
			particle.AirThreshold = particle.AirThreshold * 0.5
			particle.GlobalAccScalar = 0.01
			MovableMan:AddParticle(particle);
		end
		
		-- Muzzle side smoke
		for i = 1, math.ceil(smokeAmount / (math.random(4,6))) do
			local vel = Vector(110 * self.FlipFactor,0):RadRotate(self.RotAngle)
			
			local xSpreadVec = Vector(xSpread * self.FlipFactor * math.random() * -1, 0):RadRotate(self.RotAngle)
			
			local particle = CreateMOSParticle("Tiny Smoke Ball 1");
			particle.Pos = self.MuzzlePos + xSpreadVec
			-- oh LORD
			particle.Vel = self.Vel + ((Vector(vel.X, vel.Y):RadRotate(math.pi * (math.random(0,1) * 2.0 - 1.0) * 0.5 + math.pi * RangeRand(-1, 1) * 0.15) * RangeRand(0.1, 0.9) * 0.3 + Vector(vel.X, vel.Y):RadRotate(math.pi * RangeRand(-1, 1) * 0.15) * RangeRand(0.1, 0.9) * 0.2) * 0.5) * smokeVelocity;
			-- have mercy
			particle.Lifetime = particle.Lifetime * RangeRand(0.9, 1.6) * 0.3 * smokeLingering
			particle.AirThreshold = particle.AirThreshold * 0.5
			particle.GlobalAccScalar = 0
			MovableMan:AddParticle(particle);
		end
		
		-- Muzzle scary smoke
		for i = 1, math.ceil(smokeAmount / (math.random(8,12))) do
			local spread = math.pi * RangeRand(-1, 1) * 0.05
			local velocity = 110 * RangeRand(0.1, 0.9) * 0.4;
			
			local particle = CreateMOSParticle("Side Thruster Blast Ball 1", "Base.rte");
			particle.Pos = self.MuzzlePos
			particle.Vel = self.Vel + Vector(velocity * self.FlipFactor,0):RadRotate(self.RotAngle + spread) * smokeVelocity
			particle.Lifetime = particle.Lifetime * RangeRand(0.9, 1.6) * 0.3 * smokeLingering
			particle.AirThreshold = particle.AirThreshold * 0.5
			particle.GlobalAccScalar = 0
			MovableMan:AddParticle(particle);
		end
		
		-- Muzzle flash-smoke
		for i = 1, math.ceil(smokeAmount / (math.random(5,10) * 0.5)) do
			local spread = RangeRand(-math.rad(particleSpread), math.rad(particleSpread)) * (1 + math.random(0,3) * 0.3)
			local velocity = 110 * 0.6 * RangeRand(0.9,1.1)
			
			local xSpreadVec = Vector(xSpread * self.FlipFactor * math.random() * -1, 0):RadRotate(self.RotAngle)
			
			local particle = CreateMOSParticle("Flame Smoke 1 Micro")
			particle.Pos = self.MuzzlePos + xSpreadVec
			particle.Vel = self.Vel + Vector(velocity * self.FlipFactor,0):RadRotate(self.RotAngle + spread) * smokeVelocity
			particle.Team = self.Team
			particle.Lifetime = particle.Lifetime * RangeRand(0.9,1.2) * 0.75 * smokeLingering
			particle.AirResistance = particle.AirResistance * 2.5 * RangeRand(0.9,1.1)
			particle.IgnoresTeamHits = true
			particle.AirThreshold = particle.AirThreshold * 0.5
			MovableMan:AddParticle(particle);
		end
		--
		
		local shakenessParticle = CreateMOPixel("Shakeness Particle Glow Frostbite", "Frostbite.rte");
		shakenessParticle.Pos = self.MuzzlePos;
		shakenessParticle.Mass = 30;
		shakenessParticle.Lifetime = 300;
		MovableMan:AddParticle(shakenessParticle);

		local outdoorRays = 0;
		
		local indoorRays = 0;
		
		local bigIndoorRays = 0;

		if self.parent and self.parent:IsPlayerControlled() then
			self.rayThreshold = 2; -- this is the first ray check to decide whether we play outdoors
			local Vector2 = Vector(0,-700); -- straight up
			local Vector2Left = Vector(0,-700):RadRotate(45*(math.pi/180));
			local Vector2Right = Vector(0,-700):RadRotate(-45*(math.pi/180));			
			local Vector2SlightLeft = Vector(0,-700):RadRotate(22.5*(math.pi/180));
			local Vector2SlightRight = Vector(0,-700):RadRotate(-22.5*(math.pi/180));		
			local Vector3 = Vector(0,0); -- dont need this but is needed as an arg
			local Vector4 = Vector(0,0); -- dont need this but is needed as an arg

			self.ray = SceneMan:CastObstacleRay(self.Pos, Vector2, Vector3, Vector4, self.RootID, self.Team, 128, 7);
			self.rayRight = SceneMan:CastObstacleRay(self.Pos, Vector2Right, Vector3, Vector4, self.RootID, self.Team, 128, 7);
			self.rayLeft = SceneMan:CastObstacleRay(self.Pos, Vector2Left, Vector3, Vector4, self.RootID, self.Team, 128, 7);			
			self.raySlightRight = SceneMan:CastObstacleRay(self.Pos, Vector2SlightRight, Vector3, Vector4, self.RootID, self.Team, 128, 7);
			self.raySlightLeft = SceneMan:CastObstacleRay(self.Pos, Vector2SlightLeft, Vector3, Vector4, self.RootID, self.Team, 128, 7);
			
			self.rayTable = {self.ray, self.rayRight, self.rayLeft, self.raySlightRight, self.raySlightLeft};
		else
			self.rayThreshold = 1; -- has to be different for AI
			local Vector2 = Vector(0,-700); -- straight up
			local Vector3 = Vector(0,0); -- dont need this but is needed as an arg
			local Vector4 = Vector(0,0); -- dont need this but is needed as an arg		
			self.ray = SceneMan:CastObstacleRay(self.Pos, Vector2, Vector3, Vector4, self.RootID, self.Team, 128, 7);
			
			self.rayTable = {self.ray};
		end
		
		for _, rayLength in ipairs(self.rayTable) do
			if rayLength < 0 then
				outdoorRays = outdoorRays + 1;
			elseif rayLength > 170 then
				bigIndoorRays = bigIndoorRays + 1;
			else
				indoorRays = indoorRays + 1;
			end
		end
		
		if outdoorRays >= self.rayThreshold then
			self.reflectionOutdoorsSound:Play(self.Pos);
		else
			self.reflectionIndoorsSound:Play(self.Pos);
		end
	end
	
	if self.delayedFire and self.delayedFireTimer:IsPastSimMS(self.delayedFireTimeMS) then
		self:Activate()	
		self.delayedFire = false
		self.delayedFirstShot = false;
	end
	
	-- Animation
	if self.parent then
	
		self.switchSingleSound.Pos = self.Pos;
		self.switchAutoSound.Pos = self.Pos;
	
		if self.parent:IsPlayerControlled() then
			if UInputMan:KeyPressed(FrostbiteSettings.WeaponAbilityPrimary) then
				if self.autoFireMode then
					self.autoFireMode = false;
					self.switchSingleSound:Play(self.Pos);
					self.switchAutoSound:Stop(-1);
					self.RateOfFire = 100;
					self.FullAuto = false;
					self.recoilStrength = 40;
				else
					self.autoFireMode = true;
					self.switchAutoSound:Play(self.Pos);
					self.switchSingleSound:Stop(-1);
					self.RateOfFire = 430;
					self.FullAuto = true;
					self.recoilStrength = 32;
				end
			end
		end
		
		if self.autoFireMode then
			if self.Frame < 4 then
				self.frameAnimFactor = self.frameAnimFactor + TimerMan.DeltaTimeSecs * 10
				self.Frame = math.floor(self.frameAnimFactor);
			end
		else
			if self.Frame > 0 then
				self.frameAnimFactor = self.frameAnimFactor - TimerMan.DeltaTimeSecs * 10
				self.Frame = math.min(4, math.floor(self.frameAnimFactor + 0.5));
			end
		end
	
		self.horizontalAnim = math.floor(self.horizontalAnim / (1 + TimerMan.DeltaTimeSecs * 24.0) * 1000) / 1000
		self.verticalAnim = math.floor(self.verticalAnim / (1 + TimerMan.DeltaTimeSecs * 15.0) * 1000) / 1000
		
		local stance = Vector()
		stance = stance + Vector(-1,0) * self.horizontalAnim -- Horizontal animation
		stance = stance + Vector(0,5) * self.verticalAnim -- Vertical animation
		
		self.rotationTarget = self.rotationTarget - (self.angVel * 4)
		
		-- Progressive Recoil Update
		if self.FiredFrame then
			self.recoilStr = self.recoilStr + ((math.random(10, self.recoilRandomUpper * 10) / 10) * 0.5 * self.recoilStrength) + (self.recoilStr * 0.6 * self.recoilPowStrength)
			self:SetNumberValue("recoilStrengthBase", self.recoilStrength * (1 + self.recoilPowStrength) / self.recoilDamping)
		end
		self:SetNumberValue("recoilStrengthCurrent", self.recoilStr)
		
		self.recoilStr = math.floor(self.recoilStr / (1 + TimerMan.DeltaTimeSecs * 8.0 * self.recoilDamping) * 1000) / 1000
		self.recoilAcc = (self.recoilAcc + self.recoilStr * TimerMan.DeltaTimeSecs) % (math.pi * 4)
		
		local recoilA = (math.sin(self.recoilAcc) * self.recoilStr) * 0.05 * self.recoilStr
		local recoilB = (math.sin(self.recoilAcc * 0.5) * self.recoilStr) * 0.01 * self.recoilStr
		local recoilC = (math.sin(self.recoilAcc * 0.25) * self.recoilStr) * 0.05 * self.recoilStr
		
		local recoilFinal = math.max(math.min(recoilA + recoilB + recoilC, self.recoilMax), -self.recoilMax)
		
		self.SharpLength = math.max(self.originalSharpLength - (self.recoilStr * 3 + math.abs(recoilFinal)), 0)
		
		self.rotationTarget = self.rotationTarget + recoilFinal -- apply the recoil
		-- Progressive Recoil Update		
		
		self.rotation = (self.rotation + self.rotationTarget * TimerMan.DeltaTimeSecs * self.rotationSpeed) / (1 + TimerMan.DeltaTimeSecs * self.rotationSpeed)
		self.SupportOffset = self.SupportOffset + ((self.reloadSupportOffsetTarget - self.SupportOffset) * TimerMan.DeltaTimeSecs * self.reloadSupportOffsetSpeed)
		local total = math.rad(self.rotation) * self.FlipFactor
		
		self.InheritedRotAngleOffset = total * self.FlipFactor;
		-- self.RotAngle = self.RotAngle + total;
		-- self:SetNumberValue("MagRotation", total);
		
		-- local jointOffset = Vector(self.JointOffset.X * self.FlipFactor, self.JointOffset.Y):RadRotate(self.RotAngle);
		-- local offsetTotal = Vector(jointOffset.X, jointOffset.Y):RadRotate(-total) - jointOffset
		-- self.Pos = self.Pos + offsetTotal;
		-- self:SetNumberValue("MagOffsetX", offsetTotal.X);
		-- self:SetNumberValue("MagOffsetY", offsetTotal.Y);
		
		if self.reloadingVectorTarget then
			self.reloadingVector = self.reloadingVector + ((self.reloadingVectorTarget - self.reloadingVector) * TimerMan.DeltaTimeSecs * 2.5)
			self.StanceOffset = Vector(self.originalStanceOffset.X, self.originalStanceOffset.Y) + stance + self.reloadingVector
			self.SharpStanceOffset = Vector(self.originalSharpStanceOffset.X, self.originalSharpStanceOffset.Y) + stance + self.reloadingVector
		else
			self.reloadingVector = Vector(0, 0)
			self.StanceOffset = Vector(self.originalStanceOffset.X, self.originalStanceOffset.Y) + stance
			self.SharpStanceOffset = Vector(self.originalSharpStanceOffset.X, self.originalSharpStanceOffset.Y) + stance
		end
	end
	
	if self.canSmoke and not self.FireTimer:IsPastSimMS(1500) then

		if self.smokeDelayTimer:IsPastSimMS(120) then
			
			local poof = CreateMOSParticle("Tiny Smoke Ball 1");
			poof.Pos = self.Pos + Vector(self.MuzzleOffset.X * self.FlipFactor, self.MuzzleOffset.Y):RadRotate(self.RotAngle);
			poof.Lifetime = poof.Lifetime * RangeRand(0.3, 1.3) * 0.9;
			poof.Vel = self.Vel * 0.1
			poof.GlobalAccScalar = RangeRand(0.9, 1.0) * -0.4; -- Go up and down
			MovableMan:AddParticle(poof);
			self.smokeDelayTimer:Reset()
		end
	end
end