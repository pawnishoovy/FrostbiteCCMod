function Create(self)

	self.activateSound = CreateSoundContainer("Activate RINOBI Hunter", "Frostbite.rte");
	self.beepSound = CreateSoundContainer("Beep RINOBI Hunter", "Frostbite.rte");
	self.beepFailSound = CreateSoundContainer("Beep Fail RINOBI Hunter", "Frostbite.rte");
	self.thrustSound = CreateSoundContainer("Thruster Fire RINOBI Hunter", "Frostbite.rte");
	
	self.beeps = 0
	
	self.activated = false;
	
	self.grenadeTimer = Timer();
	
end

function Update(self)


	if self:IsActivated() and self.activated == false then
		self.activated = true;
		
		--self.GibImpulseLimit = 1
		
	elseif self.thrown then
		if self.beeps == 3 and self.grenadeTimer:IsPastSimMS(130) then
			
			if self.detectionRan then
			
				if self.toFailBeep ~= false then
					self.beepFailSound:Play(self.Pos);
					self.toFailBeep = false;
				end
			
				if self.grenadeTimer:IsPastSimMS(3000) then
					self:GibThis();
				end
				
			else

				for i = 1 , MovableMan:GetMOIDCount() - 1 do
					local mo = MovableMan:GetMOFromID(i);
					if mo and mo.Team ~= self.Team and IsActor(mo) then
						local dist = SceneMan:ShortestDistance(self.Pos, mo.Pos, SceneMan.SceneWrapsX);
						if dist.Magnitude < 500 then
							local strSumCheck = SceneMan:CastStrengthSumRay(self.Pos, self.Pos + dist, 3, rte.airID);
							if strSumCheck < 10 then
							
								self.toFailBeep = false;

								self.thrustSound:Play(self.Pos);
								
								self.Vel = self.Vel / 10		

								-- spew smoke in the opposite direction
								
								for i = 1, 9 do
									local Effect = CreateMOSParticle("Tiny Smoke Ball 1", "Base.rte")
									if Effect then
										Effect.HitsMOs = false;
										Effect.Pos = self.Pos;
										Effect.Vel = dist:SetMagnitude(-40)
										MovableMan:AddParticle(Effect)
									end
								end
								
								for i = 1, 3 do
									local Effect = CreateMOSParticle("Side Thruster Blast Ball 1", "Base.rte")
									if Effect then
										Effect.HitsMOs = false;
										Effect.Pos = self.Pos;
										Effect.Vel = dist:SetMagnitude(-40)
										MovableMan:AddParticle(Effect)
									end
								end
								
								-- do what missiles do
								self.Vel = self.Vel + dist:SetMagnitude(55)		
								
								self.GibImpulseLimit = 2;

								break;
								
							end
						end
					end	
				end		
				
				self.detectionRan = true;
				
			end
			
		elseif self.grenadeTimer:IsPastSimMS(130) then
			self.grenadeTimer:Reset();
			self.beepSound:Play(self.Pos);
			self.beeps = self.beeps + 1;
		end
	end
	
end

function OnDetach(self)

	if self.activated then
	
		self.grenadeTimer:Reset();
	
		self.activateSound:Play(self.Pos);
		self.thrown = true;
		
		self.beepSound:Play(self.Pos);
		self.beeps = self.beeps + 1;
	end
end