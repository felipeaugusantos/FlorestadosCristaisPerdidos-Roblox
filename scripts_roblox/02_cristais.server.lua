local workspace = game:GetService("Workspace")

local mapa = workspace:WaitForChild("FlorestaMisteriosa")

local locais = {
	Vector3.new(30, 5, 20),
	Vector3.new(-45, 5, 35),
	Vector3.new(60, 5, -50),
	Vector3.new(-65, 5, -45),
	Vector3.new(5, 5, -75)
}

local function criarCristal(numero, posicao)
	local cristal = Instance.new("Part")
	cristal.Name = "Cristal" .. numero
	cristal.Size = Vector3.new(3, 8, 3)
	cristal.Position = posicao
	cristal.Anchored = true
	cristal.Color = Color3.fromRGB(80, 255, 255)
	cristal.Material = Enum.Material.Neon
	cristal.Parent = mapa

	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = "Coletar"
	prompt.ObjectText = "Cristal magico"
	prompt.HoldDuration = 0
	prompt.MaxActivationDistance = 25
	prompt.RequiresLineOfSight = false
	prompt.KeyboardKeyCode = Enum.KeyCode.E
	prompt.Parent = cristal

	local coletado = false

	prompt.Triggered:Connect(function()
		if coletado then
			return
		end

		coletado = true
		prompt.Enabled = false
		cristal.Transparency = 1
		cristal.CanCollide = false
		cristal.CanTouch = false

		local quantidade = mapa:GetAttribute("CristaisColetados") or 0
		mapa:SetAttribute("CristaisColetados", quantidade + 1)

		cristal:Destroy()
	end)
end

for numero, posicao in ipairs(locais) do
	criarCristal(numero, posicao)
end
