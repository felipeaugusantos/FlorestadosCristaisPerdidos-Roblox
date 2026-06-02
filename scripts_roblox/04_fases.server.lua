local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local workspace = game:GetService("Workspace")

local mapa = workspace:WaitForChild("FlorestaMisteriosa")
local portao = mapa:WaitForChild("PortaoMagico")
local passagemParaNoite2 = mapa:WaitForChild("PassagemParaNoite2")

local function atualizarTelas(mensagem)
	for _, jogador in ipairs(Players:GetPlayers()) do
		local tela = jogador:FindFirstChild("PlayerGui")
		local interface = tela and tela:FindFirstChild("InterfaceAventura")
		local texto = interface and interface:FindFirstChild("Texto")

		if texto then
			texto.Text = mensagem or (
				"Cristais encontrados: "
				.. (mapa:GetAttribute("CristaisColetados") or 0)
				.. "/"
				.. (mapa:GetAttribute("TotalCristais") or 5)
			)
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
	texto.Parent = interface

	atualizarTelas()
end

local function abrirPortao()
	if mapa:GetAttribute("PortaoAberto") then
		return
	end

	mapa:SetAttribute("PortaoAberto", true)
	portao.CanCollide = false

	TweenService:Create(
		portao,
		TweenInfo.new(2),
		{Position = portao.Position + Vector3.new(0, 20, 0)}
	):Play()

	atualizarTelas("Parabens! O portao magico foi aberto!")
end

local function verificarCristais()
	local coletados = mapa:GetAttribute("CristaisColetados") or 0
	local total = mapa:GetAttribute("TotalCristais") or 5

	atualizarTelas()

	if coletados >= total then
		abrirPortao()
	end
end

local function iniciarNoite2()
	if (mapa:GetAttribute("NoiteAtual") or 1) >= 2 then
		return
	end

	mapa:SetAttribute("NoiteAtual", 2)
	Lighting.ClockTime = 0
	Lighting.Brightness = 1
	Lighting.Ambient = Color3.fromRGB(35, 45, 75)
	Lighting.OutdoorAmbient = Color3.fromRGB(20, 30, 55)
	atualizarTelas("Noite 2: algo mudou na floresta...")
end

Players.PlayerAdded:Connect(criarInterface)

for _, jogador in ipairs(Players:GetPlayers()) do
	criarInterface(jogador)
end

mapa:GetAttributeChangedSignal("CristaisColetados"):Connect(verificarCristais)

passagemParaNoite2.Touched:Connect(function(parte)
	if not mapa:GetAttribute("PortaoAberto") then
		return
	end

	local jogador = Players:GetPlayerFromCharacter(parte.Parent)

	if jogador then
		iniciarNoite2()
	end
end)

verificarCristais()
