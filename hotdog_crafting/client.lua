local tabletCoords    = vector3(-1541.94, -412.78, 35.35)
local orderCoords     = vector3(-1542.13, -413.8, 35.35)
local grillCoords     = vector3(-1546.68, -407.74, 35.75)
local assembleCoords  = vector3(-1548.77, -407.27, 35.6)
local stashCoords     = vector3(-1547.81, -410.9, 36.25)

CreateThread(function()

    -- TABLET
    exports.ox_target:addBoxZone({
        coords = tabletCoords,
        size = vec3(2,2,2),
        options = {
            {
                icon = 'fa-solid fa-tablet',
                label = 'Open Orders Tablet',
                onSelect = function()
                    TriggerServerEvent('hotdog:getOrders')
                end
            }
        }
    })

    -- ORDER
    exports.ox_target:addBoxZone({
        coords = orderCoords,
        size = vec3(2,2,2),
        options = {
            {
                icon = 'fa-solid fa-receipt',
                label = 'Place Order',
                onSelect = function()
                    openOrderMenu()
                end
            }
        }
    })

    -- GRILL
    exports.ox_target:addBoxZone({
        coords = grillCoords,
        size = vec3(2,2,2),
        options = {
            {
                icon = 'fa-solid fa-fire',
                label = 'Cook Sausage',
                onSelect = function()
                    cookSausage()
                end
            }
        }
    })

    -- ASSEMBLE
    exports.ox_target:addBoxZone({
        coords = assembleCoords,
        size = vec3(2,2,2),
        options = {
            {
                icon = 'fa-solid fa-hotdog',
                label = 'Assemble Hotdog',
                onSelect = function()
                    assembleHotdog()
                end
            }
        }
    })

    -- STASH
    exports.ox_target:addBoxZone({
        coords = stashCoords,
        size = vec3(2,2,2),
        options = {
            {
                icon = 'fa-solid fa-box-open',
                label = 'Open Storage',
                onSelect = function()
                    exports.ox_inventory:openInventory('stash','hotdog_stash')
                end
            }
        }
    })

end)

-- ORDER MENU (MULTIPLE ITEMS)
function openOrderMenu()

    local input = lib.inputDialog('Hotdog Stand Order', {
        {type='number', label='Hotdogs', default=0},
        {type='number', label='Water', default=0},
        {type='number', label='Sprunk', default=0},
        {type='number', label='Coffee', default=0},
    })

    if not input then return end

    TriggerServerEvent('hotdog:createOrder', {
        hotdog = input[1],
        water = input[2],
        sprunk = input[3],
        coffee = input[4]
    })

end

-- TABLET
RegisterNetEvent('hotdog:openTablet', function(orders)

    local options = {}

    if #orders == 0 then
        options[#options+1] = {title = 'No Orders'}
    end

    for _,v in pairs(orders) do

        local text =
        'Player: '..v.name..
        '\nHotdog: '..v.items.hotdog..
        '\nWater: '..v.items.water..
        '\nSprunk: '..v.items.sprunk..
        '\nCoffee: '..v.items.coffee

        options[#options+1] = {
            title = 'Order #'..v.id,
            description = text,
            onSelect = function()

                if lib.progressBar({
                    duration = 5000,
                    label = 'Preparing Order...',
                    anim = {
                        dict = 'mp_common',
                        clip = 'givetake1_a'
                    }
                }) then
                    TriggerServerEvent('hotdog:completeOrder', v.id)
                end

            end
        }

    end

    lib.registerContext({
        id = 'tablet_orders',
        title = 'Hotdog Orders',
        options = options
    })

    lib.showContext('tablet_orders')

end)

-- SOUND WHEN NEW ORDER
RegisterNetEvent('hotdog:newOrderSound', function()

    PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

    lib.notify({
        title = 'Hotdog Stand',
        description = 'New Order Received!',
        type = 'inform'
    })

end)

-- COOK
function cookSausage()

    if lib.progressBar({
        duration = 5000,
        label = 'Cooking Sausage...',
        anim = {
            dict = 'amb@prop_human_bbq@male@base',
            clip = 'base'
        }
    }) then
        TriggerServerEvent('hotdog:cookSausage')
    end

end

-- ASSEMBLE
function assembleHotdog()

    if lib.progressBar({
        duration = 4000,
        label = 'Assembling Hotdog...',
        anim = {
            dict = 'mp_common',
            clip = 'givetake1_a'
        }
    }) then
        TriggerServerEvent('hotdog:assembleHotdog')
    end

end