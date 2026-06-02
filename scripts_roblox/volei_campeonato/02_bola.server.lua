local Players = game:GetService("Players")
local workspace = game:GetService("Workspace")

local jogo = workspace:WaitForChild("VoleiCampeonato")
local pontoMarcado = jogo:WaitForChild("PontoMarcado")
local reiniciarBola = jogo:WaitForChild("ReiniciarBola")

local bola = Instance.new("Part")
bola.Name = "BolaDeVolei"
bola.Shape = Enum.PartType.Ball
bola.Size = Vector3.new(3, 3, 3)
bola.Position = Vector3.new(0, 8, 25)
bola.Color = Color3.fromRGB(250, 245, 210)
bola.Material = Enum.Material.SmoothPlastic
bola.CustomPhysicalProperties = PhysicalProperties.new(0.5, 0.3, 0.7, 0, 0)
bola.Parent = jogo

-- Listras decorativas na bola
local listra1 = Instance.new("SpecialMesh")
listra1.MeshType = Enum.MeshType.Sphere
listra1.Parent = bola

local prompt = Instance.new("ProximityPrompt")
prompt.ActionText = "Rebater"
prompt.ObjectText = "Bola de Volei"
prompt.HoldDuration = 0
prompt.MaxActivationDistance = 10
prompt.RequiresLineOfSight = false
prompt.KeyboardKeyCode = Enum.KeyCode.E
prompt.Parent = bola

local pontoEmAndamento = false
local ladoDoProximoSaque = "Azul"

-- Cooldown por jogador (evita spam de rebatida)
local cooldowns = {}
local COOLDOWN_TEMPO = 0.6

-- Rastro visual da bola
local attachment = Instance.new("Attachment")
attachment.Parent = bola

local trail = Instance.new("Trail")
trail.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 200)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
})
trail.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0),
	NumberSequenceKeypoint.new(1, 1),
})
trail.Lifetime = 0.25
trail.MinLength = 0
trail.Attachment0 = attachment
trail.Parent = bola

local attachmentB = Instance.new("Attachment")
attachmentB.Position = Vector3.new(0, -1.5, 0)
attachmentB.Parent = bola
trail.Attachment1 = attachmentB

local function reiniciar(lado)
	ladoDoProximoSaque = lado or ladoDoProximoSaque
	pontoEmAndamento = false
	cooldowns = {}
	bola.AssemblyLinearVelocity = Vector3.zero
	bola.AssemblyAngularVelocity = Vector3.zero
	bola:SetAttribute("UltimoToque", "")
	bola:SetAttribute("UltimoJogador", "")

	if ladoDoProximoSaque == "Azul" then
		bola.Position = Vector3.new(0, 8, 28)
	else
		bola.Position = Vector3.new(0, 8, -28)
	end
end

local function marcarPonto(time)
	if pontoEmAndamento or not jogo:GetAttribute("PartidaAtiva") then
		return
	end
	pontoEmAndamento = true
	pontoMarcado:Fire(time)
end

prompt.Triggered:Connect(function(jogador)
	if not jogo:GetAttribute("PartidaAtiva") then
		return
	end

	-- Cooldown individual
	local agora = tick()
	if cooldowns[jogador.UserId] and agora - cooldowns[jogador.UserId] < COOLDOWN_TEMPO then
		return
	end
	cooldowns[jogador.UserId] = agora

	local personagem = jogador.Character
	local raiz = personagem and personagem:FindFirstChild("HumanoidRootPart")
	local humanoide = personagem and personagem:FindFirstChild("Humanoid")

	if not raiz or not jogador.Team then
		return
	end

	-- Impede rebater se o humanoide estiver incapacitado
	if humanoide and humanoide.Health <= 0 then
		return
	end

	-- Evita que o mesmo jogador toque duas vezes seguidas (simula toque de passe)
	local ultimoJogador = bola:GetAttribute("UltimoJogador") or ""
	if ultimoJogador == tostring(jogador.UserId) then
		-- Permite (nao bloqueia, apenas registra — voce pode adicionar restricao aqui)
	end

	bola:SetAttribute("UltimoToque", jogador.Team.Name)
	bola:SetAttribute("UltimoJogador", tostring(jogador.UserId))

	local direcao = raiz.CFrame.LookVector
	local distanciaBola = (bola.Position - raiz.Position)
	local alturaRelativa = distanciaBola.Y

	-- Impulso vertical maior se a bola estiver baixa (simula levantamento)
	local impulsoVertical = alturaRelativa < 0 and 55 or 48

	local impulso = Vector3.new(
		direcao.X * 40,
		impulsoVertical,
		direcao.Z * 40
	)

	bola.AssemblyLinearVelocity = impulso
end)

bola.Touched:Connect(function(parte)
	if pontoEmAndamento then
		return
	end

	if parte.Name == "LadoAzul" then
		marcarPonto("Vermelho")
	elseif parte.Name == "LadoVermelho" then
		marcarPonto("Azul")
	elseif parte.Name == "AreaExterna" then
		local ultimoToque = bola:GetAttribute("UltimoToque") or ""
		if ultimoToque == "Azul" then
			marcarPonto("Vermelho")
		elseif ultimoToque == "Vermelho" then
			marcarPonto("Azul")
		end
	end
end)

reiniciarBola.Event:Connect(reiniciar)
reiniciar("Azul")
