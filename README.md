# Destroy Cursor Item

A lightweight World of Warcraft addon that allows players to assign a hotkey to delete the item on their cursor.

## Usage

1. Install it by creating a folder named `DestroyCursorItem` in your 
   `Interface/AddOns` directory and placing the addon's files there.
1. Log in to the game and open the **Key Bindings** menu.
1. Find the "Destroy Cursor Item" key binding.
1. Assign a hotkey to it, like F12.
1. Now, whenever you **left-click** an item in your inventory, which results in
   the item being on your cursor, you can press the assigned hotkey to delete
   it **immediately, with no confirmation prompt**.
1. **(New in 1.1.0)** If you don't have an item on your cursor, pressing the
   hotkey will pick up the cheapest **gray** vendored item stack from your bags
   as a suggestion for deletion, which will be destroyed by hitting the hotkey
   again.

## Warning

**This action is irreversible! Use with caution!**

## Changelog

* 2025.11.01 - Version 1.1.0
  * Added functionality to pick up the cheapest gray item stack when no item is
    on the cursor
* 2025.10.04 - Version 1.0.0
  * First version with basic destroy functionality