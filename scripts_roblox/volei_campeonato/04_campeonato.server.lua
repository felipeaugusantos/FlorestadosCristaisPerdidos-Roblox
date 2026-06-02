local Players = game:GetService("Players")
local workspace = game:GetService("Workspace")

local jogo = workspace:WaitForChild("VoleiCampeonato")

local function criarParte(nome, tamanho, posicao, cor, material, parent, transparencia)
	local parte = Instance.new("Part")
	parte.Name = nome
	parte.Size = tamanho
	parte.Position = posicao
	parte.Anchored = true
	parte.Color = cor
	parte.Material = material
	parte.Transparency = transparencia or 0
	parte.Parent = parent
	return parte
end

local function criarCilindro(nome, raio, altura, posicao, cor, material, parent)
	local parte = Instance.new("Part")
	parte.Name = nome
	parte.Size = Vector3.new(raio * 2, altura, raio * 2)
	parte.Position = posicao
	parte.Anchored = true
	parte.Color = cor
	parte.Material = material
	parte.Parent = parent

	local mesh = Instance.new("CylinderMesh")
	mesh.Parent = parte
	return parte
end

local function criarPlacarPessoal(jogador)
	local leaderstats = jogador:FindFirstChild("leaderstats") or Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = jogador

	local trofeus = leaderstats:FindFirstChild("Trofeus") or Instance.new("IntValue")
	trofeus.Name = "Trofeus"
	trofeus.Parent = leaderstats
end

-- Cria particulas de celebracao acima do trofeu
local function criarConfete(posBase)
	local emissor = Instance.new("Part")
	emissor.Name = "EmissorConfete"
	emissor.Size = Vector3.new(1, 1, 1)
	emissor.Position = posBase + Vector3.new(0, 10, 0)
	emissor.Anchored = true
	emissor.Transparency = 1
	emissor.CanCollide = false
	emissor.Parent = jogo

	local anexo = Instance.new("Attachment")
	anexo.Parent = emissor

	local particulas = Instance.new("ParticleEmitter")
	particulas.Attachment = anexo
	particulas.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 60)),
		ColorSequenceKeypoint.new(0.33, Color3.fromRGB(80, 200, 120)),
		ColorSequenceKeypoint.new(0.66, Color3.fromRGB(80, 160, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 100, 100)),
	})
	particulas.LightEmission = 0.6
	particulas.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.4),
		NumberSequenceKeypoint.new(0.5, 0.9),
		NumberSequenceKeypoint.new(1, 0),
	})
	particulas.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(0.8, 0.2),
		NumberSequenceKeypoint.new(1, 1),
	})
	particulas.Speed = NumberRange.new(8, 18)
	particulas.SpreadAngle = Vector2.new(60, 60)
	particulas.Lifetime = NumberRange.new(2, 4)
	particulas.Rate = 80
	particulas.RotSpeed = NumberRange.new(-180, 180)
	particulas.Rotation = NumberRange.new(0, 360)
	particulas.Parent = emissor

	return emissor
end

-- Trofeu detalhado: podio + base + haste + taca + alças
local function criarTrofeu(time)
	local antigo = jogo:FindFirstChild("TrofeuDoCampeao")
	if antigo then
		antigo:Destroy()
	end

	local corTime = time == "Azul" and Color3.fromRGB(60, 130, 220) or Color3.fromRGB(220, 60, 60)
	local trofeu = Instance.new("Model")
	trofeu.Name = "TrofeuDoCampeao"
	trofeu.Parent = jogo

	local centroX, centroZ = 0, 50

	-- Podio (3 degraus)
	criarParte("PodioBase", Vector3.new(20, 2, 20), Vector3.new(centroX, 1, centroZ),
		Color3.fromRGB(200, 170, 100), Enum.Material.SmoothPlastic, trofeu)
	criarParte("PodioDegrau2", Vector3.new(14, 4, 14), Vector3.new(centroX, 3, centroZ),
		Color3.fromRGB(215, 185, 110), Enum.Material.SmoothPlastic, trofeu)
	criarParte("PodioDegrau3", Vector3.new(9, 5, 9), Vector3.new(centroX, 5.5, centroZ),
		Color3.fromRGB(230, 200, 120), Enum.Material.SmoothPlastic, trofeu)

	-- Placa do campeao no podio
	local placa = criarParte("PlacaCampeao", Vector3.new(12, 3, 0.5), Vector3.new(centroX, 3, centroZ - 10.3),
		Color3.fromRGB(60, 45, 20), Enum.Material.SmoothPlastic, trofeu)

	-- Base do trofeu
	criarParte("BaseTrofeu", Vector3.new(7, 1.5, 7), Vector3.new(centroX, 9, centroZ),
		Color3.fromRGB(180, 130, 50), Enum.Material.Metal, trofeu)

	-- Haste central
	criarCilindro("HasteTrofeu", 0.8, 5, Vector3.new(centroX, 12, centroZ),
		Color3.fromRGB(220, 175, 60), Enum.Material.Metal, trofeu)

	-- Corpo da taca (cilindro largo)
	criarCilindro("CorpoTaca", 3.2, 6, Vector3.new(centroX, 16, centroZ),
		Color3.fromRGB(255, 215, 55), Enum.Material.Metal, trofeu)

	-- Borda superior (anel mais largo)
	criarCilindro("BordaTaca", 4, 1, Vector3.new(centroX, 19.5, centroZ),
		Color3.fromRGB(255, 225, 70), Enum.Material.Metal, trofeu)

	-- Alca esquerda
	criarParte("AlcaEsquerda", Vector3.new(1, 4, 1), Vector3.new(centroX - 4.5, 17, centroZ),
		Color3.fromRGB(255, 210, 50), Enum.Material.Metal, trofeu)
	criarParte("AlcaEsquerdaTopo", Vector3.new(2.5, 1, 1), Vector3.new(centroX - 3.5, 19, centroZ),
		Color3.fromRGB(255, 210, 50), Enum.Material.Metal, trofeu)
	criarParte("AlcaEsquerdaBase", Vector3.new(2.5, 1, 1), Vector3.new(centroX - 3.5, 15, centroZ),
		Color3.fromRGB(255, 210, 50), Enum.Material.Metal, trofeu)

	-- Alca direita
	criarParte("AlcaDireita", Vector3.new(1, 4, 1), Vector3.new(centroX + 4.5, 17, centroZ),
		Color3.fromRGB(255, 210, 50), Enum.Material.Metal, trofeu)
	criarParte("AlcaDireitaTopo", Vector3.new(2.5, 1, 1), Vector3.new(centroX + 3.5, 19, centroZ),
		Color3.fromRGB(255, 210, 50), Enum.Material.Metal, trofeu)
	criarParte("AlcaDireitaBase", Vector3.new(2.5, 1, 1), Vector3.new(centroX + 3.5, 15, centroZ),
		Color3.fromRGB(255, 210, 50), Enum.Material.Metal, trofeu)

	-- Estrela no topo (neon da cor do time campeao)
	criarParte("EstrelaTopo", Vector3.new(3, 3, 3), Vector3.new(centroX, 22, centroZ),
		corTime, Enum.Material.Neon, trofeu)

	-- Faixa colorida do time ao redor da base
	criarCilindro("FaixaTime", 3.6, 1.2, Vector3.new(centroX, 9.8, centroZ),
		corTime, Enum.Material.Neon, trofeu)

	-- Confetes
	criarConfete(Vector3.new(centroX, 10, centroZ))

	-- Credita trofeu aos jogadores do time campeao
	for _, jogador in ipairs(Players:GetPlayers()) do
		if jogador.Team and jogador.Team.Name == time then
			local leaderstats = jogador:FindFirstChild("leaderstats")
			local trofeus = leaderstats and leaderstats:FindFirstChild("Trofeus")
			if trofeus then
				trofeus.Value += 1
			end
		end
	end
end

Players.PlayerAdded:Connect(criarPlacarPessoal)

for _, jogador in ipairs(Players:GetPlayers()) do
	criarPlacarPessoal(jogador)
end

jogo:GetAttributeChangedSignal("Campeao"):Connect(function()
	local campeao = jogo:GetAttribute("Campeao")
	if campeao and campeao ~= "" then
		criarTrofeu(campeao)
	end
end)
