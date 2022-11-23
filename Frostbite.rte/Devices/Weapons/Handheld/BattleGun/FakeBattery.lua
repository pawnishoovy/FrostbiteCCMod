
function OnDetach(self, exParent)
	exParent:SetNumberValue("LostFakeBattery", 1)
	self.ToDelete = true
end
