local currentWeaponType = nil
local lucky = 0

-- Color table using RGBA format
local colorTable = {
    black    = 0xFF000000,
    white    = 0xFFFFFFFF,
    red      = 0xFFFF0000,
    green    = 0xFF00FF00,
    blue     = 0xFF0000FF,
    yellow   = 0xFFFFFF00,
    cyan     = 0xFF00FFFF,
    magenta  = 0xFFFF00FF,
    gray     = 0xFF808080,
    orange   = 0xFFFFA500,
    pink     = 0xFFFFC0CB,
    purple   = 0xFF800080,
    brown    = 0xFFA52A2A,
    lime     = 0xFF00FF00,
    navy     = 0xFF000080,
    teal     = 0xFF008080,
    olive    = 0xFF808000,
    maroon   = 0xFF800000,
    silver   = 0xFFC0C0C0,
    gold     = 0xFFFFD700,
    beige    = 0xFFF5F5DC,
    sky_blue = 0xFF87CEEB
}

-- Weapon list
local workingWeapons = {
    { name = "gtRCPlane", percentage = 10, options = {} },
    { name = "gtShotgunShot", percentage = 20, options = {} },
    { name = "gtSineGunShot", percentage = 30, options = {} },
    { name = "gtPickHammer", percentage = 40, options = {} },
    { name = "gtEgg", percentage = 50, options = {} },
    { name = "gtAirBomb", percentage = 60, options = {} },
    { name = "gtSnowball", percentage = 70, options = {} },
    { name = "gtShell", percentage = 80, options = {} },
    { name = "gtAirMine", percentage = 90, options = {} },
    { name = "gtBee", percentage = 100, options = {} },
    { name = "gtFirePunch", percentage = 110, options = {} },
    { name = "gtCake", percentage = 120, options = {} },
    { name = "gtMine", percentage = 130, options = {} },
    { name = "gtFlamethrower", percentage = 140, options = {} },
    { name = "gtMolotov", percentage = 150, options = {} },
    { name = "gtMinigun", percentage = 160, options = {} },
    { name = "gtGrenade", percentage = 170, options = {} },
    { name = "gtGasBomb", percentage = 180, options = {} },
    { name = "gtClusterBomb", percentage = 185, options = {} },
    { name = "gtMortar", percentage = 190, options = {} },
    { name = "gtNapalmBomb", percentage = 195, options = {} },
    { name = "gtWatermelon", percentage = 200, options = {} },
    { name = "gtSMine", percentage = 205, options = {} },
    { name = "gtHellishBomb", percentage = 210, options = {} },
    { name = "gtDynamite", percentage = 215, options = {} },
    { name = "gtDrill", percentage = 220, options = {} },
    { name = "gtCreeper", percentage = 225, options = {} },
    { name = "gtClusterBomb", percentage = 230, options = {} }
}

-- Custom message function using color name and message type
function customMessages(messageType, colorName, message)
    local color = colorTable[colorName] or 0xFFFFFFFF

    if messageType == "important" then
        -- Show on left side instead of top
        AddCaption(message, color, capgrpMessage2)
    elseif messageType == "ammo" then
        AddCaption(message, color, capgrpAmmoinfo)
    elseif messageType == "volume" then
        AddCaption(message, color, capgrpVolume)
    elseif messageType == "info" then
        AddCaption(message, color, capgrpAmmostate)
    elseif messageType == "msg" then
        AddCaption(message, color, capgrpMessage)
    elseif messageType == "msg2" then
        AddCaption(message, color, capgrpMessage2)
    else
        -- Fallback to generic left message
        AddCaption("[Unknown type] " .. message, color, capgrpMessage2)
    end
end

-- Selects weapon based on random value
function findWeapon(rand)
    for _, weapon in ipairs(workingWeapons) do
        if rand <= weapon.percentage then
            local actualName = (weapon.name == "gtSniperRifle") and "gtSniperRifle" or weapon.name
            return _G[actualName] or gtSniperRifle, actualName
        end
    end
    return gtSniperRifle, "gtSniperRifle"
end

-- Chooses weapon randomly
function randomiseMe()
    local rand = GetRandom(230)
    local gearID, name = findWeapon(rand)
    return { id = gearID, name = name }
end

-- Called at start of turn
function onNewTurn()
    currentWeaponType = randomiseMe()
    customMessages("important", "white", "This turn's weapon: " .. currentWeaponType.name)
    luckyCheck()
end

-- Extra lucky shot bonuses
function luckyCheck()
    lucky = GetRandom(100)
    if lucky == 50 then
        customMessages("msg2", "sky_blue", "ONE extra shot!! Lucky!")
    elseif lucky == 100 then
        customMessages("msg2", "gold", "Extreme LUCKY!! 5x more shots!")
    end
end

-- Replace gtBall with weapon
function onGearAdd(gear)
    if GetGearType(gear) == gtBall then
        local chosen = currentWeaponType or { id = gtSniperRifle, name = "gtSniperRifle" }
        local x, y = GetGearPosition(gear)
        local dx, dy = GetGearVelocity(gear)

        WriteLnToConsole("Spawning gear: " .. tostring(chosen.name) .. " -> " .. tostring(chosen.id))

        AddGear(x, y, chosen.id, 0, dx, dy, 0)

        if lucky == 50 then
            AddGear(x, y, chosen.id, 0, dx, dy, 0)
        elseif lucky == 100 then
            for i = 1, 5 do
                AddGear(x, y, chosen.id, 0, dx, dy, 0)
            end
        end

        DeleteGear(gear)
    end
end
