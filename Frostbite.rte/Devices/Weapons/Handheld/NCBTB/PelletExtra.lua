function Create(self)
	self.Vel = Vector(self.Vel.X, self.Vel.Y) * RangeRand(0.85, 1.15)
	
	self.spewBlood = true
	
	self.terrainSounds = {
	Impact = {[12] = CreateSoundContainer("Shotgun Bullet Impact Concrete Frostbite", "Frostbite.rte"),
			[164] = CreateSoundContainer("Shotgun Bullet Impact Concrete Frostbite", "Frostbite.rte"),
			[177] = CreateSoundContainer("Shotgun Bullet Impact Concrete Frostbite", "Frostbite.rte"),
			[9] = CreateSoundContainer("Shotgun Bullet Impact Dirt Frostbite", "Frostbite.rte"),
			[10] = CreateSoundContainer("Shotgun Bullet Impact Dirt Frostbite", "Frostbite.rte"),
			[11] = CreateSoundContainer("Shotgun Bullet Impact Dirt Frostbite", "Frostbite.rte"),
			[128] = CreateSoundContainer("Shotgun Bullet Impact Dirt Frostbite", "Frostbite.rte"),
			[6] = CreateSoundContainer("Shotgun Bullet Impact Sand Frostbite", "Frostbite.rte"),
			[8] = CreateSoundContainer("Shotgun Bullet Impact Sand Frostbite", "Frostbite.rte"),
			[178] = CreateSoundContainer("Shotgun Bullet Impact SolidMetal Frostbite", "Frostbite.rte"),
			[179] = CreateSoundContainer("Shotgun Bullet Impact SolidMetal Frostbite", "Frostbite.rte"),
			[180] = CreateSoundContainer("Shotgun Bullet Impact SolidMetal Frostbite", "Frostbite.rte"),
			[181] = CreateSoundContainer("Shotgun Bullet Impact SolidMetal Frostbite", "Frostbite.rte"),
			[182] = CreateSoundContainer("Shotgun Bullet Impact SolidMetal Frostbite", "Frostbite.rte")}}
			
	self.terrainGFX = {
	Impact = {[12] = CreateMOSRotating("GFX Heavy Bullet Impact Concrete Frostbite", "Frostbite.rte"),
			[164] = CreateMOSRotating("GFX Heavy Bullet Impact Concrete Frostbite", "Frostbite.rte"),
			[177] = CreateMOSRotating("GFX Heavy Bullet Impact Concrete Frostbite", "Frostbite.rte"),
			[9] = CreateMOSRotating("GFX Heavy Bullet Impact Dirt Frostbite", "Frostbite.rte"),
			[10] = CreateMOSRotating("GFX Heavy Bullet Impact Dirt Frostbite", "Frostbite.rte"),
			[11] = CreateMOSRotating("GFX Heavy Bullet Impact Dirt Frostbite", "Frostbite.rte"),
			[128] = CreateMOSRotating("GFX Heavy Bullet Impact Dirt Frostbite", "Frostbite.rte"),
			[6] = CreateMOSRotating("GFX Heavy Bullet Impact Sand Frostbite", "Frostbite.rte"),
			[8] = CreateMOSRotating("GFX Heavy Bullet Impact Sand Frostbite", "Frostbite.rte"),
			[178] = CreateMOSRotating("GFX Heavy Bullet Impact SolidMetal Frostbite", "Frostbite.rte"),
			[179] = CreateMOSRotating("GFX Heavy Bullet Impact SolidMetal Frostbite", "Frostbite.rte"),
			[180] = CreateMOSRotating("GFX Heavy Bullet Impact SolidMetal Frostbite", "Frostbite.rte"),
			[181] = CreateMOSRotating("GFX Heavy Bullet Impact SolidMetal Frostbite", "Frostbite.rte"),
			[182] = CreateMOSRotating("GFX Heavy Bullet Impact SolidMetal Frostbite", "Frostbite.rte")}}
			
	self.terrainExtraGFX = {
	Impact = {[12] = CreateMOSRotating("GFX Heavy Bullet Impact Concrete Extra Frostbite", "Frostbite.rte"),
			[164] = CreateMOSRotating("GFX Heavy Bullet Impact Concrete Extra Frostbite", "Frostbite.rte"),
			[177] = CreateMOSRotating("GFX Heavy Bullet Impact Concrete Extra Frostbite", "Frostbite.rte"),
			[9] = CreateMOSRotating("GFX Heavy Bullet Impact Dirt Extra Frostbite", "Frostbite.rte"),
			[10] = CreateMOSRotating("GFX Heavy Bullet Impact Dirt Extra Frostbite", "Frostbite.rte"),
			[11] = CreateMOSRotating("GFX Heavy Bullet Impact Dirt Extra Frostbite", "Frostbite.rte"),
			[128] = CreateMOSRotating("GFX Heavy Bullet Impact Dirt Extra Frostbite", "Frostbite.rte"),
			[6] = CreateMOSRotating("GFX Heavy Bullet Impact Sand Extra Frostbite", "Frostbite.rte"),
			[8] = CreateMOSRotating("GFX Heavy Bullet Impact Sand Extra Frostbite", "Frostbite.rte"),
			[178] = CreateMOSRotating("GFX Heavy Bullet Impact SolidMetal Extra Frostbite", "Frostbite.rte"),
			[179] = CreateMOSRotating("GFX Heavy Bullet Impact SolidMetal Extra Frostbite", "Frostbite.rte"),
			[180] = CreateMOSRotating("GFX Heavy Bullet Impact SolidMetal Extra Frostbite", "Frostbite.rte"),
			[181] = CreateMOSRotating("GFX Heavy Bullet Impact SolidMetal Extra Frostbite", "Frostbite.rte"),
			[182] = CreateMOSRotating("GFX Heavy Bullet Impact SolidMetal Extra Frostbite", "Frostbite.rte")}}
	
end

function OnCollideWithTerrain(self, terrPixel)

	if self.impactDone ~= true then
	
		self.impactDone = true;
		if terrPixel ~= 0 then -- 0 = air
			if self.terrainSounds.Impact[terrPixel] ~= nil then
				self.terrainSounds.Impact[terrPixel]:Play(self.Pos);
			end
			if self.terrainGFX.Impact[terrPixel] ~= nil then
				local GFX = self.terrainGFX.Impact[terrPixel]:Clone()
				GFX.Pos = self.Pos
				GFX.Vel = Vector(self.Vel.X, self.Vel.Y):DegRotate(math.random(-10, 10));
				MovableMan:AddParticle(GFX)
				if math.random(0, 100) < 20 then
					local extraGFX = self.terrainExtraGFX.Impact[terrPixel]:Clone()
					extraGFX.Pos = self.Pos
					extraGFX.Vel = Vector(self.Vel.X, self.Vel.Y):DegRotate(math.random(-10, 10));
					MovableMan:AddParticle(extraGFX)
				end
			else
				local GFX = self.terrainGFX.Impact[177]:Clone()
				GFX.Pos = self.Pos
				GFX.Vel = self.Vel
				MovableMan:AddParticle(GFX)
			end				
		end
		
	end

end

function OnCollideWithMO(self, MO, rootMO)
	
	if self.spewBlood then
		self.spewBlood = false
		local material = MO.Material.PresetName;
		
		-- Add extra effects based on the material
		if (not IsActor(rootMO) or ToActor(rootMO).Health < 101) and string.find(material,"Flesh") then
			local fuck = CreateMOSParticle("Blood Blast Particle", "Base.rte");
			fuck.Pos = self.Pos;
			fuck.Vel = (self.Vel.Normalized + Vector(RangeRand(-0.3, 0.3), -1)) * 0.01 * self.Vel.Magnitude;
			fuck.Lifetime = fuck.Lifetime * RangeRand(0.8, 1.2) * 0.5;
			MovableMan:AddParticle(fuck);
		end
	end
	
	if self.Age <= TimerMan.DeltaTimeSecs * 1000 then
		MO.Vel = rootMO.Vel
		if IsAHuman(rootMO) then
			ToAHuman(rootMO).Status = 1;
			rootMO.Vel = (rootMO.Vel/2) + (self.Vel/15);
		else
			rootMO.Vel = (rootMO.Vel/2) + (self.Vel/30);
		end
	end
	
end
