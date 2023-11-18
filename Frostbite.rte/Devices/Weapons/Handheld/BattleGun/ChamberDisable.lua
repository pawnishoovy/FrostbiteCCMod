function OnDetach(self)

	self:DisableScript("Frostbite.rte/Devices/Weapons/Handheld/BattleGun/Chamber.lua");
	self.BaseReloadTime = 9999;
	self.Frame = self.boltLockedBack and 3 or 0;
	
end

function OnAttach(self)

	self:EnableScript("Frostbite.rte/Devices/Weapons/Handheld/BattleGun/Chamber.lua");
	
end