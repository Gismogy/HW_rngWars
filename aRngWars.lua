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
    { name = "gtClusterBomb", percentage = 110, options = {} },
    { name = "gtCake", percentage = 120, options = {} },
    { name = "gtMine", percentage = 130, options = {} },
    { name = "gtMortar", percentage = 140, options = {} },
    { name = "gtMolotov", percentage = 150, options = {} },
    { name = "gtMinigun", percentage = 160, options = {} },
    { name = "gtGrenade", percentage = 170, options = {} },
    { name = "gtGasBomb", percentage = 180, options = {} },
    { name = "gtFlamethrower", percentage = 190, options = {} },
    { name = "gtFirePunch", percentage = 200, options = {} },
    { name = "gtNapalmBomb", percentage = 201, options = {} },
    { name = "gtWatermelon", percentage = 202, options = {} },
    { name = "gtSMine", percentage = 203, options = {} },
    { name = "gtHellishBomb", percentage = 204, options = {} },
    { name = "gtDynamite", percentage = 205, options = {} },
    { name = "gtDrill", percentage = 206, options = {} },
    { name = "gtCreeper", percentage = 207, options = {} },
    { name = "gtClusterBomb", percentage = 208, options = {} }
}

function findWeapon(rand)
    for _, weapon in ipairs(workingWeapons) do
        if rand <= weapon.percentage then
            return _G[weapon.name] or gtGrenade, weapon.name
        end
    end
    return gtGrenade, "gtGrenade"
end

function randomiseMe()
    if currentWeaponType then
        return currentWeaponType
    end

    local rand = GetRandom(228)

    if rand > 220 then
       -- AddCaption("OP", 0x00FFFFFF, capgrpGameState)
    else
       -- AddCaption("not OP", 0x00FFFFFF, capgrpGameState)
    end

    local gearID, name = findWeapon(rand)
    currentWeaponType = { id = gearID, name = name }
    return currentWeaponType
end



function onGearAdd(gear)
    if GetGearType(gear) == gtBall then
        local chosen = randomiseMe()
        AddCaption(tostring(chosen.name), 0x00FFFFFF, capgrpGameState)

        local x, y = GetGearPosition(gear)
        local dx, dy = GetGearVelocity(gear)

        WriteLnToConsole("Spawning gear: " .. tostring(chosen.name) .. " -> " .. tostring(chosen.id))

        AddGear(x, y, chosen.id, 0, dx, dy, 0)
        DeleteGear(gear)
    end
end

function onNewTurn()
    currentWeaponType = nil
end
