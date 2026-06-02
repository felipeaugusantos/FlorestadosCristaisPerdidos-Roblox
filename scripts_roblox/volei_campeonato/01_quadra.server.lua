local Teams = game:GetService("Teams")
local workspace = game:GetService("Workspace")

local antigo = workspace:FindFirstChild("VoleiCampeonato")
if antigo then
	antigo:Destroy()
end

local jogo = Instance.new("Folder")
jogo.Name = "VoleiCampeonato"
jogo:SetAttribute("PontosAzul", 0)
jogo:SetAttribute("PontosVermelho", 0)
jogo:SetAttribute("VitoriasAzul", 0)
jogo:SetAttribute("VitoriasVermelho", 0)
jogo:SetAttribute("PontosParaVencer", 5)
jogo:SetAttribute("VitoriasParaTrofeu", 3)
jogo:SetAttribute("Campeao", "")
jogo:SetAttribute("PartidaAtiva", true)
jogo.Parent = workspace

local function criarParte(nome, tamanho, posicao, cor, material, parent, transparencia)
	local parte = Instance.new("Part")
	parte.Name = nome
	parte.Size = tamanho
	parte.Position = posicao
	parte.Anchored = true
	parte.Color = cor
	parte.Material = material
	parte.Transparency = transparencia or 0
	parte.Parent = parent or jogo
	return parte
end

local function obterTime(nome, cor)
	local time = Teams:FindFirstChild(nome) or Instance.new("Team")
	time.Name = nome
	time.TeamColor = cor
	time.AutoAssignable = false
	time.Parent = Teams
	return time
end

local azul = obterTime("Azul", BrickColor.new("Bright blue"))
local vermelho = obterTime("Vermelho", BrickColor.new("Bright red"))

-- Area externa (grama)
criarParte(
	"AreaExterna",
	Vector3.new(120, 1, 140),
	Vector3.new(0, 0, 0),
	Color3.fromRGB(60, 108, 72),
	Enum.Material.Grass
)

-- Quadra lado azul
criarParte(
	"LadoAzul",
	Vector3.new(50, 1, 38),
	Vector3.new(0, 1, 20),
	Color3.fromRGB(55, 130, 210),
	Enum.Material.SmoothPlastic
)

-- Quadra lado vermelho
criarParte(
	"LadoVermelho",
	Vector3.new(50, 1, 38),
	Vector3.new(0, 1, -20),
	Color3.fromRGB(210, 70, 70),
	Enum.Material.SmoothPlastic
)

-- Linhas da quadra (brancas)
local function criarLinha(nome, tamanho, posicao)
	criarParte(nome, tamanho, posicao, Color3.fromRGB(255, 255, 255), Enum.Material.SmoothPlastic)
end

-- Linha central (sob a rede)
criarLinha("LinhaCentral", Vector3.new(52, 1.05, 0.6), Vector3.new(0, 1, 0))
-- Linha de fundo azul
criarLinha("LinhaFundoAzul", Vector3.new(52, 1.05, 0.6), Vector3.new(0, 1, 39))
-- Linha de fundo vermelho
criarLinha("LinhaFundoVermelho", Vector3.new(52, 1.05, 0.6), Vector3.new(0, 1, -39))
-- Linhas laterais
criarLinha("LinhaLateralEsq", Vector3.new(0.6, 1.05, 80), Vector3.new(-25.3, 1, 0))
criarLinha("LinhaLateralDir", Vector3.new(0.6, 1.05, 80), Vector3.new(25.3, 1, 0))
-- Linha de ataque azul (3m da rede)
criarLinha("LinhaAtaqueAzul", Vector3.new(52, 1.05, 0.6), Vector3.new(0, 1, 10))
-- Linha de ataque vermelho
criarLinha("LinhaAtaqueVermelho", Vector3.new(52, 1.05, 0.6), Vector3.new(0, 1, -10))

-- Postes
local function criarPoste(x)
	-- Corpo do poste
	criarParte("Poste", Vector3.new(1.2, 14, 1.2), Vector3.new(x, 7.5, 0), Color3.fromRGB(200, 200, 210), Enum.Material.Metal)
	-- Topo decorativo
	criarParte("TopoPoste", Vector3.new(2, 1, 2), Vector3.new(x, 15, 0), Color3.fromRGB(255, 220, 60), Enum.Material.Metal)
	-- Base do poste
	criarParte("BasePoste", Vector3.new(3, 1, 3), Vector3.new(x, 1.5, 0), Color3.fromRGB(90, 90, 100), Enum.Material.Metal)
end

criarPoste(-27)
criarPoste(27)

-- Rede (multiplas faixas para visual mais rico)
criarParte("Rede", Vector3.new(52, 0.6, 0.4), Vector3.new(0, 9.8, 0), Color3.fromRGB(240, 240, 240), Enum.Material.Fabric)
criarParte("FaixaTopo", Vector3.new(52, 0.4, 0.5), Vector3.new(0, 9.6, 0), Color3.fromRGB(30, 30, 30), Enum.Material.Fabric)

for i = 1, 8 do
	criarParte(
		"FaixaRede" .. i,
		Vector3.new(52, 0.8, 0.3),
		Vector3.new(0, 9.8 - i * 0.9, 0),
		i % 2 == 0 and Color3.fromRGB(240, 240, 240) or Color3.fromRGB(30, 30, 30),
		Enum.Material.Fabric
	)
end

-- Base da rede
criarParte("BaseRede", Vector3.new(52, 0.4, 0.5), Vector3.new(0, 2.3, 0), Color3.fromRGB(30, 30, 30), Enum.Material.Fabric)

-- Arquibancadas lado azul
local function criarArquibancada(zBase, corTime)
	for degrau = 0, 4 do
		criarParte(
			"Degrau",
			Vector3.new(70, 3, 8),
			Vector3.new(0, 2 + degrau * 3, zBase + degrau * 4),
			Color3.fromRGB(60, 65, 75),
			Enum.Material.Concrete
		)
		-- Borda colorida dos degraus
		criarParte(
			"BordaDegrau",
			Vector3.new(70, 0.3, 0.4),
			Vector3.new(0, 3.5 + degrau * 3, zBase + degrau * 4 - 3.8),
			corTime,
			Enum.Material.SmoothPlastic
		)
	end
end

criarArquibancada(55, Color3.fromRGB(55, 130, 210))
criarArquibancada(-55, Color3.fromRGB(210, 70, 70))

-- Placar 3D (estrutura)
local function criarPlacar3D(x)
	local mastro = criarParte("MastroPlacar", Vector3.new(1.5, 18, 1.5), Vector3.new(x, 9, 0), Color3.fromRGB(70, 70, 80), Enum.Material.Metal)
	local telao = criarParte("TelaPlacar", Vector3.new(18, 8, 1), Vector3.new(x, 19, 0), Color3.fromRGB(15, 15, 25), Enum.Material.SmoothPlastic)
	local bordaTelao = criarParte("BordaTelao", Vector3.new(19, 9, 0.6), Vector3.new(x, 19, -0.3), Color3.fromRGB(50, 50, 60), Enum.Material.Metal)
end

criarPlacar3D(-38)
criarPlacar3D(38)

-- Iluminacao (postes de luz)
local function criarPosteLuz(x, z)
	criarParte("PosteLuz", Vector3.new(1, 20, 1), Vector3.new(x, 10, z), Color3.fromRGB(80, 80, 90), Enum.Material.Metal)
	local lampada = criarParte("Lampada", Vector3.new(3, 1, 6), Vector3.new(x, 21, z), Color3.fromRGB(255, 255, 200), Enum.Material.Neon)
	lampada.Name = "Lampada"
end

criarPosteLuz(-35, 42)
criarPosteLuz(35, 42)
criarPosteLuz(-35, -42)
criarPosteLuz(35, -42)

-- Spawns
local function criarSpawn(nome, posicao, time)
	local spawn = Instance.new("SpawnLocation")
	spawn.Name = nome
	spawn.Size = Vector3.new(6, 1, 6)
	spawn.Position = posicao
	spawn.Anchored = true
	spawn.Neutral = false
	spawn.TeamColor = time.TeamColor
	spawn.Color = time.TeamColor.Color
	spawn.Duration = 0
	spawn.Parent = jogo
end

criarSpawn("SpawnAzul", Vector3.new(0, 2, 32), azul)
criarSpawn("SpawnVermelho", Vector3.new(0, 2, -32), vermelho)

-- Eventos
local pontoMarcado = Instance.new("BindableEvent")
pontoMarcado.Name = "PontoMarcado"
pontoMarcado.Parent = jogo

local reiniciarBola = Instance.new("BindableEvent")
reiniciarBola.Name = "ReiniciarBola"
reiniciarBola.Parent = jogo
