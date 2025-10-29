_G.BINDING_HEADER_DestroyCursorItem = "Destroy Cursor Item"

function destroy_cursor_item()
    if CursorHasItem() then
        DeleteCursorItem()
    else
        pick_lowest_value_item()
    end
end

local function get_item_id(link)
    if not link then return nil end
    local _, _, id = string.find(link, "item:(%d+):")
    return tonumber(id)
end

local function get_vendor_price(item_id)
    return aux and aux.account
        and aux.account.merchant_sell
        and aux.account.merchant_sell[item_id]
end

function pick_lowest_value_item()
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
        DEFAULT_CHAT_FRAME:AddMessage("No price found. Please ensure aux is loaded first.")
    end
end

SLASH_LOWESTVALUE1 = "/lowestvalue"
SlashCmdList["LOWESTVALUE"] = PickLowestValueItem
