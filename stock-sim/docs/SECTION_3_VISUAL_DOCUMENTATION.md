# Section 3: Visual Architecture Documentation

## Overview
This section provides comprehensive UML diagrams documenting the Stock Trading Simulator architecture, fulfilling the requirement for visual representation of the system structure.

## Diagram Coverage

### 1. Class Diagram (Primary Structural View)
**File**: `UML_Diagram.puml`

**Documents**:
- ✅ **Game_manager** - Main game controller (13 methods documented)
- ✅ **CandlestickChart** - Visualization component (6 methods documented)
- ✅ **OHLCCandle** - Core data structure
- ✅ **StockData** - Stock information model
- ✅ **Portfolio** - Player holdings model
- ✅ **CSVDataParser** - Data processing utility (4 methods documented)
- ✅ **UIComponents** - Interface definitions
- ✅ **TutorialSystem** - Tutorial content structure

**Relationships Shown**:
- Inheritance (Game_manager extends Node2D, CandlestickChart extends Control)
- Composition (Game_manager contains Portfolio, StockData, TutorialSystem)
- Dependencies (Game_manager uses dialogs and UI components)
- Associations (CandlestickChart displays OHLCCandle data)

**Justification for Scope**:
- Godot built-in classes (AcceptDialog, ConfirmationDialog, etc.) are shown for context but not fully documented as they are framework classes unlikely to be modified
- Focus on custom classes that developers will directly work with
- All classes mentioned in Section 2 are fully documented here

### 2. Sequence Diagram (Behavioral View)
**File**: `UML_Sequence_Diagram.puml`

**Key Interactions Documented**:
- Game initialization and startup flow
- Stock selection and chart updates
- Complete buy transaction flow with validation
- Complete sell transaction flow with validation
- Quarter advancement and price updates
- Tutorial system activation
- Chart rendering process (internal)
- Win/lose condition evaluation

**Shows**:
- Order of method calls
- Object collaboration
- Validation logic
- UI update patterns
- Error handling paths

### 3. State Diagram (Game Flow View)
**File**: `UML_State_Diagram.puml`

**Game States Documented**:
- Initialization states
- Active gameplay per quarter (Q1-Q4)
- Transaction substates (buying, selling, holding)
- Validation states (funds check, ownership check)
- End game states (victory, defeat)

**Transitions Shown**:
- Player actions triggering state changes
- Automatic transitions between quarters
- Conditional transitions based on validation
- Terminal states at game end

### 4. Component Diagram (Architectural View)
**File**: `UML_Component_Diagram.puml`

**System Layers**:
- **Game Logic Layer**: Core game mechanics
- **Visualization Layer**: Charts and UI
- **Data Processing**: CSV parsing and data preparation
- **Dialog System**: User interactions
- **Godot Engine Integration**: Framework components

**Interfaces and Ports**:
- Clear component boundaries
- Data flow between layers
- External dependencies (CSV files)
- Integration points with Godot

## Design Rationale

### Why These Diagrams?

1. **Class Diagram**: Required for understanding the code structure - shows all classes, their responsibilities, and relationships
2. **Sequence Diagram**: Essential for understanding complex interactions like buying/selling stocks with validation
3. **State Diagram**: Critical for understanding valid game states and player actions
4. **Component Diagram**: Provides high-level overview showing how the system is organized into layers

### What's Omitted (and Why)

1. **Individual Tutorial Content Classes**: The tutorial system uses a Dictionary-based approach rather than polymorphic classes. Including 5 separate classes for each tutorial would add clutter without value - the data structure approach is documented instead.

2. **Godot Framework Details**: Classes like Node2D, Control, AcceptDialog are Godot built-ins. They're shown for context but not fully documented as they're not project-specific and won't be modified.

3. **Backup Python Files**: The project transitioned from Python to GDScript. Old Python classes (Game_manager.py, TutorialManager.py, etc.) are not documented as they're no longer active in the codebase.

4. **Individual UI Labels**: Rather than documenting every Label and Button node, they're abstracted as "UIComponents interface" since they're standard Godot nodes used via find_child().

### Targeted and Accessible

The diagrams focus on:
- ✅ **Classes developers will modify** (Game_manager, CandlestickChart)
- ✅ **Core data structures** (OHLCCandle, StockData)
- ✅ **Key utilities** (CSVDataParser for adding new stocks)
- ✅ **Extension points** (adding new stocks, tutorials, features)

They avoid:
- ❌ Over-documenting framework classes
- ❌ Repeating information better shown in code comments
- ❌ Documenting temporary/backup files

## How to Use This Documentation

### For New Developers:
1. Start with **Component Diagram** - understand the big picture
2. Read **Class Diagram** - understand what exists and how it relates
3. Review **State Diagram** - understand valid game flow
4. Study **Sequence Diagrams** - understand complex interactions

### For Feature Implementation:
1. Check **Class Diagram** - which class to modify
2. Review **Sequence Diagram** - understand current flow
3. Update diagrams - document your changes

### For Adding New Stocks:
1. **Class Diagram** shows CSVDataParser usage
2. **Sequence Diagram** shows data flow from CSV to Chart
3. Modify StockData arrays in Game_manager

### For Debugging:
1. **Sequence Diagram** shows exact order of operations
2. **State Diagram** shows valid state transitions
3. Check if issue is in validation, execution, or UI update

## Viewing the Diagrams

### Quick View (No Installation):
Visit: http://www.plantuml.com/plantuml/uml/
1. Open any `.puml` file from the `docs/` folder
2. Copy the entire contents
3. Paste into the web tool
4. View the rendered diagram

### In VS Code:
1. Install "PlantUML" extension (by jebbs)
2. Open any `.puml` file
3. Press `Alt+D` or right-click → "Preview Current Diagram"

See `docs/UML_README.md` for complete viewing instructions.

## Maintenance

These diagrams are **living documentation**:
- Update them when adding major features
- Keep them in sync with Section 2 text
- Text-based format makes version control easy
- Can be rendered as PNG/SVG for final reports

## Compliance with Requirements

✅ **Expands Section 2**: Visual representation of architecture described in text
✅ **All classes documented**: Game_manager, CandlestickChart, data structures, utilities
✅ **Appropriate visual forms**: UML class/sequence/state/component diagrams as taught in course
✅ **Accessible**: PlantUML text format is readable and renderable
✅ **Targeted**: Focus on classes likely to be modified or reused
✅ **Complete yet concise**: Omits excessive detail on framework classes and data-only structures

---

**Related Files**:
- `docs/UML_Diagram.puml` - Main class diagram
- `docs/UML_Sequence_Diagram.puml` - Interaction flows
- `docs/UML_State_Diagram.puml` - Game states
- `docs/UML_Component_Diagram.puml` - System architecture
- `docs/UML_README.md` - Detailed viewing and usage instructions
