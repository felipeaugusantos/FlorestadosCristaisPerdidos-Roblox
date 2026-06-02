local workspace = game:GetService("Workspace")

local antigo = workspace:FindFirstChild("FlorestaMisteriosa")
if antigo then
	antigo:Destroy()
end

local mapa = Instance.new("Folder")
mapa.Name = "FlorestaMisteriosa"
mapa:SetAttribute("TotalCristais", 5)
mapa:SetAttribute("CristaisColetados", 0)
mapa:SetAttribute("PortaoAberto", false)
mapa:SetAttribute("NoiteAtual", 1)
mapa.Parent = workspace

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

-- Portao e caminho ate a segunda noite
criarParte(
	"PortaoMagico",
	Vector3.new(18, 16, 3),
	Vector3.new(0, 8, -100),
	Color3.fromRGB(140, 70, 255),
	Enum.Material.Neon
)

local passagemParaNoite2 = criarParte(
	"PassagemParaNoite2",
	Vector3.new(16, 14, 4),
	Vector3.new(0, 8, -104),
	Color3.fromRGB(255, 255, 255),
	Enum.Material.SmoothPlastic
)
passagemParaNoite2.Transparency = 1
passagemParaNoite2.CanCollide = false

for degrau = 1, 10 do
	criarParte(
		"Degrau" .. degrau,
		Vector3.new(14, 2, 4),
		Vector3.new(0, 1 + degrau * 1.3, -65 - degrau * 3),
		Color3.fromRGB(105, 110, 115),
		Enum.Material.Slate
	)
end

criarParte(
	"PlataformaDoTesouro",
	Vector3.new(14, 2, 22),
	Vector3.new(0, 14, -106),
	Color3.fromRGB(105, 110, 115),
	Enum.Material.Slate
)
