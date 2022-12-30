
------------------------------------------------------------

-- tons of credit to fil for the precursor to this, RealBullet

------------------------------------------------------------









function Create(self)

	self.bulletWeightClass = self:GetStringValue("BulletWeightClass");

	self.terrainSounds = {
	Impact = {[12] = CreateSoundContainer(self.bulletWeightClass .. " Bullet Impact Concrete Frostbite", "Frostbite.rte"),
			[164] = CreateSoundContainer(self.bulletWeightClass .. " Bullet Impact Concrete Frostbite", "Frostbite.rte"),
			[177] = CreateSoundContainer(self.bulletWeightClass .. " Bullet Impact Concrete Frostbite", "Frostbite.rte"),
			[9] = CreateSoundContainer(self.bulletWeightClass .. " Bullet Impact Dirt Frostbite", "Frostbite.rte"),
			[10] = CreateSoundContainer(self.bulletWeightClass .. " Bullet Impact Dirt Frostbite", "Frostbite.rte"),
			[11] = CreateSoundContainer(self.bulletWeightClass .. " Bullet Impact Dirt Frostbite", "Frostbite.rte"),
			[128] = CreateSoundContainer(self.bulletWeightClass .. " Bullet Impact Dirt Frostbite", "Frostbite.rte"),
			[6] = CreateSoundContainer(self.bulletWeightClass .. " Bullet Impact Sand Frostbite", "Frostbite.rte"),
			[8] = CreateSoundContainer(self.bulletWeightClass .. " Bullet Impact Sand Frostbite", "Frostbite.rte"),
			[178] = CreateSoundContainer(self.bulletWeightClass .. " Bullet Impact SolidMetal Frostbite", "Frostbite.rte"),
			[179] = CreateSoundContainer(self.bulletWeightClass .. " Bullet Impact SolidMetal Frostbite", "Frostbite.rte"),
			[180] = CreateSoundContainer(self.bulletWeightClass .. " Bullet Impact SolidMetal Frostbite", "Frostbite.rte"),
			[181] = CreateSoundContainer(self.bulletWeightClass .. " Bullet Impact SolidMetal Frostbite", "Frostbite.rte"),
			[182] = CreateSoundContainer(self.bulletWeightClass .. " Bullet Impact SolidMetal Frostbite", "Frostbite.rte")}}
			
	self.terrainGFX = {
	Impact = {[12] = CreateMOSRotating("GFX " .. self.bulletWeightClass .. " Bullet Impact Concrete Frostbite", "Frostbite.rte"),
			[164] = CreateMOSRotating("GFX " .. self.bulletWeightClass .. " Bullet Impact Concrete Frostbite", "Frostbite.rte"),
			[177] = CreateMOSRotating("GFX " .. self.bulletWeightClass .. " Bullet Impact Concrete Frostbite", "Frostbite.rte"),
			[9] = CreateMOSRotating("GFX " .. self.bulletWeightClass .. " Bullet Impact Dirt Frostbite", "Frostbite.rte"),
			[10] = CreateMOSRotating("GFX " .. self.bulletWeightClass .. " Bullet Impact Dirt Frostbite", "Frostbite.rte"),
			[11] = CreateMOSRotating("GFX " .. self.bulletWeightClass .. " Bullet Impact Dirt Frostbite", "Frostbite.rte"),
			[128] = CreateMOSRotating("GFX " .. self.bulletWeightClass .. " Bullet Impact Dirt Frostbite", "Frostbite.rte"),
			[6] = CreateMOSRotating("GFX " .. self.bulletWeightClass .. " Bullet Impact Sand Frostbite", "Frostbite.rte"),
			[8] = CreateMOSRotating("GFX " .. self.bulletWeightClass .. " Bullet Impact Sand Frostbite", "Frostbite.rte"),
			[178] = CreateMOSRotating("GFX " .. self.bulletWeightClass .. " Bullet Impact SolidMetal Frostbite", "Frostbite.rte"),
			[179] = CreateMOSRotating("GFX " .. self.bulletWeightClass .. " Bullet Impact SolidMetal Frostbite", "Frostbite.rte"),
			[180] = CreateMOSRotating("GFX " .. self.bulletWeightClass .. " Bullet Impact SolidMetal Frostbite", "Frostbite.rte"),
			[181] = CreateMOSRotating("GFX " .. self.bulletWeightClass .. " Bullet Impact SolidMetal Frostbite", "Frostbite.rte"),
			[182] = CreateMOSRotating("GFX " .. self.bulletWeightClass .. " Bullet Impact SolidMetal Frostbite", "Frostbite.rte")}}
			
	self.terrainExtraGFX = {
	Impact = {[12] = CreateMOSRotating("GFX " .. self.bulletWeightClass .. " Bullet Impact Concrete Extra Frostbite", "Frostbite.rte"),
			[164] = CreateMOSRotating("GFX " .. self.bulletWeightClass .. " Bullet Impact Concrete Extra Frostbite", "Frostbite.rte"),
			[177] = CreateMOSRotating("GFX " .. self.bulletWeightClass .. " Bullet Impact Concrete Extra Frostbite", "Frostbite.rte"),
			[9] = CreateMOSRotating("GFX " .. self.bulletWeightClass .. " Bullet Impact Dirt Extra Frostbite", "Frostbite.rte"),
			[10] = CreateMOSRotating("GFX " .. self.bulletWeightClass .. " Bullet Impact Dirt Extra Frostbite", "Frostbite.rte"),
			[11] = CreateMOSRotating("GFX " .. self.bulletWeightClass .. " Bullet Impact Dirt Extra Frostbite", "Frostbite.rte"),
			[128] = CreateMOSRotating("GFX " .. self.bulletWeightClass .. " Bullet Impact Dirt Extra Frostbite", "Frostbite.rte"),
			[6] = CreateMOSRotating("GFX " .. self.bulletWeightClass .. " Bullet Impact Sand Extra Frostbite", "Frostbite.rte"),
			[8] = CreateMOSRotating("GFX " .. self.bulletWeightClass .. " Bullet Impact Sand Extra Frostbite", "Frostbite.rte"),
			[178] = CreateMOSRotating("GFX " .. self.bulletWeightClass .. " Bullet Impact SolidMetal Extra Frostbite", "Frostbite.rte"),
			[179] = CreateMOSRotating("GFX " .. self.bulletWeightClass .. " Bullet Impact SolidMetal Extra Frostbite", "Frostbite.rte"),
			[180] = CreateMOSRotating("GFX " .. self.bulletWeightClass .. " Bullet Impact SolidMetal Extra Frostbite", "Frostbite.rte"),
			[181] = CreateMOSRotating("GFX " .. self.bulletWeightClass .. " Bullet Impact SolidMetal Extra Frostbite", "Frostbite.rte"),
			[182] = CreateMOSRotating("GFX " .. self.bulletWeightClass .. " Bullet Impact SolidMetal Extra Frostbite", "Frostbite.rte")}}
	
	self.origTeam = self.Team;
	
	for i = 1, math.random(1,3) do
		local poof = CreateMOSParticle(math.random(1,2) < 2 and "Tiny Smoke Ball 1" or "Small Smoke Ball 1");
		poof.Pos = self.Pos
		poof.Vel = Vector(self.Vel.X, self.Vel.Y):RadRotate(math.pi * RangeRand(-1, 1) * 0.05) * RangeRand(0.1, 0.9) * 0.4;
		poof.Lifetime = poof.Lifetime * RangeRand(0.9, 1.6) * 0.2
		MovableMan:AddParticle(poof);
	end
	for i = 1, math.random(1,2) do
		local poof = CreateMOSParticle("Tiny Smoke Ball 1");
		poof.Pos = self.Pos
		poof.Vel = (Vector(self.Vel.X, self.Vel.Y):RadRotate(math.pi * (math.random(0,1) * 2.0 - 1.0) * 0.5 + math.pi * RangeRand(-1, 1) * 0.15) * RangeRand(0.1, 0.9) * 0.3 + Vector(self.Vel.X, self.Vel.Y):RadRotate(math.pi * RangeRand(-1, 1) * 0.15) * RangeRand(0.1, 0.9) * 0.2) * 0.5;
		poof.Lifetime = poof.Lifetime * RangeRand(0.9, 1.6) * 0.2
		MovableMan:AddParticle(poof);
	end
	
	self.Vel = Vector(self.Vel.X, self.Vel.Y) * RangeRand(0.9,1.1)
	self.canTravel = true
	self.ricochetCount = 0
	self.ricochetCountMax = self:NumberValueExists("RicochetCountMax") and self:GetNumberValue("RicochetCountMax") or 1
	
	self.tracer = 3 * math.random(0,1)
	self.smoke = false
	
	--if self.smoke then
	-- FANCY TRAIL BY FILIPEX2000
	self.trailM = 0; -- DONT TOUCH
	self.trailMTarget = RangeRand(-1,1);
	self.trailMProgress = 0; -- DONT TOUCH
	
	self.trailGProgress = 0; -- DONT TOUCH
	self.trailGLoss = -0.5; -- Trail lifetime offset (lower number, stays 100% longer)
	
	-- FINE TUNE!
	self.LifetimeMulti = 0.9; -- How long the particles stay alive
	self.TrailRandomnessMulti = 0.5; -- Wave modulation target speed
	self.TrailWavenessSpeed = 0.5; -- Wave modulation controller speed
	--end
end

function Update(self)
	self.Vel = Vector(self.Vel.X, self.Vel.Y) + SceneMan.GlobalAcc * TimerMan.DeltaTimeSecs
	
	if self.canTravel then
		local travelVel = (Vector(self.Vel.X, self.Vel.Y) * GetPPM() * TimerMan.DeltaTimeSecs)--:RadRotate(RangeRand(-1,1) * 0.05) -- Weird effect
		local travel = travelVel
		
		local endPos = Vector(self.Pos.X, self.Pos.Y); -- This value is going to be overriden by function below, this is the end of the ray
		self.ray = SceneMan:CastObstacleRay(self.Pos, travelVel, Vector(0, 0), endPos, 0 , self.Team, 0, 2)
		
		travel = SceneMan:ShortestDistance(self.Pos,endPos,SceneMan.SceneWrapsX)
		
		-- Tracer Trail
		
		if (math.random(1,5) <= 2) then
			local maxi = travel.Magnitude/ GetPPM() * 1.5
			for i = 0, maxi do
				--PrimitiveMan:DrawCirclePrimitive(self.Pos + travel / maxi * i, 2 + i / maxi * 3, 166);
				local particle = CreateMOPixel("Frostbite Hitscan Glow");
				particle.Pos = self.Pos + travel / maxi * i * RangeRand(1.1,0.9);
				--particle.Vel = travel:SetMagnitude(30)
				--particle.EffectRotAngle = self.RotAngle;
				particle.EffectRotAngle = self.Vel.AbsRadAngle;
				MovableMan:AddParticle(particle);
			end
			self.tracer = self.tracer - 1
			if not self.smoke then
				self.smoke = math.random(1,8) < 2
			end
		end
		
		--PrimitiveMan:DrawLinePrimitive(self.Pos, self.Pos + travel, 5);
		if self.ray > -1 then
			local canDamage = false
			local hitTerrain = false;
			self.Pos = endPos
			
			self.Vel = self.Vel * 0.85
			local hitMO = false
			for i = -1, 1 do
				local checkOrigin = Vector(self.Pos.X, self.Pos.Y) + Vector(self.Vel.X,self.Vel.Y):SetMagnitude(i)
				local checkPix = SceneMan:GetMOIDPixel(checkOrigin.X, checkOrigin.Y)
				if checkPix and checkPix ~= rte.NoMOID and MovableMan:GetMOFromID(checkPix).Team ~= self.Team then
					local MO = ToMOSRotating(MovableMan:GetMOFromID(checkPix))
					self.MOHit = MO;
					local woundName = MO:GetEntryWoundPresetName()
					local woundNameExit = MO:GetExitWoundPresetName()
					hitMO = true
					self.woundOffset = (SceneMan:ShortestDistance(MO.Pos, checkOrigin + Vector(self.Vel.X, self.Vel.Y):SetMagnitude(1), SceneMan.SceneWrapsX)):RadRotate(MO.RotAngle * -1.0)
						
					break
				end
			end
			local hitVel = Vector(self.Vel.X, self.Vel.Y)
			if hitMO then-- check MOs first
				canDamage = true
				self.ToDelete = true
			else -- ricochet
				if self.ricochetCount < self.ricochetCountMax then
					-- Normal approximation by filipex2000
					-- Does magic stuff
					-- haxx
					--self.canTravel = false
					local detections = 0
					local maxi = 7
					local normal = Vector(0,0)
					local materialStrength = 0
					local materialID = 0
					for i = 0, maxi do
						local checkVec = Vector(3,0):RadRotate(math.pi * 2 / maxi * i)
						local checkOrigin = Vector(self.Pos.X, self.Pos.Y) + checkVec
						local checkPix = SceneMan:GetTerrMatter(checkOrigin.X, checkOrigin.Y)
						--[[
						if checkPix > 0 then
							PrimitiveMan:DrawLinePrimitive(self.Pos + checkVec, self.Pos + checkVec, 13);
						else
							PrimitiveMan:DrawLinePrimitive(self.Pos + checkVec, self.Pos + checkVec, 5);
							normal = (Vector(normal.X, normal.Y) + Vector(checkVec.X, checkVec.Y)) * 0.5
						end]]
						if checkPix == 0 then
							normal = (Vector(normal.X, normal.Y) + Vector(checkVec.X, checkVec.Y)) * 0.5
						else
							materialStrength = materialStrength + SceneMan:GetMaterialFromID(checkPix).StructuralIntegrity
							detections = detections + 1
							materialID = checkPix
						end
					end
					-- Compare Materials
					local material = SceneMan:GetMaterialFromID(materialID)
					self.hitTerrainType = materialID
					
					if detections > 0 then
						materialStrength = math.min(materialStrength / maxi / 132, 1)
						normal = normal:SetMagnitude(1.0)
						normal = normal:RadRotate(RangeRand(-1,1) * 0.2) --Randomize normal to spice things up
						--PrimitiveMan:DrawLinePrimitive(self.Pos, self.Pos + normal * 5.0, 122); -- Debug
						local diff = normal - Vector(self.Vel.X, self.Vel.Y):SetMagnitude(1.0)
						self.Vel = (Vector(self.Vel.X, self.Vel.Y) * RangeRand(0.4,0.8) + normal:SetMagnitude(self.Vel.Magnitude) * RangeRand(0.1,0.4)) * RangeRand(0.5,1.0) * materialStrength
						
						self.ricochetCount = self.ricochetCount + 1
						self.smoke = math.random(1,2) < 2
						if self.Vel.Magnitude < 10 then
							self.ToDelete = true
							canDamage = true
						else
							canDamage = true
						end
					else
						canDamage = true
						self.ToDelete = true
					end
				else
					self.ToDelete = true
				end
			end
			
			if canDamage then
				local maxi = 1
				if self:NumberValueExists("Wounds") then
					maxi = self:GetNumberValue("Wounds");
				end
				for i = 1, maxi do
					local pixel = CreateMOPixel("Frostbite Hitscan Damage");
					pixel.Vel = Vector(hitVel.X, hitVel.Y) * 0.6;--Vector(self.Vel.X, self.Vel.Y) * 0.6;
					pixel.Sharpness = self.Sharpness
					pixel.Mass = self.Mass
					pixel.Pos = self.Pos - Vector(self.Vel.X,self.Vel.Y):SetMagnitude(2)--self.Pos - Vector(2, 0):RadRotate(self.RotAngle);
					pixel.Team = self.Team
					pixel.IgnoresTeamHits = true;
					
					pixel.WoundDamageMultiplier = self:GetNumberValue("WoundDamageMultiplier");
					MovableMan:AddParticle(pixel);
				end
				
				if self.hitTerrainType then
					if self.hitTerrainType ~= 0 then -- 0 = air
						if self.terrainSounds.Impact[self.hitTerrainType] ~= nil then
							self.terrainSounds.Impact[self.hitTerrainType]:Play(self.Pos);
						end
						if self.terrainGFX.Impact[self.hitTerrainType] ~= nil then
							local GFX = self.terrainGFX.Impact[self.hitTerrainType]:Clone()
							GFX.Pos = self.Pos
							GFX.Vel = Vector(self.Vel.X, self.Vel.Y):DegRotate(math.random(-10, 10));
							MovableMan:AddParticle(GFX)
							if math.random(0, 100) < 20 then
								local extraGFX = self.terrainExtraGFX.Impact[self.hitTerrainType]:Clone()
								extraGFX.Pos = self.Pos
								extraGFX.Vel = Vector(self.Vel.X, self.Vel.Y):DegRotate(math.random(-10, 10));
								MovableMan:AddParticle(extraGFX)
							end
						else
							local GFX = self.terrainGFX.Impact[177]:Clone()
							GFX.Pos = self.Pos
							GFX.Vel = self.Vel
							MovableMan:AddParticle(GFX)
						end				
					end		
				end
			end
			
			if self.Vel.Magnitude < 10 then
				self.ToDelete = true
			end
		else
			self.Pos = endPos
		end
		
		-- Epic Trail
		
		local smoke
		local offset = travel
		local trailLength = math.floor((offset.Magnitude+0.5) / 5)
		for i = 1, trailLength do
			if RangeRand(0,1) < (1 - self.trailGLoss) then
				--smoke = CreateMOPixel("Frostbite Hitscan Micro Smoke Ball "..math.random(1,4));
				smoke = CreateMOPixel("Frostbite Micro Smoke Ball "..math.random(1,4));
				if smoke then
					
					local a = 10 * self.TrailWavenessSpeed;
					local b = 5 * self.TrailRandomnessMulti;
					self.trailM = (self.trailM + self.trailMTarget * TimerMan.DeltaTimeSecs * a) / (1 + TimerMan.DeltaTimeSecs * a)
					self.trailMProgress = self.trailMProgress + TimerMan.DeltaTimeSecs * b;
					if self.trailMProgress > 1 then
						self.trailMTarget = RangeRand(-1,1);
						self.trailMProgress = self.trailMProgress - 1;
					end
					
					smoke.Pos = self.Pos - offset * (1 - (i/trailLength)) * RangeRand(0.9, 1.1);
					smoke.Vel = self.Vel * self.trailGProgress * 0.25 + Vector(0, self.trailM * 12  * RangeRand(0.9, 1.1) * self.trailGProgress):RadRotate(Vector(self.Vel.X, self.Vel.Y).AbsRadAngle);-- * RangeRand(0.5, 1.2) * 0.5;
					smoke.Lifetime = smoke.Lifetime * RangeRand(0.1, 1.9) * (1.0 + self.trailGProgress) * 0.3 * self.LifetimeMulti;
					smoke.GlobalAccScalar = RangeRand(-1, 1) * 0.15; -- Go up and down
					MovableMan:AddParticle(smoke);
					
					local c = 1;
					self.trailGProgress = math.min(self.trailGProgress + TimerMan.DeltaTimeSecs * c, 1.0)
					self.trailGLoss = math.min(self.trailGLoss + TimerMan.DeltaTimeSecs * 0.65, 1.0);
				end
			end
		end
		
	end
end



function Destroy(self)
end