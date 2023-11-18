function OnDetach(self)

	self:DisableScript("Frostbite.rte/Devices/Weapons/Handheld/Rage/Chamber.lua");
	self.BaseReloadTime = 5000;
	self.Frame = 0;
	
end

function OnAttach(self)

	self:EnableScript("Frostbite.rte/Devices/Weapons/Handheld/Rage/Chamber.lua");
	
end