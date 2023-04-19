function Create(self)	
	
	self.impactSound = CreateSoundContainer("Casing Shotgun Shell Impact Frostbite", "Frostbite.rte");
	

end

function OnCollideWithTerrain(self, terrainID)
	
	if self.soundPlayed ~= true then
	
		self.soundPlayed = true;
	
		self.impactSound:Play(self.Pos);

	end

end