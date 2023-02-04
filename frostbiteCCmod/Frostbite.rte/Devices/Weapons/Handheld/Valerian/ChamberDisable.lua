function OnDetach(self)

	self:DisableScript("Frostbite.rte/Devices/Weapons/Handheld/Valerian/Chamber.lua");
	self.ReloadTime = 5000;
	self.Frame = 0;
	
end

function OnAttach(self)

	self:EnableScript("Frostbite.rte/Devices/Weapons/Handheld/Valerian/Chamber.lua");
	
end