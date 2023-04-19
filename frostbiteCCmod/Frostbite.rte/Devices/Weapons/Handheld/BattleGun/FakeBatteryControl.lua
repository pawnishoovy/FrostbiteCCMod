function Create(self)

	self.fakeBattery = nil;
	for attachable in self.Attachables do
		
		if string.find(attachable.PresetName, "Fake Battery") then
			self.fakeBattery = attachable
			self.fakeBattery.InheritsRotAngle = true
			self.fakeBattery:AddScript("Frostbite.rte/Devices/Weapons/Handheld/BattleGun/FakeBattery.lua") -- SAFE MEASURE
		end
	end
end

function Update(self)
	
	if self.fakeBattery and not self:NumberValueExists("LostFakeBattery") then
		self.fakeBattery:ClearForces();
		self.fakeBattery:ClearImpulseForces();
		
		self.fakeBattery:RemoveWounds(self.fakeBattery.WoundCount);
		
		self.fakeBattery.GetsHitByMOs = false;
			
		if self:NumberValueExists("BatteryRemoved") then
			self.fakeBattery.Frame = 0;
		else
			self.fakeBattery.Frame = 1;
		end
		-- if self:NumberValueExists("MagRotation") then
			-- self.fakeBattery.RotAngle = self.RotAngle + self:GetNumberValue("MagRotation");
		-- end
		-- if self:NumberValueExists("MagOffsetX") and self:NumberValueExists("MagOffsetY") then
			-- self.fakeBattery.Pos = self.fakeBattery.Pos + Vector(self:GetNumberValue("MagOffsetX"), self:GetNumberValue("MagOffsetY"));
		-- end
	end
	
end



