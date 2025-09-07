# Godot Inventory System

A modular, expandable inventory system for Godot 4.x using Resources and built-in Control drag-and-drop functionality.

## Features

- **Resource-based items** - Easy content creation and modification
- **Drag & drop interface** - Native Godot Control system integration
- **Modular architecture** - Easy to extend and customize
- **Multi-container support** - Player inventory, chests, shops, etc.
- **Event-driven design** - Signals for all major operations
- **Performance optimized** - Efficient UI updates and minimal allocations

## Quick Start

### Prerequisites

- Godot 4.x
- Basic understanding of Godot scenes and scripts
- Claude Code (for assisted implementation)

### Implementation Order

Follow this order when implementing the system to avoid dependency issues:

1. **Core Resources** (ItemResource, InventorySlot, InventoryData)
2. **Core Logic** (InventoryManager)
3. **UI Components** (InventorySlotUI, InventoryUI)
4. **Drag & Drop System**
5. **Autoload Setup**
6. **Demo Scene**

## Claude Code Implementation Guide

Use these commands with Claude Code to implement the system step by step:

### Step 1: Create Core Resources

```bash
# Create the base item resource
claude code "Create ItemResource.gd in scripts/inventory/core/ based on the inventory system architecture. Include all properties: id, name, description, icon, stack_size, and ItemType enum."

# Create inventory slot resource
claude code "Create InventorySlot.gd in scripts/inventory/core/ with item property, quantity, and is_empty() method."

# Create inventory data resource
claude code "Create InventoryData.gd in scripts/inventory/core/ with slots array, max_slots, and initialization logic."
```

### Step 2: Implement Core Logic

```bash
# Create the inventory manager
claude code "Create InventoryManager.gd in scripts/inventory/core/ with signals for item_added, item_removed, slot_changed. Include methods: add_item, remove_item, move_item, can_stack_items."

# Create drag data structure
claude code "Create DragData.gd in scripts/inventory/core/ with source_slot, item, quantity, and source_inventory properties."
```

### Step 3: Build UI Components

```bash
# Create slot UI component
claude code "Create InventorySlotUI.gd in scripts/inventory/ui/ that extends Control. Include drag and drop overrides: _can_drop_data, _drop_data, _get_drag_data. Add slot_data and slot_index properties."

# Create main inventory UI
claude code "Create InventoryUI.gd in scripts/inventory/ui/ that manages a grid of InventorySlotUI components. Include setup method that takes InventoryManager parameter."

# Create the corresponding scene files
claude code "Create InventorySlotUI.tscn scene with Control root, background panel, item icon, and quantity label."

claude code "Create InventoryUI.tscn scene with Control root containing GridContainer for slots."
```

### Step 4: Setup Autoload

```bash
# Create autoload scripts
claude code "Create InventorySystem.gd in autoload/ folder with player_inventory property and initialization logic."

claude code "Create ItemRegistry.gd in autoload/ folder with items_by_id dictionary and item lookup methods."
```

### Step 5: Create Demo

```bash
# Create demo scene and script
claude code "Create InventoryDemo.gd in scripts/demo/ that sets up a test inventory with sample items and shows the UI."

claude code "Create InventoryDemo.tscn scene that demonstrates the inventory system with test items."
```

### Step 6: Add Sample Items

```bash
# Create sample item resources
claude code "Create health_potion.tres in resources/items/consumables/ - a consumable item that heals 50 HP."

claude code "Create iron_sword.tres in resources/items/equipment/ - a weapon with attack power."

claude code "Create oak_wood.tres in resources/items/materials/ - a stackable crafting material."
```

## Project Structure Reference

```
scripts/inventory/
├── core/
│   ├── ItemResource.gd
│   ├── InventorySlot.gd
│   ├── InventoryData.gd
│   ├── InventoryManager.gd
│   └── DragData.gd
├── ui/
│   ├── InventoryUI.gd
│   ├── InventorySlotUI.gd
│   ├── ItemTooltip.gd
│   └── DragPreview.gd
└── containers/
    ├── BaseContainer.gd
    ├── ChestContainer.gd
    └── ShopContainer.gd

scenes/ui/inventory/
├── InventoryUI.tscn
├── InventorySlotUI.tscn
├── ItemTooltip.tscn
└── DragPreview.tscn

autoload/
├── InventorySystem.gd
└── ItemRegistry.gd
```

## Usage Examples

### Basic Setup

```gdscript
# In your main scene
var inventory_ui = preload("res://scenes/ui/inventory/InventoryUI.tscn").instantiate()
inventory_ui.setup(InventorySystem.player_inventory)
add_child(inventory_ui)
```

### Adding Items

```gdscript
# Load an item resource
var health_potion = preload("res://resources/items/consumables/health_potion.tres")

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

# Or create .tres files in resources/items/
```

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

### Debug Commands

```bash
# Check implementation with Claude Code
claude code "Review the InventoryManager implementation and suggest optimizations"

claude code "Debug why drag and drop isn't working in InventorySlotUI"

claude code "Add error handling and validation to the inventory system"
```

## Testing

### Manual Tests

1. **Basic Operations:**
   - Add items to inventory
   - Remove items from inventory
   - Drag items between slots

2. **Edge Cases:**
   - Drag onto occupied slot
   - Stack similar items
   - Drag non-stackable items

3. **UI Responsiveness:**
   - Hover effects
   - Visual feedback during drag
   - Proper preview generation

### Automated Tests

```bash
# Create unit tests with Claude Code
claude code "Create unit tests for InventoryManager class covering add_item, remove_item, and move_item methods"

claude code "Create integration tests for the drag and drop system"
```

## Next Steps

### Phase 1: Core Features ✓
- Basic drag and drop
- Item stacking
- Visual feedback

### Phase 2: Enhanced UI
- Tooltips on hover
- Better drag previews
- Slot filtering

### Phase 3: Advanced Features
- Equipment slots
- Item categories
- Auto-sorting

### Phase 4: Persistence
- Save/load system
- Serialization
- World state management

## Contributing

When extending the system:

1. Follow the existing architecture patterns
2. Use Claude Code for complex implementations
3. Test thoroughly with edge cases
4. Update this README with new features

## License

[Add your license here]

---

**Ready to implement?** Start with Step 1 above and use Claude Code to build each component systematically.