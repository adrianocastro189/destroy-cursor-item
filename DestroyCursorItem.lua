_G.BINDING_HEADER_DestroyCursorItem = "Destroy Cursor Item"

function destroy_cursor_item()
    if CursorHasItem() then
        DeleteCursorItem()
    else
        print("No item on cursor.")
    end
end