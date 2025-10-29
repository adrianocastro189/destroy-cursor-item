_G.BINDING_HEADER_DestroyCursorItem = "Destroy Cursor Item"

function destroy_cursor_item()
    if CursorHasItem() then
        DeleteCursorItem()
    else
        pick_lowest_value_item()
    end
end

--[[ Helper function to extract item ID from item link ]]
local function get_item_id(link)
    if not link then return nil end
    local _, _, id = string.find(link, "item:(%d+):")
    return tonumber(id)
end

-- [[ Helper function to get vendor price from aux addon ]]
local function get_vendor_price(item_id)
    return is_aux_loaded() and aux.account.merchant_sell[item_id]
end

-- [[ Helper function to check if aux addon is loaded ]]
local function is_aux_loaded()
    return aux ~= nil and aux.account ~= nil and aux.account.merchant_sell ~= nil
end

function pick_lowest_value_item()
    if not is_aux_loaded() then
        DEFAULT_CHAT_FRAME:AddMessage(
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
                    local id = get_item_id(link)
                    local _, _, quality = GetItemInfo(id)

                    if quality == 0 then -- only gray items
                        local price = get_vendor_price(id)
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
        DEFAULT_CHAT_FRAME:AddMessage("Cheapest gray item picked up: " ..
            itemLink .. " with vendor price " .. lowestValue .. ".")
    else
        DEFAULT_CHAT_FRAME:AddMessage("No gray items with vendor price found in the bags.")
    end
end
