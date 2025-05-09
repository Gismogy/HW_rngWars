local currentWeaponType = nil

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

function findWeapon(rand)
    for _, weapon in ipairs(workingWeapons) do
        if rand <= weapon.percentage then
            local actualName = (weapon.name == "gtSniperRifle") and "gtSniperRifle" or weapon.name
            return _G[actualName] or gtSniperRifle, actualName
        end
    end
    return gtSniperRifle, "gtSniperRifle"
end

function randomiseMe()
    local rand = GetRandom(230)
    AddCaption(tostring(rand), 0x00FFFFFF, capgrpGameState)

    local gearID, name = findWeapon(rand)
    return { id = gearID, name = name }
end

function onNewTurn()
    currentWeaponType = randomiseMe()
    AddCaption("This turn's weapon: " .. currentWeaponType.name, 0xFFFFFFFF, capgrpGameState)
end

function onGearAdd(gear)
    if GetGearType(gear) == gtBall then
        local chosen = currentWeaponType or { id = gtSniperRifle, name = "gtSniperRifle" }

        local x, y = GetGearPosition(gear)
        local dx, dy = GetGearVelocity(gear)

        WriteLnToConsole("Spawning gear: " .. tostring(chosen.name) .. " -> " .. tostring(chosen.id))

        AddGear(x, y, chosen.id, 0, dx, dy, 0)
        DeleteGear(gear)
    end
end
