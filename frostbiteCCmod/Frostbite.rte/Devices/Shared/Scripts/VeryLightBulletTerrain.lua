function Create(self)

	self.terrainSounds = {
	Impact = {[12] = CreateSoundContainer("Very Light Bullet Impact Concrete Frostbite", "Frostbite.rte"),
			[164] = CreateSoundContainer("Very Light Bullet Impact Concrete Frostbite", "Frostbite.rte"),
			[177] = CreateSoundContainer("Very Light Bullet Impact Concrete Frostbite", "Frostbite.rte"),
			[9] = CreateSoundContainer("Very Light Bullet Impact Dirt Frostbite", "Frostbite.rte"),
			[10] = CreateSoundContainer("Very Light Bullet Impact Dirt Frostbite", "Frostbite.rte"),
			[11] = CreateSoundContainer("Very Light Bullet Impact Dirt Frostbite", "Frostbite.rte"),
			[128] = CreateSoundContainer("Very Light Bullet Impact Dirt Frostbite", "Frostbite.rte"),
			[6] = CreateSoundContainer("Very Light Bullet Impact Sand Frostbite", "Frostbite.rte"),
			[8] = CreateSoundContainer("Very Light Bullet Impact Sand Frostbite", "Frostbite.rte"),
			[178] = CreateSoundContainer("Very Light Bullet Impact SolidMetal Frostbite", "Frostbite.rte"),
			[179] = CreateSoundContainer("Very Light Bullet Impact SolidMetal Frostbite", "Frostbite.rte"),
			[180] = CreateSoundContainer("Very Light Bullet Impact SolidMetal Frostbite", "Frostbite.rte"),
			[181] = CreateSoundContainer("Very Light Bullet Impact SolidMetal Frostbite", "Frostbite.rte"),
			[182] = CreateSoundContainer("Very Light Bullet Impact SolidMetal Frostbite", "Frostbite.rte")}}
			
	self.terrainGFX = {
	Impact = {[12] = CreateMOSRotating("GFX Very Light Bullet Impact Concrete Frostbite", "Frostbite.rte"),
			[164] = CreateMOSRotating("GFX Very Light Bullet Impact Concrete Frostbite", "Frostbite.rte"),
			[177] = CreateMOSRotating("GFX Very Light Bullet Impact Concrete Frostbite", "Frostbite.rte"),
			[9] = CreateMOSRotating("GFX Very Light Bullet Impact Dirt Frostbite", "Frostbite.rte"),
			[10] = CreateMOSRotating("GFX Very Light Bullet Impact Dirt Frostbite", "Frostbite.rte"),
			[11] = CreateMOSRotating("GFX Very Light Bullet Impact Dirt Frostbite", "Frostbite.rte"),
			[128] = CreateMOSRotating("GFX Very Light Bullet Impact Dirt Frostbite", "Frostbite.rte"),
			[6] = CreateMOSRotating("GFX Very Light Bullet Impact Sand Frostbite", "Frostbite.rte"),
			[8] = CreateMOSRotating("GFX Very Light Bullet Impact Sand Frostbite", "Frostbite.rte"),
			[178] = CreateMOSRotating("GFX Very Light Bullet Impact SolidMetal Frostbite", "Frostbite.rte"),
			[179] = CreateMOSRotating("GFX Very Light Bullet Impact SolidMetal Frostbite", "Frostbite.rte"),
			[180] = CreateMOSRotating("GFX Very Light Bullet Impact SolidMetal Frostbite", "Frostbite.rte"),
			[181] = CreateMOSRotating("GFX Very Light Bullet Impact SolidMetal Frostbite", "Frostbite.rte"),
			[182] = CreateMOSRotating("GFX Very Light Bullet Impact SolidMetal Frostbite", "Frostbite.rte")}}
			
	self.terrainExtraGFX = {
	Impact = {[12] = CreateMOSRotating("GFX Very Light Bullet Impact Concrete Extra Frostbite", "Frostbite.rte"),
			[164] = CreateMOSRotating("GFX Very Light Bullet Impact Concrete Extra Frostbite", "Frostbite.rte"),
			[177] = CreateMOSRotating("GFX Very Light Bullet Impact Concrete Extra Frostbite", "Frostbite.rte"),
			[9] = CreateMOSRotating("GFX Very Light Bullet Impact Dirt Extra Frostbite", "Frostbite.rte"),
			[10] = CreateMOSRotating("GFX Very Light Bullet Impact Dirt Extra Frostbite", "Frostbite.rte"),
			[11] = CreateMOSRotating("GFX Very Light Bullet Impact Dirt Extra Frostbite", "Frostbite.rte"),
			[128] = CreateMOSRotating("GFX Very Light Bullet Impact Dirt Extra Frostbite", "Frostbite.rte"),
			[6] = CreateMOSRotating("GFX Very Light Bullet Impact Sand Extra Frostbite", "Frostbite.rte"),
			[8] = CreateMOSRotating("GFX Very Light Bullet Impact Sand Extra Frostbite", "Frostbite.rte"),
			[178] = CreateMOSRotating("GFX Very Light Bullet Impact SolidMetal Extra Frostbite", "Frostbite.rte"),
			[179] = CreateMOSRotating("GFX Very Light Bullet Impact SolidMetal Extra Frostbite", "Frostbite.rte"),
			[180] = CreateMOSRotating("GFX Very Light Bullet Impact SolidMetal Extra Frostbite", "Frostbite.rte"),
			[181] = CreateMOSRotating("GFX Very Light Bullet Impact SolidMetal Extra Frostbite", "Frostbite.rte"),
			[182] = CreateMOSRotating("GFX Very Light Bullet Impact SolidMetal Extra Frostbite", "Frostbite.rte")}}
	
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
