local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local workspace = game:GetService("Workspace")

local antigo = workspace:FindFirstChild("FlorestaMisteriosa")
if antigo then
	antigo:Destroy()
end

local mapa = Instance.new("Folder")
mapa.Name = "FlorestaMisteriosa"
mapa.Parent = workspace

local totalCristais = 5
local cristaisColetados = 0
local portaoAberto = false
local noiteAtual = 1

local function criarParte(nome, tamanho, posicao, cor, material)
	local parte = Instance.new("Part")
	parte.Name = nome
	parte.Size = tamanho
	parte.Position = posicao
	parte.Anchored = true
	parte.Color = cor
	parte.Material = material
	parte.Parent = mapa
	return parte
end

-- Chao
criarParte(
	"ChaoDaFloresta",
	Vector3.new(220, 2, 220),
	Vector3.new(0, 0, 0),
	Color3.fromRGB(58, 110, 55),
	Enum.Material.Grass
)

-- Arvores
local function criarArvore(x, z)
	criarParte(
		"Tronco",
		Vector3.new(3, 14, 3),
		Vector3.new(x, 8, z),
		Color3.fromRGB(92, 64, 51),
		Enum.Material.Wood
	)

	local copa = criarParte(
		"Copa",
		Vector3.new(12, 12, 12),
		Vector3.new(x, 17, z),
		Color3.fromRGB(35, 95, 48),
		Enum.Material.Grass
	)
	copa.Shape = Enum.PartType.Ball
end

math.randomseed(1234)

for i = 1, 45 do
	local x = math.random(-100, 100)
	local z = math.random(-100, 100)

	if math.abs(x) > 18 or math.abs(z) > 18 then
		criarArvore(x, z)
	end
end

-- Portao magico
local portao = criarParte(
	"PortaoMagico",
	Vector3.new(18, 16, 3),
	Vector3.new(0, 8, -100),
	Color3.fromRGB(140, 70, 255),
	Enum.Material.Neon
)

-- Area invisivel que inicia a segunda noite ao atravessar o portao
local passagemParaNoite2 = criarParte(
	"PassagemParaNoite2",
	Vector3.new(16, 14, 4),
	Vector3.new(0, 8, -104),
	Color3.fromRGB(255, 255, 255),
	Enum.Material.SmoothPlastic
)
passagemParaNoite2.Transparency = 1
passagemParaNoite2.CanCollide = false

-- Escadaria de pedra ate o portao
for degrau = 1, 10 do
	criarParte(
		"Degrau" .. degrau,
		Vector3.new(14, 2, 4),
		Vector3.new(0, 1 + degrau * 1.3, -65 - degrau * 3),
		Color3.fromRGB(105, 110, 115),
		Enum.Material.Slate
	)
end

-- Caminho elevado atras do portao
criarParte(
	"PlataformaDoTesouro",
	Vector3.new(14, 2, 22),
	Vector3.new(0, 14, -106),
	Color3.fromRGB(105, 110, 115),
	Enum.Material.Slate
)

-- Contador na tela
local function atualizarTelas(mensagem)
	for _, jogador in ipairs(Players:GetPlayers()) do
		local tela = jogador:FindFirstChild("PlayerGui")
		local interface = tela and tela:FindFirstChild("InterfaceAventura")
		local texto = interface and interface:FindFirstChild("Texto")

		if texto then
			texto.Text = mensagem or
				("Cristais encontrados: " .. cristaisColetados .. "/" .. totalCristais)
		end
	end
end

local function criarInterface(jogador)
	local playerGui = jogador:WaitForChild("PlayerGui")
	local interfaceAntiga = playerGui:FindFirstChild("InterfaceAventura")

	if interfaceAntiga then
		interfaceAntiga:Destroy()
	end

	local interface = Instance.new("ScreenGui")
	interface.Name = "InterfaceAventura"
	interface.ResetOnSpawn = false
	interface.Parent = playerGui

	local texto = Instance.new("TextLabel")
	texto.Name = "Texto"
	texto.Size = UDim2.new(0, 360, 0, 55)
	texto.Position = UDim2.new(0.5, -180, 0, 20)
	texto.BackgroundColor3 = Color3.fromRGB(20, 50, 35)
	texto.BackgroundTransparency = 0.15
	texto.TextColor3 = Color3.fromRGB(170, 255, 255)
	texto.TextScaled = true
	texto.Font = Enum.Font.GothamBold
	texto.Text = "Cristais encontrados: " .. cristaisColetados .. "/" .. totalCristais
	texto.Parent = interface
end

Players.PlayerAdded:Connect(criarInterface)

for _, jogador in ipairs(Players:GetPlayers()) do
	criarInterface(jogador)
end

-- Cristais coletaveis
local locais = {
	Vector3.new(30, 5, 20),
	Vector3.new(-45, 5, 35),
	Vector3.new(60, 5, -50),
	Vector3.new(-65, 5, -45),
	Vector3.new(5, 5, -75)
}

local function abrirPortao()
	portaoAberto = true
	portao.CanCollide = false

	TweenService:Create(
		portao,
		TweenInfo.new(2),
		{Position = portao.Position + Vector3.new(0, 20, 0)}
	):Play()

	atualizarTelas("Parabens! O portao magico foi aberto!")
end

local function iniciarNoite2()
	if noiteAtual >= 2 then
		return
	end

	noiteAtual = 2
	Lighting.ClockTime = 0
	Lighting.Brightness = 1
	Lighting.Ambient = Color3.fromRGB(35, 45, 75)
	Lighting.OutdoorAmbient = Color3.fromRGB(20, 30, 55)
	atualizarTelas("Noite 2: algo mudou na floresta...")
end

passagemParaNoite2.Touched:Connect(function(parte)
	if not portaoAberto then
		return
	end

	local personagem = parte.Parent
	local jogador = Players:GetPlayerFromCharacter(personagem)

	if jogador then
		iniciarNoite2()
	end
end)

for numero, posicao in ipairs(locais) do
	local cristal = criarParte(
		"Cristal" .. numero,
		Vector3.new(3, 8, 3),
		posicao,
		Color3.fromRGB(80, 255, 255),
		Enum.Material.Neon
	)

	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = "Coletar"
	prompt.ObjectText = "Cristal magico"
	prompt.HoldDuration = 0
	prompt.MaxActivationDistance = 25
	prompt.RequiresLineOfSight = false
	prompt.KeyboardKeyCode = Enum.KeyCode.E
	prompt.Parent = cristal

	prompt.Triggered:Connect(function()
		if not prompt.Enabled then
			return
		end

		prompt.Enabled = false
		cristaisColetados += 1
		cristal:Destroy()

		atualizarTelas()

		if cristaisColetados == totalCristais then
			abrirPortao()
		end
	end)
end

-- Zumbis simples
local function criarZumbi(posicaoInicial)
	local zumbi = Instance.new("Model")
	zumbi.Name = "ZumbiDaFloresta"
	zumbi.Parent = mapa

	local raiz = Instance.new("Part")
	raiz.Name = "HumanoidRootPart"
	raiz.Size = Vector3.new(2, 4, 2)
	raiz.Position = posicaoInicial
	raiz.Transparency = 1
	raiz.CanCollide = true
	raiz.Parent = zumbi

	local function criarPedaco(nome, tamanho, posicao, cor)
		local pedaco = Instance.new("Part")
		pedaco.Name = nome
		pedaco.Size = tamanho
		pedaco.Position = posicao
		pedaco.Color = cor
		pedaco.CanCollide = false
		pedaco.Massless = true
		pedaco.Parent = zumbi

		local solda = Instance.new("WeldConstraint")
		solda.Part0 = raiz
		solda.Part1 = pedaco
		solda.Parent = pedaco

		return pedaco
	end

	criarPedaco(
		"Torso",
		Vector3.new(3, 4, 2),
		posicaoInicial,
		Color3.fromRGB(55, 120, 65)
	)

	criarPedaco(
		"Head",
		Vector3.new(2.5, 2.5, 2.5),
		posicaoInicial + Vector3.new(0, 3.25, 0),
		Color3.fromRGB(95, 160, 85)
	)

	local humanoide = Instance.new("Humanoid")
	humanoide.WalkSpeed = 7
	humanoide.MaxHealth = 40
	humanoide.Health = 40
	humanoide.Parent = zumbi

	zumbi.PrimaryPart = raiz

	local jogadoresEmEspera = {}

	raiz.Touched:Connect(function(parte)
		local personagem = parte.Parent
		local jogador = Players:GetPlayerFromCharacter(personagem)
		local vida = personagem and personagem:FindFirstChildOfClass("Humanoid")

		if jogador and vida and not jogadoresEmEspera[jogador] then
			jogadoresEmEspera[jogador] = true
			vida:TakeDamage(10)

			task.delay(1.5, function()
				jogadoresEmEspera[jogador] = nil
			end)
		end
	end)

	task.spawn(function()
		while zumbi.Parent and humanoide.Health > 0 do
			local alvoMaisPerto
			local menorDistancia = 80

			for _, jogador in ipairs(Players:GetPlayers()) do
				local personagem = jogador.Character
				local alvo = personagem and personagem:FindFirstChild("HumanoidRootPart")
				local vida = personagem and personagem:FindFirstChildOfClass("Humanoid")

				if alvo and vida and vida.Health > 0 then
					local distancia = (alvo.Position - raiz.Position).Magnitude

					if distancia < menorDistancia then
						menorDistancia = distancia
						alvoMaisPerto = alvo
					end
				end
			end

			if alvoMaisPerto then
				humanoide:MoveTo(alvoMaisPerto.Position)
			end

			task.wait(0.5)
		end
	end)
end

criarZumbi(Vector3.new(40, 4, 45))
criarZumbi(Vector3.new(-45, 4, -25))
criarZumbi(Vector3.new(55, 4, -55))
