function OnDetach(self)

	self:DisableScript("Frostbite.rte/Devices/Weapons/Handheld/Tulbur/Chamber.lua");
	self.BaseReloadTime = 9999;
	
end

function OnAttach(self)

	self:EnableScript("Frostbite.rte/Devices/Weapons/Handheld/Tulbur/Chamber.lua");
	
end