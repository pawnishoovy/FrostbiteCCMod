function OnDetach(self)

	self:DisableScript("Frostbite.rte/Devices/Weapons/Handheld/BattleGun/Chamber.lua");
	self.ReloadTime = 9999;
	self.Frame = 0;
	
end

function OnAttach(self)

	self:EnableScript("Frostbite.rte/Devices/Weapons/Handheld/BattleGun/Chamber.lua");
	
end