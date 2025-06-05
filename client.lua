local noclip = false
local baseSpeed = 0.7

RegisterCommand("noclip", function()
    noclip = not noclip
    local player = PlayerPedId()
    SetEntityInvincible(player, noclip)
    SetEntityVisible(player, not noclip)
    SetEntityCollision(player, not noclip, false)
    FreezeEntityPosition(player, false)

    TriggerServerEvent("logNoclipStatus", noclip)

    if noclip then
        print("✅ Noclip AKTIV")
    else
        print("🛑 Noclip DISABLE")
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if noclip then
            local player = PlayerPedId()
            local coords = GetEntityCoords(player)
            SetEntityVelocity(player, 0.0, 0.0, 0.0)
            SetEntityCollision(player, false, false)

            local speed = baseSpeed
            if IsControlPressed(0, 21) then
                speed = speed * 2.4
            end

            local camRot = GetGameplayCamRot(2)
            local heading = math.rad(camRot.z)
            local pitch = math.rad(camRot.x)

            local dirX = -math.sin(heading) * math.cos(pitch)
            local dirY = math.cos(heading) * math.cos(pitch)
            local dirZ = math.sin(pitch)

            if IsControlPressed(0, 32) then
                SetEntityCoordsNoOffset(player,
                    coords.x + dirX * speed,
                    coords.y + dirY * speed,
                    coords.z + dirZ * speed,
                    true, true, true)
            elseif IsControlPressed(0, 33) then
                SetEntityCoordsNoOffset(player,
                    coords.x - dirX * speed,
                    coords.y - dirY * speed,
                    coords.z - dirZ * speed,
                    true, true, true)
            end
        else
            local player = PlayerPedId()
            SetEntityCollision(player, true, true)
        end
    end
end)
