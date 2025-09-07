# Godot Inventory System

A modular, expandable inventory system for Godot 4.x using Resources and built-in Control drag-and-drop functionality.

## Features

- **Resource-based items** - Easy content creation and modification
- **Drag & drop interface** - Native Godot Control system integration
- **Modular architecture** - Easy to extend and customize
- **Multi-container support** - Player inventory, chests, shops, etc.
- **Event-driven design** - Signals for all major operations
- **Performance optimized** - Efficient UI updates and minimal allocations

## Installation

1. Copy the entire `inventory_system/` folder into your Godot project
2. Add the autoload scripts in Project Settings:
   - `inventory_system/autoload/InventorySystem.gd` as "InventorySystem"
   - `inventory_system/autoload/ItemRegistry.gd` as "ItemRegistry"
3. Run the demo scene: `inventory_system/scenes/demo/InventoryDemo.tscn`

## Demo

The system includes a fully functional demo scene that demonstrates:
- Drag and drop between inventory slots
- Automatic item stacking
- Visual feedback and styling
- Sample items with different properties

Run `inventory_system/scenes/demo/InventoryDemo.tscn` to see it in action.

## Project Structure

```
inventory_system/
├── scripts/
│   ├── core/
│   │   ├── ItemResource.gd
│   │   ├── InventorySlot.gd
│   │   ├── InventoryData.gd
│   │   ├── InventoryManager.gd
│   │   └── DragData.gd
│   ├── ui/
│   │   ├── InventoryUI.gd
│   │   └── InventorySlotUI.gd
│   └── demo/
│       └── InventoryDemo.gd
├── scenes/
│   ├── ui/
│   │   ├── InventoryUI.tscn
│   │   └── InventorySlotUI.tscn
│   └── demo/
│       └── InventoryDemo.tscn
├── resources/
│   └── items/
│       ├── consumables/
│       │   └── health_potion.tres
│       ├── equipment/
│       │   └── iron_sword.tres
│       └── materials/
│           └── oak_wood.tres
└── autoload/
    ├── InventorySystem.gd
    └── ItemRegistry.gd
```

## Usage Examples

### Basic Setup

```gdscript
# In your main scene
var inventory_ui = preload("res://inventory_system/scenes/ui/InventoryUI.tscn").instantiate()
inventory_ui.setup(InventorySystem.player_inventory)
add_child(inventory_ui)
```

### Adding Items

```gdscript
# Load an item resource
var health_potion = preload("res://inventory_system/resources/items/consumables/health_potion.tres")

# Add to inventory
InventorySystem.player_inventory.add_item(health_potion, 3)
```

### Creating New Items

```gdscript
# Create via code
var new_item = ItemResource.new()
new_item.id = "magic_sword"
new_item.name = "Magic Sword"
new_item.description = "A sword imbued with magical energy"
new_item.stack_size = 1
new_item.item_type = ItemResource.ItemType.EQUIPMENT

# Or create .tres files in inventory_system/resources/items/
```

## TODOs

### Immediate Improvements
- [ ] **Static demo scene** - Add all items manually via the editor instead of creating them in code
- [ ] **Add icons** - Create and assign icon textures for existing item resources
  - health_potion.tres needs a potion icon
  - iron_sword.tres needs a sword icon  
  - oak_wood.tres needs a wood plank icon

### Future Enhancements
- [ ] **Item tooltips** - Show item details on hover
- [ ] **Better drag previews** - Custom drag preview with item icon
- [ ] **Slot filtering** - Restrict certain items to specific slots
- [ ] **Equipment slots** - Dedicated slots for weapons, armor, etc.
- [ ] **Auto-sorting** - Sort inventory by item type or name
- [ ] **Save/load system** - Persist inventory state
- [ ] **Sound effects** - Audio feedback for drag/drop actions

## Signals Reference

### InventoryManager Signals

- `item_added(item: ItemResource, quantity: int)` - Item was added to inventory
- `item_removed(item: ItemResource, quantity: int)` - Item was removed from inventory
- `slot_changed(slot_index: int)` - Specific slot contents changed

### InventorySlotUI Signals

- `slot_clicked(slot_index: int)` - Slot was clicked
- `slot_hovered(slot_index: int)` - Mouse entered slot area
- `slot_unhovered(slot_index: int)` - Mouse left slot area

## Extension Points

### Adding New Item Types

1. Add new enum value to `ItemResource.ItemType`
2. Create component script in `scripts/inventory/items/ItemComponents/`
3. Handle in UI where needed

### Adding New Container Types

1. Extend `BaseContainer.gd` in `scripts/inventory/containers/`
2. Create corresponding UI scene
3. Add specific logic for container behavior

### Custom Drag Behavior

Override these methods in `InventorySlotUI`:

- `_can_drop_data(position: Vector2, data: Variant) -> bool`
- `_drop_data(position: Vector2, data: Variant) -> void`
- `_get_drag_data(position: Vector2) -> Variant`

## Troubleshooting

### Common Issues

**Drag and drop not working:**
- Ensure InventorySlotUI extends Control (not Panel or other nodes)
- Check that `_get_drag_data()` returns proper DragData resource
- Verify `_can_drop_data()` logic

**Items not displaying:**
- Check that ItemResource has icon texture assigned
- Verify InventorySlotUI scene has proper child nodes
- Ensure slot_data is properly assigned

**Performance issues:**
- Only update UI when slot contents change
- Use object pooling for large inventories
- Minimize signal connections

## Contributing

When extending the system:

1. Follow the existing architecture patterns
2. Test thoroughly with edge cases
3. Update this README with new features

## License

[Add your license here]