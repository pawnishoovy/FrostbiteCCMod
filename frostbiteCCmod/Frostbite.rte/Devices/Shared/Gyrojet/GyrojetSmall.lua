function Create(self)

	self.flyLoop = CreateSoundContainer("Gyrojet Small Fly Loop Frostbite", "Frostbite.rte");
	self.flyLoop:Play(self.Pos);
	
	self.engageSound = CreateSoundContainer("Gyrojet Small Engage Frostbite", "Frostbite.rte");

	self.width = math.floor(ToMOSprite(self):GetSpriteWidth() * 0.5 + 0.5);
	self.woundCountMultiplier = self:NumberValueExists("WoundCountMultiplier") and self:GetNumberValue("WoundCountMultiplier") or 1;
	
	self.homingStrength = 85;
	
	if self:NumberValueExists("TargetID") and self:GetNumberValue("TargetID") ~= rte.NoMOID then
		local mo = MovableMan:GetMOFromID(self:GetNumberValue("TargetID"));
		if mo and IsActor(mo) then
			self.target = ToActor(mo);
			self.targetPos = mo.Pos;
			
			-- see if the angle we've been fired at is extreme, and if so initiate a delay before homing kicks in
			
			local dif = SceneMan:ShortestDistance(self.Pos,self.targetPos,SceneMan.SceneWrapsX);
			
			local angToTarget = dif.AbsRadAngle			
			
			local velAngleTest = Vector(self.Vel.X, self.Vel.Y):SetMagnitude(100)-- + SceneMan.GlobalAcc
			local velAngleTestTarget = Vector(100, 0):RadRotate(angToTarget)
			local velTestDif = velAngleTestTarget - velAngleTest
			
			if velTestDif.Magnitude > 65 then
				self.homingDelayTimer = Timer();
				self.homingDelay = 100;
				self.homingStrength = 160;
				
				self.engageSound = CreateSoundContainer("Gyrojet Small Engage Turn Frostbite", "Frostbite.rte");
				
			end
			
		end
	end

end
function Update(self)

	local Effect = CreateMOPixel("Micro Smoke Ball 1", "Frostbite.rte")
	Effect.Pos = self.Pos;
	MovableMan:AddParticle(Effect)

	self.GlobalAccScalar = 0
	
	self.flyLoop.Pos = self.Pos;
	
	if self.target and ((not self.homingDelayTimer) or (self.homingDelayTimer:IsPastSimMS(self.homingDelay))) then
		if not self.engagePlayed then
			self.engagePlayed = true;
			self.engageSound:Play(self.Pos);
		end
		self.engageSound.Pos = self.Pos;
		self.flyLoop.Pos = self.Pos;
		
		local dif = SceneMan:ShortestDistance(self.Pos,self.targetPos,SceneMan.SceneWrapsX);
		
		local angToTarget = dif.AbsRadAngle
		
		local velCurrent = self.Vel-- + SceneMan.GlobalAcc
		local velTarget = Vector(70, 0):RadRotate(angToTarget)
		velTarget = velTarget:RadRotate(angToTarget * 0.01)
		--PrimitiveMan:DrawLinePrimitive(self.Pos, self.Pos + velTarget,  5);
		local velDif = velTarget - velCurrent
		
		--print(velDif.Magnitude)
		
		-- acceleration
		self.Vel = self.Vel + (velDif:SetMagnitude(math.max(velDif.Magnitude, self.homingStrength)) * TimerMan.DeltaTimeSecs * 4)
	end

end

function OnCollideWithMO(self, mo, rootMO)
	self.flyLoop:Stop(-1);
	if not self.hit then
		local hitPos = Vector(self.PrevPos.X, self.PrevPos.Y);
	--	PrimitiveMan:DrawLinePrimitive(self.PrevPos, self.PrevPos + self.PrevVel,  5);
		if SceneMan:CastFindMORay(self.PrevPos, self.PrevVel * rte.PxTravelledPerFrame, mo.ID, hitPos, rte.airID, true, 1) then
			self.hit = true;
			local penetration = (self.Mass * self.PrevVel.Magnitude * self.Sharpness)/math.max(mo.Material.StructuralIntegrity, 1);
			if penetration > 1 then
				local dist = SceneMan:ShortestDistance(mo.Pos, hitPos, SceneMan.SceneWrapsX);
				
				local stickOffset = Vector(dist.X * mo.FlipFactor, dist.Y):RadRotate(-mo.RotAngle * mo.FlipFactor);
				local setAngle = stickOffset.AbsRadAngle - (mo.HFlipped and math.pi or 0);
				local setOffset = Vector(stickOffset.X, stickOffset.Y):SetMagnitude(stickOffset.Magnitude - self.width);
				
				for i = 1, self.woundCountMultiplier do
					local woundName = mo:GetEntryWoundPresetName();
					if woundName ~= "" then
						local wound = CreateAEmitter(woundName);
						wound.DamageMultiplier = self.WoundDamageMultiplier;
						wound.InheritedRotAngleOffset = setAngle;
						mo:AddWound(wound, setOffset, true);
					end
					
					if penetration > 2 then
						woundName = mo:GetExitWoundPresetName();
						if woundName ~= "" then
							local wound = CreateAEmitter(woundName);
							wound.DamageMultiplier = self.WoundDamageMultiplier;
							wound.InheritedRotAngleOffset = setAngle;
							wound.DrawAfterParent = true;
							mo:AddWound(wound, setOffset, true);
						end
					end
				end
			end
			self.ToDelete = true;
			self:GibThis();
		end
	end
end

function OnCollideWithTerrain(self)

	self.flyLoop:Stop(-1);
	self:GibThis();
	
end

function Destroy(self)

	self.flyLoop:Stop(-1);
	
end