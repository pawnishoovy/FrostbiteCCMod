function OnDetach(self)

	self:DisableScript("Frostbite.rte/Devices/Weapons/Handheld/NC2111/Chamber.lua");
	self.ReloadTime = 5000;
	self.Frame = 0;
	
end

function OnAttach(self)

	self:EnableScript("Frostbite.rte/Devices/Weapons/Handheld/NC2111/Chamber.lua");
	
end