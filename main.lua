-- [[ AUTO-TREINO V11: VISUAL PREMIUM, TRANSLUCIDEZ & ANIMAÇÕES ]] --

local player = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local vim = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService") -- Serviço de animação adicionado

-- Limpeza de UI antiga
if CoreGui:FindFirstChild("AutoTrainGui") then
    CoreGui.AutoTrainGui:Destroy()
end

-- Interface Principal
local screenGui = Instance.new("ScreenGui", CoreGui)
screenGui.Name = "AutoTrainGui"
screenGui.ResetOnSpawn = false

-- Frame Principal (Agora com Translucidez)
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 200, 0, 190)
frame.Position = UDim2.new(0.5, -100, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
frame.BackgroundTransparency = 0.07 -- 93% de opacidade (7% transparente)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true -- Importante para a linha não vazar

local frameCorner = Instance.new("UICorner", frame)
frameCorner.CornerRadius = UDim.new(0, 12)

local frameStroke = Instance.new("UIStroke", frame)
frameStroke.Color = Color3.fromRGB(120, 0, 255)
frameStroke.Thickness = 2
frameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Título Estilizado
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "AUTO-TRAIN PRO"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- Variáveis de controle
local teclaAtiva = nil
local uiEnergia = nil
local modoAtual = "Nenhum"
local tempoAbaixoDeDez = 0

-- Configuração da Animação da Linha
local tweenInfoLinha = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Função para criar botões modernos com animação
local function criarBotao(nome, posicao, tecla)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.85, 0, 0, 38)
    btn.Position = posicao
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = nome
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 14
    btn.AutoButtonColor = false 
    btn.ClipsDescendants = true -- Para a linha cortar nas bordas arredondadas
    
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(50, 50, 50)
    stroke.Thickness = 1

    -- A Linha Branca Animada
    local linhaAnimada = Instance.new("Frame", btn)
    linhaAnimada.Name = "LinhaHover"
    linhaAnimada.BackgroundColor3 = Color3.new(1, 1, 1) -- Branca
    linhaAnimada.BorderSizePixel = 0
    linhaAnimada.Size = UDim2.new(0, 0, 0, 2) -- Começa com largura 0 e altura 2
    linhaAnimada.Position = UDim2.new(0, 0, 1, -2) -- Fica na parte inferior
    linhaAnimada.ZIndex = 2

    -- Efeitos Visuais (Hover e Click) com Animação
    btn.MouseEnter:Connect(function()
        -- Animação da linha (sempre acontece)
        local tweenEntrada = TweenService:Create(linhaAnimada, tweenInfoLinha, {Size = UDim2.new(1, 0, 0, 2)})
        tweenEntrada:Play()

        -- Mudança de cor (só se não estiver ativo)
        if teclaAtiva ~= tecla then
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            stroke.Color = Color3.fromRGB(100, 0, 255)
        end
    end)
    
    btn.MouseLeave:Connect(function()
        -- Animação da linha (sempre acontece)
        local tweenSaida = TweenService:Create(linhaAnimada, tweenInfoLinha, {Size = UDim2.new(0, 0, 0, 2)})
        tweenSaida:Play()

        -- Mudança de cor (só se não estiver ativo)
        if teclaAtiva ~= tecla then
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            stroke.Color = Color3.fromRGB(50, 50, 50)
        end
    end)

    return btn, stroke
end

-- Criando os botões
local btnR, strokeR = criarBotao("🛡️ DEFESA (R)", UDim2.new(0.075, 0, 0.25, 0), "R")
local btnQ, strokeQ = criarBotao("⚡ ENERGIA (Q)", UDim2.new(0.075, 0, 0.48, 0), "Q")
local btnE, strokeE = criarBotao("⚔️ ATAQUE (E)", UDim2.new(0.075, 0, 0.71, 0), "E")

-- Lógica de Parar
local function pararTudo()
    vim:SendKeyEvent(false, Enum.KeyCode.R, false, game)
    vim:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
    vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    vim:SendKeyEvent(false, Enum.KeyCode.C, false, game)
    modoAtual = "Nenhum"
    tempoAbaixoDeDez = 0
end

-- Atualização visual dos botões (Ativo/Inativo)
local function atualizarUI()
    -- Botão R
    btnR.BackgroundColor3 = (teclaAtiva == "R") and Color3.fromRGB(80, 0, 200) or Color3.fromRGB(30, 30, 30)
    btnR.TextColor3 = (teclaAtiva == "R") and Color3.new(1,1,1) or Color3.fromRGB(200, 200, 200)
    strokeR.Color = (teclaAtiva == "R") and Color3.fromRGB(180, 100, 255) or Color3.fromRGB(50, 50, 50)
    strokeR.Thickness = (teclaAtiva == "R") and 2 or 1
    
    -- Botão Q
    btnQ.BackgroundColor3 = (teclaAtiva == "Q") and Color3.fromRGB(80, 0, 200) or Color3.fromRGB(30, 30, 30)
    btnQ.TextColor3 = (teclaAtiva == "Q") and Color3.new(1,1,1) or Color3.fromRGB(200, 200, 200)
    strokeQ.Color = (teclaAtiva == "Q") and Color3.fromRGB(180, 100, 255) or Color3.fromRGB(50, 50, 50)
    strokeQ.Thickness = (teclaAtiva == "Q") and 2 or 1

    -- Botão E
    btnE.BackgroundColor3 = (teclaAtiva == "E") and Color3.fromRGB(80, 0, 200) or Color3.fromRGB(30, 30, 30)
    btnE.TextColor3 = (teclaAtiva == "E") and Color3.new(1,1,1) or Color3.fromRGB(200, 200, 200)
    strokeE.Color = (teclaAtiva == "E") and Color3.fromRGB(180, 100, 255) or Color3.fromRGB(50, 50, 50)
    strokeE.Thickness = (teclaAtiva == "E") and 2 or 1
end

-- Sistema de Clique (Toggle)
local function cliqueBotao(tecla)
    if teclaAtiva == tecla then
        teclaAtiva = nil -- Desativa
    else
        teclaAtiva = tecla -- Ativa
    end
    pararTudo()
    atualizarUI()
end

btnR.MouseButton1Click:Connect(function() cliqueBotao("R") end)
btnQ.MouseButton1Click:Connect(function() cliqueBotao("Q") end)
btnE.MouseButton1Click:Connect(function() cliqueBotao("E") end)

--- LÓGICA DE FUNDO (Inalterada) ---

local function acharEnergia()
    local pgui = player:FindFirstChild("PlayerGui")
    if not pgui then return end
    for _, v in pairs(pgui:GetDescendants()) do
        if v.Name == "Value" and v:IsA("TextLabel") then
            local p = v.Parent
            if p and p:FindFirstChild("Header") and p.Header.Text:upper():find("ENERGY") then
                uiEnergia = v
                return true
            end
        end
    end
    return false
end

local function obterValores()
    if not uiEnergia then return 0, 0 end
    local texto = uiEnergia.Text 
    local atual = tonumber(texto:match("^(%d+)")) or 0
    local maximo = tonumber(texto:match("/%s*(%d+)")) or 100
    return atual, maximo
end

task.spawn(function()
    while true do
        if teclaAtiva then
            if teclaAtiva == "E" then
                vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            else
                if not uiEnergia or not uiEnergia:IsDescendantOf(game) then
                    acharEnergia()
                else
                    local atual, maximo = obterValores()
                    local key = (teclaAtiva == "R") and Enum.KeyCode.R or Enum.KeyCode.Q

                    if modoAtual == "Recarga" and atual < maximo then
                        vim:SendKeyEvent(true, Enum.KeyCode.C, false, game)
                    elseif atual <= 10 then
                        tempoAbaixoDeDez = tempoAbaixoDeDez + 0.1
                        if tempoAbaixoDeDez >= 2 then
                            vim:SendKeyEvent(false, key, false, game)
                            task.wait(0.1)
                            modoAtual = "Recarga"
                            tempoAbaixoDeDez = 0
                        end
                    else
                        if modoAtual ~= "Treino" then
                            vim:SendKeyEvent(false, Enum.KeyCode.C, false, game)
                            task.wait(0.1)
                            modoAtual = "Treino"
                            tempoAbaixoDeDez = 0
                        end
                        vim:SendKeyEvent(true, key, false, game)
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)
