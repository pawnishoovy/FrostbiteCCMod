function Create(self)

	self.parentSet = false;
	
	-- Sounds --
	
	self.preSound = CreateSoundContainer("Pre NC2111", "Frostbite.rte");
	self.reflectionIndoorsSound = CreateSoundContainer("ReflectionIndoors NC2111", "Frostbite.rte");
	self.reflectionOutdoorsSound = CreateSoundContainer("ReflectionOutdoors NC2111", "Frostbite.rte");
	
	self.reloadPrepareSounds = {}
	self.reloadPrepareSounds.MagOut = nil;
	self.reloadPrepareSounds.MagIn = CreateSoundContainer("MagInPrepare NC2111", "Frostbite.rte");
	self.reloadPrepareSounds.BoltBack = nil;
	self.reloadPrepareSounds.BoltForward = nil;
	
	self.reloadPrepareLengths = {}
	self.reloadPrepareLengths.MagOut = 0
	self.reloadPrepareLengths.MagIn = 280
	self.reloadPrepareLengths.BoltBack = 0
	self.reloadPrepareLengths.BoltForward = 0
	
	self.reloadPrepareDelay = {}
	self.reloadPrepareDelay.MagOut = 100
	self.reloadPrepareDelay.MagIn = 600
	self.reloadPrepareDelay.BoltBack = 50
	self.reloadPrepareDelay.BoltForward = 65
	
	self.reloadAfterSounds = {}
	self.reloadAfterSounds.MagOut = CreateSoundContainer("MagOut NC2111", "Frostbite.rte");
	self.reloadAfterSounds.MagIn = CreateSoundContainer("MagIn NC2111", "Frostbite.rte");
	self.reloadAfterSounds.BoltBack = CreateSoundContainer("BoltBack NC2111", "Frostbite.rte");
	self.reloadAfterSounds.BoltForward = CreateSoundContainer("BoltForward NC2111", "Frostbite.rte");
	
	self.reloadAfterDelay = {}
	self.reloadAfterDelay.MagOut = 100
	self.reloadAfterDelay.MagIn = 65
	self.reloadAfterDelay.BoltBack = 150
	self.reloadAfterDelay.BoltForward = 600
	
	self.lastAge = self.Age
	
	self.originalSharpLength = self.SharpLength
	
	self.originalStanceOffset = Vector(math.abs(self.StanceOffset.X), self.StanceOffset.Y)
	self.originalSharpStanceOffset = Vector(self.SharpStanceOffset.X, self.SharpStanceOffset.Y)
	
	self.rotation = 0
	self.rotationTarget = 0
	self.rotationSpeed = 9
	
	self.reloadSupportOffsetTarget = Vector(0, 0);
	self.reloadSupportOffsetSpeed = 20
	
	self.reloadingVector = Vector(0, 0)
	
	self.horizontalAnim = 0
	self.verticalAnim = 0
	
	self.angVel = 0
	self.lastRotAngle = self.RotAngle
	
	self.FireTimer = Timer();
	self.smokeDelayTimer = Timer();
	self.canSmoke = false
	
	self.reloadTimer = Timer();
	
	self.reloadPhase = 0;
	
	self.ReloadTime = 9999;
	
	self.fireDelayTimer = Timer();
	self.delayedFire = false
	self.delayedFireTimer = Timer();
	self.delayedFireTimeMS = 70
	self.delayedFireEnabled = true
	self.activated = false
	
	-- Progressive Recoil System 
	self.recoilAcc = 0 -- for sinous
	self.recoilStr = 0 -- for accumulator
	self.recoilStrength = 15 -- multiplier for base recoil added to the self.recoilStr when firing
	self.recoilPowStrength = 0.2 -- multiplier for self.recoilStr when firing
	self.recoilRandomUpper = 2 -- upper end of random multiplier (1 is lower)
	self.recoilDamping = 0.8
	
	self.recoilMax = 4 -- in deg.
	self.originalSharpLength = self.SharpLength
	-- Progressive Recoil System 
	
	
	-- Frostbite Smartgun System --
	
	self.smartGunSearchTimer = Timer();
	self.smartGunSearchDelay = 35; -- time between every single ray, NOT total time for one entire scan!
	
	self.smartGunRange = 350;
	
	self.smartGunScanCone = 20 -- in deg
	self.smartGunRayAngle = math.rad(self.smartGunScanCone/2) -- in increments of 2.5 deg
	
	self.smartGunTarget = nil;
	
end

function Update(self)
	self.Frame = 0;
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
	
	-- SLIDE animation when firing
	-- don't ask, math magic
	local f = math.max(1 - math.min((self.FireTimer.ElapsedSimTimeMS) / 200, 1), 0)
	self.Frame = math.floor(f * 3 + 0.55);

	-- PAWNIS RELOAD ANIMATION HERE
	if self:IsReloading() then

		self.fireDelayTimer:Reset()
		self.activated = false;
		self.delayedFire = false;	

		if self.reloadPhase == 0 then
		
			self.reloadSupportOffsetSpeed = 16
		
			self.reloadSupportOffsetTarget = Vector(-4, 5)
		
			self.reloadingVectorTarget = Vector(2, -2);
		
			self.reloadDelay = self.reloadPrepareDelay.MagOut;
			self.afterDelay = self.reloadAfterDelay.MagOut;		
			
			self.prepareSound = self.reloadPrepareSounds.MagOut;
			self.prepareSoundLength = self.reloadPrepareLengths.MagOut;
			self.afterSound = self.reloadAfterSounds.MagOut;
			
			self.rotationTarget = 25;
			
		elseif self.reloadPhase == 1 then
			
			self.reloadDelay = self.reloadPrepareDelay.BoltBack;
			self.afterDelay = self.reloadAfterDelay.BoltBack;		
			
			self.prepareSound = self.reloadPrepareSounds.BoltBack;
			self.prepareSoundLength = self.reloadPrepareLengths.BoltBack;
			self.afterSound = self.reloadAfterSounds.BoltBack;
			
			self.rotationTarget = 30;
			
		elseif self.reloadPhase == 2 then
		
			if self.chamberOnReload then
				self.Frame = 2;
			end
		
			self.reloadSupportOffsetTarget = Vector(-4, 8)
		
			self.reloadDelay = self.reloadPrepareDelay.MagIn;
			self.afterDelay = self.reloadAfterDelay.MagIn;		
			
			self.prepareSound = self.reloadPrepareSounds.MagIn;
			self.prepareSoundLength = self.reloadPrepareLengths.MagIn;
			self.afterSound = self.reloadAfterSounds.MagIn;
			
			self.rotationTarget = 20;
		
		elseif self.reloadPhase == 3 then
			self.Frame = 2;
			
			self.reloadSupportOffsetTarget = Vector(-4.5, 5)
			self.reloadingVectorTarget = Vector(0, 0);
			
			self.reloadDelay = self.reloadPrepareDelay.BoltForward;
			self.afterDelay = self.reloadAfterDelay.BoltForward;		
			
			self.prepareSound = self.reloadPrepareSounds.BoltForward;
			self.prepareSoundLength = self.reloadPrepareLengths.BoltForward;
			self.afterSound = self.reloadAfterSounds.BoltForward;
			
			self.rotationTarget = 0;
			
		end
		
		if self.reloadTimer:IsPastSimMS(self.reloadDelay - self.prepareSoundLength) and self.prepareSoundPlayed ~= true then
			self.prepareSoundPlayed = true;
			if self.prepareSound then
				self.prepareSound:Play(self.Pos)
			end
		end
	
		if self.reloadTimer:IsPastSimMS(self.reloadDelay) then
		
			if self.reloadPhase == 0 then
			
				if self.chamberOnReload then
					self.phaseOnStop = 1
				else
					self.phaseOnStop = 2;
				end
			
				self.reloadSupportOffsetTarget = Vector(-5, 9)
			
				self:SetNumberValue("MagRemoved", 1);
				
			elseif self.reloadPhase == 1 then
			
				self.phaseOnStop = 2;
			
				if self.reloadTimer:IsPastSimMS(self.reloadDelay + ((self.afterDelay/5)*3)) then
					self.Frame = 2;
				elseif self.reloadTimer:IsPastSimMS(self.reloadDelay + ((self.afterDelay/5)*2)) then
					self.Frame = 1;
				elseif self.reloadTimer:IsPastSimMS(self.reloadDelay + ((self.afterDelay/5)*1)) then
					self.Frame = 0;
				end				
				
			elseif self.reloadPhase == 2 then
			
				if self.chamberOnReload then
					self.phaseOnStop = 3;
				end
			
				self.reloadSupportOffsetTarget = Vector(-4, 4)
			
				self:RemoveNumberValue("MagRemoved");
				
			elseif self.reloadPhase == 3 then
				if self.reloadTimer:IsPastSimMS(self.reloadDelay + ((self.afterDelay/5)*1.2)) then
					self.Frame = 0;
				elseif self.reloadTimer:IsPastSimMS(self.reloadDelay + ((self.afterDelay/5)*0.9)) then
					self.Frame = 1;
				elseif self.reloadTimer:IsPastSimMS(self.reloadDelay + ((self.afterDelay/5)*0.6)) then
					self.Frame = 2;
				end
			end
			
			if self.afterSoundPlayed ~= true then
			
				if self.reloadPhase == 0 then
					local fake
					fake = CreateMOSRotating("Fake Magazine MOSRotating NC2111");
					fake.Pos = self.Pos + Vector(-5 * self.FlipFactor, 2):RadRotate(self.RotAngle);
					fake.Vel = self.Vel + Vector(0.5*self.FlipFactor, 2):RadRotate(self.RotAngle);
					fake.RotAngle = self.RotAngle;
					fake.AngularVel = self.AngularVel + (-1*self.FlipFactor);
					fake.HFlipped = self.HFlipped;
					MovableMan:AddParticle(fake);
					
					self.angVel = self.angVel + 2;
					self.verticalAnim = self.verticalAnim + 1
					
				elseif self.reloadPhase == 1 then
					self.horizontalAnim = self.horizontalAnim + 1;
					self.angVel = self.angVel - 15;
					self.phaseOnStop = 2;
					
				elseif self.reloadPhase == 2 then
					if self.chamberOnReload then
						self.phaseOnStop = 3;
					else
						self.ReloadTime = 0; -- done! no after delay if non-chambering reload.
						self.reloadPhase = 0;
						self.phaseOnStop = nil;
						self.reloadingVectorTarget = nil;
						self.rotationSpeed = 9
					end
					self.angVel = self.angVel - 2;
					self.verticalAnim = self.verticalAnim - 1	
					self:RemoveNumberValue("MagRemoved");
					
				elseif self.reloadPhase == 3 then
					self.horizontalAnim = self.horizontalAnim + 1;
					self.angVel = self.angVel + 35;
					self.phaseOnStop = nil;
				else
					self.phaseOnStop = nil;
				end
			
				self.afterSoundPlayed = true;
				if self.afterSound then
					self.afterSound:Play(self.Pos);
				end
			end
			if self.reloadTimer:IsPastSimMS(self.reloadDelay + self.afterDelay) then
				self.reloadTimer:Reset();
				self.prepareSoundPlayed = false;
				self.afterSoundPlayed = false;
				if self.reloadPhase == 0 then
					if self.chamberOnReload then
						self.reloadPhase = self.reloadPhase + 1;
					else
						self.reloadPhase = 2;
					end
				elseif self.reloadPhase == 2 and self.chamberOnReload then
					self.reloadPhase = self.reloadPhase + 1;
				elseif self.reloadPhase == 3 then
					self.ReloadTime = 0;
					self.reloadPhase = 0;
					self.reloadingVectorTarget = nil;
					self.rotationSpeed = 9
				else
					self.reloadPhase = self.reloadPhase + 1;
				end
			end
		end		
	else
		
		self.reloadTimer:Reset();
		self.prepareSoundPlayed = false;
		self.afterSoundPlayed = false;
		if self.phaseOnStop then
			self.reloadPhase = self.phaseOnStop;
			self.phaseOnStop = nil;
		end
		if self.reloadPhase == 3 then
			self.reloadPhase = 2;
		end
		self.ReloadTime = 9999;
	end
	
	if self:DoneReloading() == true and self.chamberOnReload then
		self.fireDelayTimer:Reset()
		self.chamberOnReload = false;
		self.Magazine.RoundCount = 7;
	elseif self:DoneReloading() then
		self.fireDelayTimer:Reset()
		self.chamberOnReload = false;
		self.Magazine.RoundCount = 8;
	end	


	local fire = self:IsActivated() and self.RoundInMagCount > 0;
	
	if self.RoundInMagCount > 0 then
		self:Deactivate()
	end

	if self.parent and self.delayedFirstShot == true then
		
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
	
		local shot = CreateMOSRotating("Frostbite Gyrojet Small", "Frostbite.rte");
		shot.Pos = self.MuzzlePos + Vector(2 * self.FlipFactor,0):RadRotate(self.RotAngle);
		shot.RotAngle = self.RotAngle
		shot.HFlipped = self.HFlipped
		shot.Vel = self.Vel + Vector(60 * self.FlipFactor,0):RadRotate(self.RotAngle);
		shot.Team = self.Team;
		shot.IgnoresTeamHits = true;
		shot:SetNumberValue("WoundCountMultiplier", 2);
		if self.smartGunTarget then
			shot:SetNumberValue("TargetID", self.smartGunTarget.ID);
		end
		MovableMan:AddParticle(shot);
	
		self.horizontalAnim = 5;
	
		self.FireTimer:Reset();
	
		self.angVel = self.angVel - RangeRand(0.7,1.1) * 7
		
		self.canSmoke = true
		
		if self.RoundInMagCount > 0 then
		else
			self.chamberOnReload = true;
		end
		
		for i = 1, 3 do
			local Effect = CreateMOSParticle("Tiny Smoke Ball 1", "Base.rte")
			if Effect then
				Effect.Pos = self.MuzzlePos;
				Effect.Vel = (self.Vel + Vector(RangeRand(-20,20), RangeRand(-20,20)) + Vector(150*self.FlipFactor,0):RadRotate(self.RotAngle)) / 30
				MovableMan:AddParticle(Effect)
			end
		end
		
		local Effect = CreateMOSParticle("Side Thruster Blast Ball 1", "Base.rte")
		if Effect then
			Effect.Pos = self.MuzzlePos;
			Effect.Vel = (self.Vel + Vector(150*self.FlipFactor,0):RadRotate(self.RotAngle)) / 10
			MovableMan:AddParticle(Effect)
		end

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
	
		-- FROSTBITE SMARTGUN SYSTEM --
		
		if self.smartGunTarget then -- target already acquired
		
			PrimitiveMan:DrawCirclePrimitive(self.smartGunTarget.Pos, 10, 122)
		
			if self.smartGunSearchTimer:IsPastSimMS(self.smartGunSearchDelay * 10) then
				-- check that target is still in view
				
				if SceneMan:CastStrengthSumRay(self.MuzzlePos, self.smartGunTarget.Pos, 3, 0) < 15 then			
					-- still in view, do nothing						
				else				
					self.smartGunTarget = nil;					
				end
				
				-- check if the player is aiming directly at a new target
				
				local smartGunRay = Vector(self.smartGunRange*1.3*self.FlipFactor, 0):RadRotate(self.RotAngle)
				local moCheck = SceneMan:CastMORay(self.MuzzlePos, smartGunRay, self.ID, self.Team, 0, false, 3); -- Raycast		
				--PrimitiveMan:DrawLinePrimitive(self.MuzzlePos, self.MuzzlePos + smartGunRay,  5);
				
				if moCheck ~= rte.NoMOID then
					local rootMO = MovableMan:GetMOFromID((MovableMan:GetMOFromID(moCheck).RootID))
					
					if IsAHuman(rootMO) then
						self.smartGunTarget = ToAHuman(rootMO);
					elseif IsACrab(rootMO) then
						self.smartGunTarget = ToACrab(rootMO);
					end
				end
				
				self.smartGunSearchTimer:Reset();
			end
				
				
		elseif self.smartGunSearchTimer:IsPastSimMS(self.smartGunSearchDelay) then

			if self.smartGunRayAngle <= math.rad(-self.smartGunScanCone/2) then
				self.smartGunRayAngle = math.rad(self.smartGunScanCone/2);
			end			
		
			self.smartGunRayAngle = (self.smartGunRayAngle - math.rad(2.5))
			local smartGunRay = Vector(self.smartGunRange*self.FlipFactor, 0):RadRotate(self.RotAngle + self.smartGunRayAngle)
			local moCheck = SceneMan:CastMORay(self.MuzzlePos, smartGunRay, self.ID, self.Team, 0, false, 3); -- Raycast		
			--PrimitiveMan:DrawLinePrimitive(self.MuzzlePos, self.MuzzlePos + smartGunRay,  5);
			
			if moCheck ~= rte.NoMOID then
				local rootMO = MovableMan:GetMOFromID((MovableMan:GetMOFromID(moCheck).RootID))
				
				if IsAHuman(rootMO) then
					self.smartGunTarget = ToAHuman(rootMO);
				elseif IsACrab(rootMO) then
					self.smartGunTarget = ToACrab(rootMO);
				end
			end
			
			self.smartGunSearchTimer:Reset();
		end
		
		-- END FROSTBITE SMARTGUN SYSTEM -- 
			
	
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
		self.ReloadSupportOffset = self.ReloadSupportOffset + ((self.reloadSupportOffsetTarget - self.ReloadSupportOffset) * TimerMan.DeltaTimeSecs * self.reloadSupportOffsetSpeed)
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