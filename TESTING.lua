local RunService = game:GetService("RunService")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "PET SIMULATOR SCRIPT!",
   LoadingTitle = "Auto Hatch",
   LoadingSubtitle = "by Dark",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "RayfieldGUIconfig",
      FileName = "TESTING"
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
    "Chimera", "Gingerbread", "Festive Ame Damnee", "Reindeer", "Festive Dominus", 
}

-- Zakładka Auto Egg
local EggTab = Window:CreateTab("Auto Egg", 4483362458)

-- Zakładka Auto Combine
local SettingsTab = Window:CreateTab("Settings", 4483362458)

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

local InfoTab = Window:CreateTab("Info", 4483362458)

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
 
local Button = InfoTab:CreateButton({
   Name = "Deleted pets list",
   Callback = function()
   NotifyDeletersList()
    -- Wywołanie funkcji, aby przetestować powiadomienie
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
if not AutoDeletersRunning then return end -- Jeśli flaga wyłączona, przerwij działanie funkcji
    local Stats = workspace["__REMOTES"]["Core"]["Get Stats"]:InvokeServer()
    for _, Pet in ipairs(Stats.Save.Pets) do
    if not AutoDeletersRunning then break end -- Sprawdzenie flagi w każdej iteracji
        if CheckDeleters(Pet.n) then
            -- Usuwanie zwierzaka w tle z task.defer
            task.defer(function()
                workspace["__REMOTES"]["Game"]["Inventory"]:InvokeServer("Delete", Pet.id)
            end)
        end
    end
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
            warn("Ekwipunek pełny, czekam na zwolnienie miejsca...")
            repeat
        task.wait()
                stats = workspace["__REMOTES"]["Core"]["Get Stats"]:InvokeServer()
                currentPets = #stats.Save.Pets
            until maxPets - currentPets >= requiredFreeSlots
            warn("Miejsce w ekwipunku dostępne, wznawiam Auto Hatch.")
        end

        -- Zakup jajka
        local success = BuyEgg(selectedTier)
        if not success then
            warn("Kupowanie jajek zostało przerwane.")
            break
        end
        task.wait()
    end
end

-- Funkcja automatycznego łączenia zwierzaków
local function AutoCombineCheck()
if not AutoCombineRunning then return end -- Jeśli flaga wyłączona, przerwij działanie funkcji
    local Stats = workspace["__REMOTES"]["Core"]["Get Stats"]:InvokeServer()
    local GoldTable, RainbowTable, DarkMatterTable = {}, {}, {}

    -- Tworzenie tabel z odpowiednimi zwierzakami
    for _, Pet in ipairs(Stats.Save.Pets) do
    if not AutoCombineRunning then break end -- Sprawdzenie flagi w każdej iteracji
        if Settings["Auto Combine"]["Gold"] and not Pet.g and not Pet.r and not Pet.dm then
            GoldTable[tostring(Pet.n)] = (GoldTable[tostring(Pet.n)] or 0) + 1
        elseif Settings["Auto Combine"]["Rainbow"] and Pet.g and not Pet.r and not Pet.dm then
            RainbowTable[tostring(Pet.n)] = (RainbowTable[tostring(Pet.n)] or 0) + 1
        elseif Settings["Auto Combine"]["Dark Matter"] and not Pet.g and Pet.r and not Pet.dm then
            DarkMatterTable[tostring(Pet.n)] = (DarkMatterTable[tostring(Pet.n)] or 0) + 1
        end
    end

    -- Łączenie w Gold
    for PetN, Amount in pairs(GoldTable) do
        if Amount >= 10 then
            task.defer(function()  -- Użycie task.defer do wykonania w tle
                for _, Pet in ipairs(Stats.Save.Pets) do
                    if tostring(Pet.n) == tostring(PetN) and not Pet.g and not Pet.r and not Pet.dm then
                        workspace["__REMOTES"]["Game"]["Golden Pets"]:InvokeServer(Pet.id)
                    end
                end
            end)
        end
    end

    -- Łączenie w Rainbow
    for PetN, Amount in pairs(RainbowTable) do
        if Amount >= 7 then
            task.defer(function()  -- Użycie task.defer do wykonania w tle
                for _, Pet in ipairs(Stats.Save.Pets) do
                    if tostring(Pet.n) == tostring(PetN) and Pet.g and not Pet.r and not Pet.dm then
                        workspace["__REMOTES"]["Game"]["Rainbow Pets"]:InvokeServer(Pet.id)
                    end
                end
            end)
        end
    end

    -- Łączenie w Dark Matter
    for PetN, Amount in pairs(DarkMatterTable) do
        if Amount >= 5 then
            task.defer(function()  -- Użycie task.defer do wykonania w tle
                for _, Pet in ipairs(Stats.Save.Pets) do
                    if tostring(Pet.n) == tostring(PetN) and not Pet.g and Pet.r and not Pet.dm then
                        workspace["__REMOTES"]["Game"]["Dark Matter Pets"]:InvokeServer(Pet.id)
                    end
                end
            end)
        end
    end
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

-- Dodanie zakładki Farming w GUI Rayfield
local FarmingTab = Window:CreateTab("Farming", 4483362458) -- Tworzenie zakładki

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
