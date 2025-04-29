local RunService = game:GetService("RunService")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Pet Simulator 1 Script",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "by Dark",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "RayfieldGUIconfig",
      FileName = "Pet Simulator 1"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false
})

-- Ustawienia
local Settings = {
    ["Auto Egg"] = {
        ["Triple Egg Open"] = false
    },
    ["Auto Combine"] = {
        ["Enabled"] = false,
        ["Threads"] = 1,
        ["Gold"] = true,
        ["Rainbow"] = true,
        ["Dark Matter"] = true
    },
    ["Auto Deleters"] = {
        ["Enabled"] = false
    }
}

-- Dodanie nowych Tierów do ustawień
for i = 1, 4 do
    Settings["Auto Egg"]["Christmas Tier " .. i] = false
end

for i = 1, 18 do
    Settings["Auto Egg"]["Tier " .. i] = false
end

local Deleters = {
    "Dominus Pumpkin", "Dominus Cherry", "Dominus Noob", "Dominus Wavy", 
    "Dominus Damnee", "Dominus HeadStack", "Spike", "Aesthetic Cat", "Magic Fox", 
    "Chimera", "Gingerbread", "Festive Ame Damnee", "Reindeer", "Festive Dominus"
}

-- Zakładka Auto Egg
local EggTab = Window:CreateTab("🐣Auto Egg", 4483362458)

-- Zakładka Settings 
local SettingsTab = Window:CreateTab("⚙️Settings", 4483362458)

-- Zakładka Farming 
local FarmingTab = Window:CreateTab("🌱Farming", 4483362458)

-- Zakładka Themes
local ThemesTab = Window:CreateTab("🦋Themes", 4483362458)

local Button = ThemesTab:CreateButton({
   Name = "Default",
   Callback = function()
   Window.ModifyTheme('Default')
   end,
})

local Button = ThemesTab:CreateButton({
   Name = "Ocean",
   Callback = function()
   Window.ModifyTheme('Ocean')
   end,
})

local Button = ThemesTab:CreateButton({
   Name = "Dark Blue",
   Callback = function()
   Window.ModifyTheme('DarkBlue')
   end,
})

local Button = ThemesTab:CreateButton({
   Name = "Green",
   Callback = function()
   Window.ModifyTheme('Green')
   end,
})

local Button = ThemesTab:CreateButton({
   Name = "Bloom",
   Callback = function()
   Window.ModifyTheme('Bloom')
   end,
})

local Button = ThemesTab:CreateButton({
   Name = "Light",
   Callback = function()
   Window.ModifyTheme('Light')
   end,
})

local Button = ThemesTab:CreateButton({
   Name = "Serenity",
   Callback = function()
   Window.ModifyTheme('Serenity')
   end,
})

local Button = ThemesTab:CreateButton({
   Name = "Amethyst",
   Callback = function()
   Window.ModifyTheme('Amethyst')
   end,
})

local Button = ThemesTab:CreateButton({
   Name = "Amber Glow",
   Callback = function()
   Window.ModifyTheme('AmberGlow')
   end,
})

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RenderToggleGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local background = Instance.new("Frame")
background.Size = UDim2.new(1, 0, 1, 0)
background.Position = UDim2.new(0, 0, 0, 0)
background.BackgroundColor3 = Color3.new(0, 0, 0)
background.ZIndex = 10
background.Visible = false
background.Parent = screenGui

-- Funkcja ustawiająca render + nakładkę
local function setRendering(state)
    game:GetService("RunService"):Set3dRenderingEnabled(state)
    background.Visible = not state
end

-- Rayfield Toggle
SettingsTab:CreateToggle({
    Name = "No Rendering",
    CurrentValue = false,
    Callback = function(Value)
        setRendering(not Value)
    end,
})

local RemoteEventsStatus = {}

local function disableRemoteEvents()
    for _, event in pairs(game.Players.LocalPlayer.PlayerGui.Events:GetChildren()) do
        if event:IsA("RemoteEvent") then
            -- Zapisz stan eventu przed jego wyłączeniem
            RemoteEventsStatus[event.Name] = event.Enabled
            event.Enabled = false
        end
    end
end

local function restoreRemoteEvents()
    for _, event in pairs(game.Players.LocalPlayer.PlayerGui.Events:GetChildren()) do
        if event:IsA("RemoteEvent") and RemoteEventsStatus[event.Name] ~= nil then
            -- Przywróć stan eventu
            event.Enabled = RemoteEventsStatus[event.Name]
        end
    end
end

SettingsTab:CreateToggle({
    Name = "Disable Client Updater",
    CurrentValue = false,
    Flag = "ToggleRemote",
    Callback = function(Value)
        if Value then
            disableRemoteEvents()
            print("RemoteEvents wyłączone.")
        else
            restoreRemoteEvents()
            print("RemoteEvents przywrócone.")
        end
    end
})

local get = false
local Hat = 'Robux'
local Hats = {
    [40005] = {"Hat Stack",4},
    [40006] = {"Blue Top Hat",4},
    [40007] = {"Robux",5},
    [30001] = {"Traffic Cone",3},
    [30002] = {"Pirate Hat",3},
    [30003] = {"Chessboard",3},
    [30004] = {"Horns",3},
    [30005] = {"Green Banded Top Hat",3},
    [30006] = {"Yellow Banded Top Hat",3},
    [30007] = {"White Top Hat",3},
    [30008] = {"Blue Traffic Cone",3},
    [99001] = {"Rain Cloud",5},
    [99002] = {"Crown",5},
    [20001] = {"Paper Hat",2},
    [99004] = {"Lord of the Federation",5},
    [99005] = {"Domino Crown",5},
    [20004] = {"Propeller Beanie",2},
    [20005] = {"Cowboy Hat",2},
    [20006] = {"Viking",2},
    [20007] = {"Giant Cheese",2},
    [10001] = {"Lei",1},
    [10002] = {"Apple",1},
    [10003] = {"Black Winter Cap",1},
    [10004] = {"Pot",1},
    [99003] = {"Duke of the Federation",5},
    [99006] = {"Black Iron Domino Crown",5},
    [20002] = {"Cheese",2},
    [40001] = {"Neon Pink Banded Top Hat",4},
    [40002] = {"Rubber Duckie",4},
    [40003] = {"Noob Sign",4},
    [40004] = {"Bling Top Hat",4},
    [20003] = {"Princess Hat",2},
}

local function Wait(x)
    for i = 1, x do
        task.wait()
    end
end

local function AutoHatFarm()
    local present, id
    for i, v in pairs(Hats) do
        if v[1] == Hat then
            id = i
            present = v[2] == 5 and 'Golden' or 'Tier ' .. v[2]
        end
    end

    local r = workspace.__REMOTES
    local mh = r.Core["Get Stats"]:InvokeServer().Save.HatSlots

    while true do
        if not get then coroutine.yield() end  -- Zatrzymuje działanie pętli, gdy toggle jest wyłączony

        local td, wt = {}, 0
        local tb = mh - #r.Core["Get Stats"]:InvokeServer().Save.Hats

        for _ = 1, tb do
            if not get then coroutine.yield() end
            task.spawn(function()
                if not get then return end
                local _, h = r.Game.Shop:InvokeServer("Buy", "Presents", present)
                if tonumber(h[1][1].n) ~= id then
                    table.insert(td, h[1][1].id)
                else
                    warn("Got Robux hat")
                end
                wt = wt + 1
            end)
        end
        repeat Wait(2) until wt == tb or not get
        if not get then coroutine.yield() end

        r.Game.Hats:InvokeServer("MultiDelete", td)
    end
end

-- Tworzenie coroutiny
local hatFarmThread = coroutine.create(AutoHatFarm)

local function NotifyDeletersList()
-- Łączenie listy petów w jedną wiadomość
local deletersList = table.concat(Deleters, ", ")
       -- Wyświetlenie powiadomienia
    Rayfield:Notify({
        Title = "Deleted pets list",
        Content = deletersList,
        Duration = 10, -- Czas trwania powiadomienia (w sekundach)
        Image = 4483362458, -- Opcjonalnie: zmień na ID obrazka, jeśli masz
    })
end

local Section = SettingsTab:CreateSection("Other")

-- **Dodanie przełącznika do Rayfield**
local HatToggle = SettingsTab:CreateToggle({
    Name = "Auto Hat Farm",
    CurrentValue = false,
    Flag = "AutoHatFarmToggle",
    Callback = function(Value)
        get = Value
        if Value then
            coroutine.resume(hatFarmThread) -- Wznawia coroutine, jeśli toggle włączony
        end
    end
})


local Button = SettingsTab:CreateButton({
   Name = "Deleted pets list",
   Callback = function()
   NotifyDeletersList()
    -- Wywołanie funkcji, aby przetestować powiadomienie
  end,
})


local Button = SettingsTab:CreateButton({
   Name = "Destroy UI",
   Callback = function()
   Rayfield:Destroy()
   end,
})

local function deletePet(id)
    workspace.__REMOTES.Game.Inventory:InvokeServer("Delete", id)
end

local Button = SettingsTab:CreateButton({
   Name = "Delete NaN Pets",  -- Nazwa przycisku
   Callback = function()
       -- Funkcja uruchamiana po kliknięciu przycisku
       local petData = workspace.__REMOTES.Core["Get Stats"]:InvokeServer().Save.Pets
       for i, pet in ipairs(petData) do
           if pet.l == nil then -- Sprawdź, czy poziom jest nil
               deletePet(pet.id) -- Usuń zwierzę, jeśli poziom jest nil
           end
       end
       
       -- Powiadomienie o konieczności rejoin
       Rayfield:Notify({
           Title = "Rejoin Required",  -- Tytuł powiadomienia
           Content = "NaN pet should be now deleted please rejoin to check",  -- Treść powiadomienia
           Duration = 5,  -- Czas trwania powiadomienia
           Image = 4483362458,  -- Ikona powiadomienia (możesz zmienić ID na odpowiednie)
       })
   end,
})

local Directory = require(game:GetService("ReplicatedStorage")["1 | Directory"])

-- Flagi kontrolne
local AutoCombineRunning = false
local AutoDeletersRunning = false

-- Funkcja sprawdzająca, czy zwierzak znajduje się na liście do usunięcia
local function CheckDeleters(Info)
    for _, Deleter in pairs(Deleters) do
        if string.lower(tostring(Deleter)) == string.lower(Directory.Pets[Info].DisplayName) or 
           string.lower(tostring(Deleter)) == string.lower(Directory.Pets[Info].ReferenceName) then
            return true
        end
    end
    return false
end

-- Funkcja usuwająca niechciane zwierzaki
local function DeleteOtherUnwantedPets()
    if not AutoDeletersRunning then return end
    coroutine.wrap(function()
        local Stats = workspace["__REMOTES"]["Core"]["Get Stats"]:InvokeServer()
        for _, Pet in ipairs(Stats.Save.Pets) do
            if not AutoDeletersRunning then break end
            if CheckDeleters(Pet.n) then
                task.defer(function()
                    workspace["__REMOTES"]["Game"]["Inventory"]:InvokeServer("Delete", Pet.id)
                end)
            end
        end
    end)()
end

-- Funkcja zakupu jajek
local function BuyEgg(tier)
    print("Próbuję kupić jajko z tierem: " .. tier)

    local success, result = workspace["__REMOTES"]["Game"]["Shop"]:InvokeServer("Buy", "Eggs", tier, Settings["Auto Egg"]["Triple Egg Open"])
    if success then
        print("Pomyślnie zakupiono jajko.")
    else
        warn("Nie udało się kupić jajka: " .. tostring(result))
    end
    return success
end

-- Główna funkcja Auto Egg
local function AutoEggMain()
    coroutine.wrap(function()
        while true do
            local selectedTier = nil
            for i = 1, 4 do
                if Settings["Auto Egg"]["Christmas Tier " .. i] then
                    selectedTier = "Christmas Tier " .. i
                    break
                end
            end
            if not selectedTier then
                for i = 1, 18 do
                    if Settings["Auto Egg"]["Tier " .. i] then
                        selectedTier = "Tier " .. i
                        break
                    end
                end
            end

            if not selectedTier then break end

            -- Sprawdzanie miejsca w ekwipunku
            local stats = workspace["__REMOTES"]["Core"]["Get Stats"]:InvokeServer()
            local currentPets = #stats.Save.Pets
            local maxPets = stats.Save.PetSlots
            local requiredFreeSlots = Settings["Auto Egg"]["Triple Egg Open"] and 3 or 1

            if maxPets - currentPets < requiredFreeSlots then
                repeat
                    task.wait()
                    stats = workspace["__REMOTES"]["Core"]["Get Stats"]:InvokeServer()
                    currentPets = #stats.Save.Pets
                until maxPets - currentPets >= requiredFreeSlots
            end

            -- Zakup jajka
            local success = BuyEgg(selectedTier)
            if not success then break end
            Wait(4)
        end
    end)()
end

-- Funkcja automatycznego łączenia zwierzaków
local function AutoCombineCheck()
    if not AutoCombineRunning then return end
    coroutine.wrap(function()
        local Stats = workspace["__REMOTES"]["Core"]["Get Stats"]:InvokeServer()
        local GoldTable, RainbowTable, DarkMatterTable = {}, {}, {}

        for _, Pet in ipairs(Stats.Save.Pets) do
            if not AutoCombineRunning then break end
            if tostring(Pet.n) ~= "BIG Maskot" then
                if Settings["Auto Combine"]["Gold"] and not Pet.g and not Pet.r and not Pet.dm then
                    GoldTable[tostring(Pet.n)] = (GoldTable[tostring(Pet.n)] or 0) + 1
                elseif Settings["Auto Combine"]["Rainbow"] and Pet.g and not Pet.r and not Pet.dm then
                    RainbowTable[tostring(Pet.n)] = (RainbowTable[tostring(Pet.n)] or 0) + 1
                elseif Settings["Auto Combine"]["Dark Matter"] and not Pet.g and Pet.r and not Pet.dm then
                    DarkMatterTable[tostring(Pet.n)] = (DarkMatterTable[tostring(Pet.n)] or 0) + 1
                end
            end
        end

        -- Łączenie w Gold
        for PetN, Amount in pairs(GoldTable) do
            if Amount >= 10 then
                coroutine.wrap(function()
                    for _, Pet in ipairs(Stats.Save.Pets) do
                        if tostring(Pet.n) == tostring(PetN) and not Pet.g and not Pet.r and not Pet.dm then
                            workspace["__REMOTES"]["Game"]["Golden Pets"]:InvokeServer(Pet.id)
                        end
                    end
                end)()
            end
        end

        -- Łączenie w Rainbow
        for PetN, Amount in pairs(RainbowTable) do
            if Amount >= 7 then
                coroutine.wrap(function()
                    for _, Pet in ipairs(Stats.Save.Pets) do
                        if tostring(Pet.n) == tostring(PetN) and Pet.g and not Pet.r and not Pet.dm then
                            workspace["__REMOTES"]["Game"]["Rainbow Pets"]:InvokeServer(Pet.id)
                        end
                    end
                end)()
            end
        end

        -- Łączenie w Dark Matter
        for PetN, Amount in pairs(DarkMatterTable) do
            if Amount >= 5 then
                coroutine.wrap(function()
                    for _, Pet in ipairs(Stats.Save.Pets) do
                        if tostring(Pet.n) == tostring(PetN) and not Pet.g and Pet.r and not Pet.dm then
                            workspace["__REMOTES"]["Game"]["Dark Matter Pets"]:InvokeServer(Pet.id)
                        end
                    end
                end)()
            end
        end
    end)()
end

local function AddTierToggles(tab, sectionName, prefix, rangeStart, rangeEnd)
    local section = tab:CreateSection(sectionName)
    local step = rangeStart < rangeEnd and 1 or -1 -- Automatyczne określenie kroku (rosnąca lub malejąca kolejność)
    for i = rangeStart, rangeEnd, step do
        tab:CreateToggle({
            Name = "Enable " .. prefix .. " " .. i .. " Auto Egg",
            CurrentValue = Settings["Auto Egg"][prefix .. " " .. i],
            Flag = prefix:gsub(" ", "") .. i .. "Toggle",
            Callback = function(Value)
                -- Wyłączanie innych przełączników w tej kategorii
                for j = rangeStart, rangeEnd, step do
                    Settings["Auto Egg"][prefix .. " " .. j] = false
                end
                Settings["Auto Egg"][prefix .. " " .. i] = Value
                if Value then
                    task.spawn(AutoEggMain) -- Uruchamianie AutoEggMain w nowym wątku
                end
            end
        })
    end
end

-- Dodanie przełączników dla Christmas Tier 4–1 (malejąca kolejność)
AddTierToggles(EggTab, "Christmas Tier", "Christmas Tier", 4, 1)

-- Dodanie przełączników dla Tier 18–1 (malejąca kolejność)
AddTierToggles(EggTab, "Tier", "Tier", 18, 1)

local Section = SettingsTab:CreateSection("Hatching")

SettingsTab:CreateToggle({
    Name = "Triple Egg Open (gamepass required)",
    CurrentValue = Settings["Auto Egg"]["Triple Egg Open"],
    Flag = "TripleEggToggle",
    Callback = function(Value)
        Settings["Auto Egg"]["Triple Egg Open"] = Value
    end
})

SettingsTab:CreateToggle({
    Name = "Auto Combine",
    CurrentValue = Settings["Auto Combine"]["Enabled"],
    Flag = "AutoCombineToggle",
    Callback = function(Value)
        AutoCombineRunning = Value -- Aktualizacja flagi
        if Value then
            task.spawn(function()
                while AutoCombineRunning do
                    AutoCombineCheck() -- Główna funkcja Auto Combine
                    task.wait(2) -- Czas oczekiwania między iteracjami
                end
            end)
        end
    end
})

SettingsTab:CreateToggle({
    Name = "Auto Deleters",
    CurrentValue = Settings["Auto Deleters"]["Enabled"],
    Flag = "AutoDeleterToggle",
    Callback = function(Value)
        AutoDeletersRunning = Value -- Aktualizacja flagi
        if Value then
            task.spawn(function()
                while AutoDeletersRunning do
                    DeleteOtherUnwantedPets() -- Główna funkcja Auto Delete
                    task.wait(2) -- Czas oczekiwania między iteracjami
                end
            end)
        end
    end
})

-- Flagi kontrolne dla farmienia
local FarmStart = false -- Domyślnie farmienie wyłączone
local TargetNames = { -- Lista nazw monet do farmienia
    ["Christmas3 Cane"] = false,
    ["Christmas3 Small Cane"] = false,
    ["Christmas1 Sleigh"] = false
}

local PetTable = {} -- Lista aktywnych zwierzaków

-- Funkcja aktualizująca listę zwierzaków
local function UpdatePetTable()
    local Stats = workspace["__REMOTES"]["Core"]["Get Other Stats"]:InvokeServer()
    local PlayerStats = Stats[game.Players.LocalPlayer.Name]
    local Pets = PlayerStats["Save"]["Pets"]

    PetTable = {}
    for _, pet in ipairs(Pets) do
        if pet.e then -- Sprawdzanie, czy zwierzak jest aktywny
            table.insert(PetTable, {
                ID = tonumber(pet.id),
                LEVEL = tonumber(pet.l)
            })
        end
    end
end

-- Funkcja farmienia monet
local function FarmCoin(Coin)
    while FarmStart and Coin:FindFirstChild("CoinName") and TargetNames[Coin.CoinName.Value] do
        for _, pet in ipairs(PetTable) do
            workspace["__REMOTES"]["Game"]["Coins"]:FireServer("Mine", Coin.Name, pet.LEVEL, pet.ID)
        end
        task.wait()

        -- Zabezpieczenie przed usunięciem monety
        if not Coin:IsDescendantOf(workspace["__THINGS"].Coins) then
            break
        end
    end
end

-- Pętla farmienia
task.spawn(function()
    while true do
        if FarmStart then
            UpdatePetTable() -- Aktualizacja listy zwierzaków
            for _, Coin in ipairs(workspace["__THINGS"].Coins:GetChildren()) do
                if Coin:FindFirstChild("CoinName") and TargetNames[Coin.CoinName.Value] then
                    FarmCoin(Coin)
                end
            end
        end
        task.wait(1) -- Krótkie opóźnienie między cyklami
    end
end)

local FarmingSection = FarmingTab:CreateSection("Farm Settings")

-- Przełącznik włączający/wyłączający farmienie
FarmingTab:CreateToggle({
    Name = "Enable Auto Farm",
    CurrentValue = FarmStart,
    Flag = "EnableAutoFarm",
    Callback = function(Value)
        FarmStart = Value
    end
})

-- Przełączniki dla wartości HP
FarmingTab:CreateToggle({
    Name = "Farm Christmas3 Cane",
    CurrentValue = TargetNames["Christmas3 Cane"],
    Flag = "FarmChristmas3Cane",
    Callback = function(Value)
        TargetNames["Christmas3 Cane"] = Value
    end
})

FarmingTab:CreateToggle({
    Name = "Farm Christmas3 Small Cane",
    CurrentValue = TargetNames["Christmas3 Small Cane"],
    Flag = "FarmChristmas3SmallCane",
    Callback = function(Value)
        TargetNames["Christmas3 Small Cane"] = Value
    end
})

FarmingTab:CreateToggle({
    Name = "Farm Christmas1 Sleigh",
    CurrentValue = TargetNames["Christmas1 Sleigh"],
    Flag = "FarmChristmas1Sleigh",
    Callback = function(Value)
        TargetNames["Christmas1 Sleigh"] = Value
    end
})

-- Anti-AFK Script
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    local VirtualUser = game:service('VirtualUser')
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(0, 0))
    print("Anti-AFK: Zapobieganie rozłączeniu.")
	end)
	
	Rayfield:LoadConfiguration()
