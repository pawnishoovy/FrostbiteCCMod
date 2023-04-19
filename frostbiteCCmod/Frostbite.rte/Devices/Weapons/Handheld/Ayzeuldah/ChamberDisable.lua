function OnDetach(self)

	self:DisableScript("Frostbite.rte/Devices/Weapons/Handheld/Ayzeuldah/Chamber.lua");
	self.ReloadTime = 9999;
	self.Frame = self.boltLockedBack and 1 or 0;
	
end

function OnAttach(self)

	self:EnableScript("Frostbite.rte/Devices/Weapons/Handheld/Ayzeuldah/Chamber.lua");
	
end