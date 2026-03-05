local orders = {}
local orderId = 0

CreateThread(function()

    exports.ox_inventory:RegisterStash(
        'hotdog_stash',
        'Hotdog Storage',
        150,
        500000
    )

end)

-- CREATE ORDER
RegisterNetEvent('hotdog:createOrder', function(items)

    local src = source
    local name = GetPlayerName(src)

    local total = (
        (items.hotdog * 10000) +
        (items.water * 5000) +
        (items.sprunk * 5000) +
        (items.coffee * 6000)
    )

    if total <= 0 then return end

    if not exports.ox_inventory:RemoveItem(src,'money',total) then
        TriggerClientEvent('ox_lib:notify',src,{
            description='Not enough cash',
            type='error'
        })
        return
    end

    orderId += 1

    orders[#orders+1] = {
        id = orderId,
        player = src,
        name = name,
        items = items
    }

    TriggerClientEvent('ox_lib:notify',src,{
        description='Order placed!',
        type='success'
    })

    TriggerClientEvent('hotdog:newOrderSound',-1)

end)

-- GET ORDERS
RegisterNetEvent('hotdog:getOrders', function()

    TriggerClientEvent('hotdog:openTablet', source, orders)

end)

-- COMPLETE ORDER
RegisterNetEvent('hotdog:completeOrder', function(id)

    for k,v in pairs(orders) do

        if v.id == id then

            local player = v.player

            if v.items.hotdog > 0 then
                exports.ox_inventory:AddItem(player,'hotdog',v.items.hotdog)
            end

            if v.items.water > 0 then
                exports.ox_inventory:AddItem(player,'water',v.items.water)
            end

            if v.items.sprunk > 0 then
                exports.ox_inventory:AddItem(player,'sprunk',v.items.sprunk)
            end

            if v.items.coffee > 0 then
                exports.ox_inventory:AddItem(player,'coffee',v.items.coffee)
            end

            TriggerClientEvent('ox_lib:notify',player,{
                title='Hotdog Stand',
                description='Your order is ready!',
                type='success'
            })

            table.remove(orders,k)
            break
        end

    end

end)

-- COOK
RegisterNetEvent('hotdog:cookSausage', function()

    local src = source

    if exports.ox_inventory:RemoveItem(src,'sausage',1) then
        exports.ox_inventory:AddItem(src,'cooked_sausage',1)
    end

end)

-- ASSEMBLE
RegisterNetEvent('hotdog:assembleHotdog', function()

    local src = source

    local bread = exports.ox_inventory:GetItemCount(src,'bread')
    local sausage = exports.ox_inventory:GetItemCount(src,'cooked_sausage')

    if bread >= 1 and sausage >= 1 then

        exports.ox_inventory:RemoveItem(src,'bread',1)
        exports.ox_inventory:RemoveItem(src,'cooked_sausage',1)

        exports.ox_inventory:AddItem(src,'hotdog',1)

    else

        TriggerClientEvent('ox_lib:notify',src,{
            description='Need bread and cooked sausage',
            type='error'
        })

    end

end)