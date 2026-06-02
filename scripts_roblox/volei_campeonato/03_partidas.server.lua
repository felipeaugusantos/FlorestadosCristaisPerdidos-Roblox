local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local workspace = game:GetService("Workspace")

local jogo = workspace:WaitForChild("VoleiCampeonato")
local pontoMarcado = jogo:WaitForChild("PontoMarcado")
local reiniciarBola = jogo:WaitForChild("ReiniciarBola")

-- Atualiza o placar em todos os jogadores conectados
local function atualizarPlacar(mensagemCentral)
	for _, jogador in ipairs(Players:GetPlayers()) do
		local gui = jogador:FindFirstChild("PlayerGui")
		local interface = gui and gui:FindFirstChild("InterfaceVolei")
		if not interface then
			continue
		end

		local painel = interface:FindFirstChild("PainelPlacar")
		if not painel then
			continue
		end

		local txtAzul = painel:FindFirstChild("PontosAzulLabel")
		local txtVermelho = painel:FindFirstChild("PontosVermelhoLabel")
		local txtVitAzul = painel:FindFirstChild("VitoriasAzulLabel")
		local txtVitVermelho = painel:FindFirstChild("VitoriasVermelhoLabel")
		local txtCentral = painel:FindFirstChild("MensagemCentral")

		if txtAzul then
			txtAzul.Text = tostring(jogo:GetAttribute("PontosAzul"))
		end
		if txtVermelho then
			txtVermelho.Text = tostring(jogo:GetAttribute("PontosVermelho"))
		end
		if txtVitAzul then
			txtVitAzul.Text = "Vitorias: " .. jogo:GetAttribute("VitoriasAzul")
		end
		if txtVitVermelho then
			txtVitVermelho.Text = "Vitorias: " .. jogo:GetAttribute("VitoriasVermelho")
		end
		if txtCentral then
			txtCentral.Text = mensagemCentral or ""
			txtCentral.Visible = mensagemCentral ~= nil and mensagemCentral ~= ""
		end
	end
end

-- Exibe popup de ponto para todos os jogadores
local function exibirPopupPonto(time)
	local corTime = time == "Azul" and Color3.fromRGB(80, 160, 255) or Color3.fromRGB(255, 80, 80)
	local texto = "+" .. "1  " .. time .. "!"

	for _, jogador in ipairs(Players:GetPlayers()) do
		local gui = jogador:FindFirstChild("PlayerGui")
		local interface = gui and gui:FindFirstChild("InterfaceVolei")
		if not interface then
			continue
		end

		local popup = interface:FindFirstChild("PopupPonto")
		if popup then
			popup:Destroy()
		end

		local framePopup = Instance.new("Frame")
		framePopup.Name = "PopupPonto"
		framePopup.Size = UDim2.new(0, 320, 0, 70)
		framePopup.Position = UDim2.new(0.5, -160, 0.38, 0)
		framePopup.BackgroundColor3 = corTime
		framePopup.BackgroundTransparency = 0.15
		framePopup.BorderSizePixel = 0
		framePopup.Parent = interface

		local canto = Instance.new("UICorner")
		canto.CornerRadius = UDim.new(0, 14)
		canto.Parent = framePopup

		local lblPopup = Instance.new("TextLabel")
		lblPopup.Size = UDim2.new(1, 0, 1, 0)
		lblPopup.BackgroundTransparency = 1
		lblPopup.Text = texto
		lblPopup.TextColor3 = Color3.fromRGB(255, 255, 255)
		lblPopup.TextScaled = true
		lblPopup.Font = Enum.Font.GothamBold
		lblPopup.Parent = framePopup

		task.delay(2.2, function()
			if framePopup and framePopup.Parent then
				framePopup:Destroy()
			end
		end)
	end
end

-- Cria a interface HUD moderna
local function criarInterface(jogador)
	local gui = jogador:WaitForChild("PlayerGui")
	local antiga = gui:FindFirstChild("InterfaceVolei")
	if antiga then
		antiga:Destroy()
	end

	local interface = Instance.new("ScreenGui")
	interface.Name = "InterfaceVolei"
	interface.ResetOnSpawn = false
	interface.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	interface.Parent = gui

	-- Painel principal centralizado no topo
	local painel = Instance.new("Frame")
	painel.Name = "PainelPlacar"
	painel.Size = UDim2.new(0, 480, 0, 72)
	painel.Position = UDim2.new(0.5, -240, 0, 16)
	painel.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
	painel.BackgroundTransparency = 0.12
	painel.BorderSizePixel = 0
	painel.Parent = interface

	local cantoPainel = Instance.new("UICorner")
	cantoPainel.CornerRadius = UDim.new(0, 16)
	cantoPainel.Parent = painel

	-- Bloco Azul (esquerda)
	local blocoAzul = Instance.new("Frame")
	blocoAzul.Name = "BlocoAzul"
	blocoAzul.Size = UDim2.new(0.38, 0, 1, 0)
	blocoAzul.Position = UDim2.new(0, 0, 0, 0)
	blocoAzul.BackgroundColor3 = Color3.fromRGB(40, 100, 200)
	blocoAzul.BackgroundTransparency = 0.1
	blocoAzul.BorderSizePixel = 0
	blocoAzul.Parent = painel

	local cantoAzul = Instance.new("UICorner")
	cantoAzul.CornerRadius = UDim.new(0, 16)
	cantoAzul.Parent = blocoAzul

	local nomeAzul = Instance.new("TextLabel")
	nomeAzul.Name = "NomeAzul"
	nomeAzul.Size = UDim2.new(1, 0, 0.42, 0)
	nomeAzul.Position = UDim2.new(0, 0, 0.04, 0)
	nomeAzul.BackgroundTransparency = 1
	nomeAzul.Text = "AZUL"
	nomeAzul.TextColor3 = Color3.fromRGB(220, 240, 255)
	nomeAzul.TextScaled = true
	nomeAzul.Font = Enum.Font.GothamBold
	nomeAzul.Parent = blocoAzul

	local pontosAzul = Instance.new("TextLabel")
	pontosAzul.Name = "PontosAzulLabel"
	pontosAzul.Size = UDim2.new(1, 0, 0.52, 0)
	pontosAzul.Position = UDim2.new(0, 0, 0.46, 0)
	pontosAzul.BackgroundTransparency = 1
	pontosAzul.Text = "0"
	pontosAzul.TextColor3 = Color3.fromRGB(255, 255, 255)
	pontosAzul.TextScaled = true
	pontosAzul.Font = Enum.Font.GothamBold
	pontosAzul.Parent = blocoAzul

	local vitoriasAzul = Instance.new("TextLabel")
	vitoriasAzul.Name = "VitoriasAzulLabel"
	vitoriasAzul.Size = UDim2.new(1, 0, 0.28, 0)
	vitoriasAzul.Position = UDim2.new(0, 0, 0.72, 0)
	vitoriasAzul.BackgroundTransparency = 1
	vitoriasAzul.Text = "Vitorias: 0"
	vitoriasAzul.TextColor3 = Color3.fromRGB(200, 225, 255)
	vitoriasAzul.TextScaled = true
	vitoriasAzul.Font = Enum.Font.Gotham
	vitoriasAzul.Parent = blocoAzul

	-- Separador central com "X"
	local separador = Instance.new("TextLabel")
	separador.Name = "Separador"
	separador.Size = UDim2.new(0.24, 0, 1, 0)
	separador.Position = UDim2.new(0.38, 0, 0, 0)
	separador.BackgroundTransparency = 1
	separador.Text = "X"
	separador.TextColor3 = Color3.fromRGB(200, 200, 200)
	separador.TextScaled = true
	separador.Font = Enum.Font.GothamBold
	separador.Parent = painel

	local mensagemCentral = Instance.new("TextLabel")
	mensagemCentral.Name = "MensagemCentral"
	mensagemCentral.Size = UDim2.new(0.24, 0, 0.36, 0)
	mensagemCentral.Position = UDim2.new(0.38, 0, 0.62, 0)
	mensagemCentral.BackgroundTransparency = 1
	mensagemCentral.Text = ""
	mensagemCentral.TextColor3 = Color3.fromRGB(255, 230, 100)
	mensagemCentral.TextScaled = true
	mensagemCentral.Font = Enum.Font.Gotham
	mensagemCentral.Visible = false
	mensagemCentral.Parent = painel

	-- Bloco Vermelho (direita)
	local blocoVermelho = Instance.new("Frame")
	blocoVermelho.Name = "BlocoVermelho"
	blocoVermelho.Size = UDim2.new(0.38, 0, 1, 0)
	blocoVermelho.Position = UDim2.new(0.62, 0, 0, 0)
	blocoVermelho.BackgroundColor3 = Color3.fromRGB(200, 45, 45)
	blocoVermelho.BackgroundTransparency = 0.1
	blocoVermelho.BorderSizePixel = 0
	blocoVermelho.Parent = painel

	local cantoVermelho = Instance.new("UICorner")
	cantoVermelho.CornerRadius = UDim.new(0, 16)
	cantoVermelho.Parent = blocoVermelho

	local nomeVermelho = Instance.new("TextLabel")
	nomeVermelho.Name = "NomeVermelho"
	nomeVermelho.Size = UDim2.new(1, 0, 0.42, 0)
	nomeVermelho.Position = UDim2.new(0, 0, 0.04, 0)
	nomeVermelho.BackgroundTransparency = 1
	nomeVermelho.Text = "VERMELHO"
	nomeVermelho.TextColor3 = Color3.fromRGB(255, 220, 220)
	nomeVermelho.TextScaled = true
	nomeVermelho.Font = Enum.Font.GothamBold
	nomeVermelho.Parent = blocoVermelho

	local pontosVermelho = Instance.new("TextLabel")
	pontosVermelho.Name = "PontosVermelhoLabel"
	pontosVermelho.Size = UDim2.new(1, 0, 0.52, 0)
	pontosVermelho.Position = UDim2.new(0, 0, 0.46, 0)
	pontosVermelho.BackgroundTransparency = 1
	pontosVermelho.Text = "0"
	pontosVermelho.TextColor3 = Color3.fromRGB(255, 255, 255)
	pontosVermelho.TextScaled = true
	pontosVermelho.Font = Enum.Font.GothamBold
	pontosVermelho.Parent = blocoVermelho

	local vitoriasVermelho = Instance.new("TextLabel")
	vitoriasVermelho.Name = "VitoriasVermelhoLabel"
	vitoriasVermelho.Size = UDim2.new(1, 0, 0.28, 0)
	vitoriasVermelho.Position = UDim2.new(0, 0, 0.72, 0)
	vitoriasVermelho.BackgroundTransparency = 1
	vitoriasVermelho.Text = "Vitorias: 0"
	vitoriasVermelho.TextColor3 = Color3.fromRGB(255, 200, 200)
	vitoriasVermelho.TextScaled = true
	vitoriasVermelho.Font = Enum.Font.Gotham
	vitoriasVermelho.Parent = blocoVermelho

	-- Indicador do time do jogador (canto inferior esquerdo)
	local indicadorTime = Instance.new("Frame")
	indicadorTime.Name = "IndicadorTime"
	indicadorTime.Size = UDim2.new(0, 190, 0, 44)
	indicadorTime.Position = UDim2.new(0, 16, 1, -60)
	indicadorTime.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
	indicadorTime.BackgroundTransparency = 0.2
	indicadorTime.BorderSizePixel = 0
	indicadorTime.Parent = interface

	local cantoIndicador = Instance.new("UICorner")
	cantoIndicador.CornerRadius = UDim.new(0, 10)
	cantoIndicador.Parent = indicadorTime

	local lblTime = Instance.new("TextLabel")
	lblTime.Name = "LabelTime"
	lblTime.Size = UDim2.new(1, 0, 1, 0)
	lblTime.BackgroundTransparency = 1
	lblTime.Text = "Time: " .. (jogador.Team and jogador.Team.Name or "?")
	lblTime.TextColor3 = Color3.fromRGB(255, 255, 255)
	lblTime.TextScaled = true
	lblTime.Font = Enum.Font.GothamBold
	lblTime.Parent = indicadorTime

	-- Instrucao de rebater (canto inferior)
	local instrucao = Instance.new("TextLabel")
	instrucao.Name = "Instrucao"
	instrucao.Size = UDim2.new(0, 260, 0, 36)
	instrucao.Position = UDim2.new(0.5, -130, 1, -52)
	instrucao.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	instrucao.BackgroundTransparency = 0.5
	instrucao.Text = "Pressione  [E]  para rebater a bola"
	instrucao.TextColor3 = Color3.fromRGB(230, 230, 230)
	instrucao.TextScaled = true
	instrucao.Font = Enum.Font.Gotham
	instrucao.BorderSizePixel = 0
	instrucao.Parent = interface

	local cantoInstrucao = Instance.new("UICorner")
	cantoInstrucao.CornerRadius = UDim.new(0, 8)
	cantoInstrucao.Parent = instrucao

	atualizarPlacar()

	-- Atualiza label do time quando mudar
	jogador:GetPropertyChangedSignal("Team"):Connect(function()
		local lblT = indicadorTime:FindFirstChild("LabelTime")
		if lblT then
			lblT.Text = "Time: " .. (jogador.Team and jogador.Team.Name or "?")
		end
	end)
end

local function escolherTime()
	local timeAzul = Teams:WaitForChild("Azul")
	local timeVermelho = Teams:WaitForChild("Vermelho")

	if #timeAzul:GetPlayers() <= #timeVermelho:GetPlayers() then
		return timeAzul
	end
	return timeVermelho
end

local function prepararJogador(jogador)
	jogador.Team = escolherTime()
	criarInterface(jogador)
end

local function finalizarPartida(time)
	local atributoVitorias = "Vitorias" .. time
	local vitorias = jogo:GetAttribute(atributoVitorias) + 1
	jogo:SetAttribute(atributoVitorias, vitorias)
	jogo:SetAttribute("PontosAzul", 0)
	jogo:SetAttribute("PontosVermelho", 0)

	atualizarPlacar(time .. " venceu!")
	task.wait(3)

	local vitoriasParaTrofeu = jogo:GetAttribute("VitoriasParaTrofeu")

	if vitorias >= vitoriasParaTrofeu then
		jogo:SetAttribute("Campeao", time)
		jogo:SetAttribute("PartidaAtiva", false)
		atualizarPlacar("Campeao: Time " .. time .. "!")
		return
	end

	atualizarPlacar()
	reiniciarBola:Fire(time == "Azul" and "Vermelho" or "Azul")
end

pontoMarcado.Event:Connect(function(time)
	local atributoPontos = "Pontos" .. time
	local pontos = jogo:GetAttribute(atributoPontos) + 1
	jogo:SetAttribute(atributoPontos, pontos)

	exibirPopupPonto(time)
	atualizarPlacar()
	task.wait(2)

	if pontos >= jogo:GetAttribute("PontosParaVencer") then
		finalizarPartida(time)
	else
		reiniciarBola:Fire(time)
	end
end)

Players.PlayerAdded:Connect(prepararJogador)

for _, jogador in ipairs(Players:GetPlayers()) do
	prepararJogador(jogador)
end
