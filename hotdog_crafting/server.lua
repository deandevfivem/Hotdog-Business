local orders = {}
local orderId = 0

-- REGISTER STASH
CreateThread(function()
    exports.ox_inventory:RegisterStash(
        'hotdog_stash',
        'Hotdog Storage',
        100,
        200000
    )
end)

-- CREATE ORDER
RegisterNetEvent('hotdog:createOrder', function(items)
    local src = source

    local prices = {
        hotdog = 10,
        water = 5,
        sprunk = 5,
        coffee = 7
    }

    local total = 0

    for _,item in pairs(items) do
        total = total + prices[item]
    end

    -- TAKE CASH
    local removed = exports.ox_inventory:RemoveItem(src,'money',total)

    if not removed then
        TriggerClientEvent('ox_lib:notify',src,{
            title='Hotdog Stand',
            description='Not enough cash',
            type='error'
        })
        return
    end

    -- ADD TO BUSINESS ACCOUNT
    exports['Renewed-Banking']:addAccountMoney('hotdog', total)

    orderId += 1

    orders[#orders+1] = {
        id = orderId,
        items = items,
        player = src,
        name = GetPlayerName(src)
    }

    -- NOTIFY CUSTOMER
    TriggerClientEvent('ox_lib:notify',src,{
        title='Order Placed',
        description='Your order #'..orderId..' has been placed',
        type='success'
    })

    -- SOUND FOR WORKERS
    TriggerClientEvent('hotdog:newOrderSound', -1)
end)

-- SEND TABLET DATA
RegisterNetEvent('hotdog:requestTabletData', function()
    local src = source
    TriggerClientEvent('hotdog:openTabletMenu', src, orders)
end)

-- COMPLETE ORDER
RegisterNetEvent('hotdog:fulfillOrder', function(id)
    local src = source

    for k,v in pairs(orders) do
        if v.id == id then

            local player = v.player

            for _,item in pairs(v.items) do

                if item == "hotdog" then
                    exports.ox_inventory:AddItem(player,'hotdog',1)
                elseif item == "water" then
                    exports.ox_inventory:AddItem(player,'water',1)
                elseif item == "sprunk" then
                    exports.ox_inventory:AddItem(player,'sprunk',1)
                elseif item == "coffee" then
                    exports.ox_inventory:AddItem(player,'coffee',1)
                end

            end

            -- CUSTOMER NOTIFICATION
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

-- COOK SAUSAGE
RegisterNetEvent('hotdog:cookSausage', function()
    local src = source

    if exports.ox_inventory:RemoveItem(src,'sausage',1) then
        exports.ox_inventory:AddItem(src,'cooked_sausage',1)
    else
        TriggerClientEvent('ox_lib:notify',src,{
            title='Cooking',
            description='You need raw sausage',
            type='error'
        })
    end
end)

-- ASSEMBLE HOTDOG
RegisterNetEvent('hotdog:assemble', function()
    local src = source

    local bread = exports.ox_inventory:GetItemCount(src,'bread')
    local sausage = exports.ox_inventory:GetItemCount(src,'cooked_sausage')

    if bread >= 1 and sausage >= 1 then

        exports.ox_inventory:RemoveItem(src,'bread',1)
        exports.ox_inventory:RemoveItem(src,'cooked_sausage',1)

        exports.ox_inventory:AddItem(src,'hotdog',1)

    else

        TriggerClientEvent('ox_lib:notify',src,{
            title='Assemble',
            description='You need bread and cooked sausage',
            type='error'
        })

    end
end)
