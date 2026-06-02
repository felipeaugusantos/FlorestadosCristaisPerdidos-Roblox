local Players = game:GetService("Players")
local workspace = game:GetService("Workspace")

local mapa = workspace:WaitForChild("FlorestaMisteriosa")

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
