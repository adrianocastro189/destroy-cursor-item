_G.BINDING_HEADER_DestroyCursorItem = "Destroy Cursor Item"

CursorDestroyer = {
    format_money = function(copper)
        if type(copper) ~= "number" then return "" end

        local gold = math.floor(copper / 10000)
        local silver = math.floor(math.mod(copper, 10000) / 100)
        local copper = math.mod(copper, 100)

        local parts = {}

        if gold > 0 then
            table.insert(parts, gold .. "g")
        end
        if silver > 0 then
            table.insert(parts, silver .. "s")
        end
        if copper > 0 or table.getn(parts) == 0 then
            table.insert(parts, copper .. "c")
        end

        return table.concat(parts, " ")
    end,

    --[[ Helper function to extract item ID from item link ]]
    get_item_id = function(link)
        if not link then return nil end
        local _, _, id = string.find(link, "item:(%d+):")
        return tonumber(id)
    end,

    -- [[ Helper function to get vendor price from aux addon ]]
    get_vendor_price = function(item_id)
        return CursorDestroyer.is_aux_loaded() and aux.account.merchant_sell[item_id]
    end,

    -- [[ Helper function to check if aux addon is loaded ]]
    is_aux_loaded = function()
        return aux ~= nil and aux.account ~= nil and aux.account.merchant_sell ~= nil
    end,

    -- [[ Selects and destroys the lowest value gray item in bags, or destroys the item on cursor if present ]]
    maybe_pick_and_destroy = function()
        if CursorHasItem() then
            DeleteCursorItem()
        else
            CursorDestroyer.pick_lowest_value_item()
        end
    end,

    pick_lowest_value_item = function()
        if not CursorDestroyer.is_aux_loaded() then
            CursorDestroyer.print(
            "Aux addon is not loaded. DestroyCursorItem won't automatically pick the lowest gray value item.")
            return
        end

        local lowestValue, lowestBag, lowestSlot = nil, nil, nil

        for bag = 0, 4 do
            local numSlots = GetContainerNumSlots(bag)
            if numSlots and numSlots > 0 then
                for slot = 1, numSlots do
                    local link = GetContainerItemLink(bag, slot)
                    if link then
                        local id = CursorDestroyer.get_item_id(link)
                        local _, _, quality = GetItemInfo(id)

                        if quality == 0 then -- only gray items
                            local price = CursorDestroyer.get_vendor_price(id)
                            if price and price > 0 then
                                if not lowestValue or price < lowestValue then
                                    lowestValue = price
                                    lowestBag = bag
                                    lowestSlot = slot
                                end
                            end
                        end
                    end
                end
            end
        end

        if lowestBag and lowestSlot then
            ClearCursor()
            PickupContainerItem(lowestBag, lowestSlot)
            local itemLink = GetContainerItemLink(lowestBag, lowestSlot)
            CursorDestroyer.print("Cheapest gray item picked up: " ..
                itemLink .. " with vendor price " .. CursorDestroyer.format_money(lowestValue) .. ".")
        else
            CursorDestroyer.print("No gray items with vendor price found in the bags.")
        end
    end,

    print = function(msg)
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000[DestroyCursorItem]|r " .. msg)
    end,
}
