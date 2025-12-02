# UML Diagrams - Stock Trading Simulator

This directory contains comprehensive UML diagrams documenting the architecture of the Stock Trading Simulator project.

## Diagrams Included

### 1. **Class Diagram** (`UML_Diagram.puml`)
Shows the static structure of the system:
- **Game_manager**: Main controller class with all game logic
- **CandlestickChart**: Visualization component for stock price rendering
- **OHLCCandle**: Data structure for candlestick data (Open, High, Low, Close)
- **StockData**: Model for stock information
- **Portfolio**: Player's holdings and cash
- **CSVDataParser**: Utility for processing historical stock data
- Relationships between all classes

### 2. **Sequence Diagram** (`UML_Sequence_Diagram.puml`)
Illustrates key interactions and message flows:
- Game initialization sequence
- Stock selection flow
- Buy stock transaction with validation
- Sell stock transaction with validation
- Quarter advancement process
- Chart rendering internals
- Tutorial system activation

### 3. **State Diagram** (`UML_State_Diagram.puml`)
Documents the game flow and state transitions:
- Game initialization states
- Quarter 1-4 gameplay loops
- Buy/sell/hold action states
- Transaction validation states
- End game calculation
- Victory/defeat conditions

### 4. **Component Diagram** (`UML_Component_Diagram.puml`)
Shows the high-level architecture:
- Game Logic Layer (Game Manager, Portfolio, Stock Data)
- Visualization Layer (Chart, UI Components)
- Data Processing (CSV Parser)
- Dialog System (Tutorials, Transactions)
- Integration with Godot Engine

## How to View These Diagrams

### Online Tools (Easiest)
1. **PlantUML Online Server**: http://www.plantuml.com/plantuml/uml/
   - Copy the content of any `.puml` file
   - Paste it into the text area
   - View the generated diagram instantly

2. **PlantText**: https://www.planttext.com/
   - Similar to above, paste and view

### VS Code Extension
1. Install "PlantUML" extension by jebbs
2. Open any `.puml` file
3. Press `Alt+D` to preview
4. Or right-click → "Preview Current Diagram"

### Local Rendering (Advanced)
1. Install PlantUML: `npm install -g node-plantuml` or download from https://plantuml.com/
2. Install Java (required by PlantUML)
3. Run: `plantuml UML_Diagram.puml`
4. Output: PNG/SVG images

### Export to Images
Using VS Code PlantUML extension:
- Right-click on `.puml` file
- Select "Export Current Diagram"
- Choose format (PNG, SVG, PDF)

## Purpose of Each Diagram

### Class Diagram - For Understanding Structure
- **Use when**: You need to understand what classes exist and how they relate
- **Shows**: Attributes, methods, inheritance, composition, dependencies
- **Audience**: Developers who will modify or extend the codebase

### Sequence Diagram - For Understanding Behavior
- **Use when**: You need to understand how objects interact over time
- **Shows**: Message flows, order of operations, decision points
- **Audience**: Developers implementing features or debugging interactions

### State Diagram - For Understanding Game Flow
- **Use when**: You need to understand valid states and transitions
- **Shows**: Game states, user actions, state transitions, win/lose conditions
- **Audience**: Game designers, testers, documentation writers

### Component Diagram - For Understanding Architecture
- **Use when**: You need a high-level overview of the system
- **Shows**: Major components, layers, dependencies, data flow
- **Audience**: Technical leads, new team members, stakeholders

## Key Design Decisions Documented

1. **Separation of Concerns**
   - Game logic (Game_manager) separate from visualization (CandlestickChart)
   - Data model (StockData) separate from processing (CSVDataParser)

2. **Godot Integration**
   - Game_manager extends Node2D (scene graph node)
   - CandlestickChart extends Control (UI element)
   - Uses Godot's built-in dialog and UI components

3. **Data Structure**
   - Quarterly data → Array of weekly candlesticks
   - Each candlestick → OHLC dictionary
   - Allows flexible time periods and granular visualization

4. **Tutorial System**
   - Dictionary-based content storage
   - Deferred loading to avoid blocking
   - Reusable AcceptDialog component

5. **Transaction Validation**
   - Check funds before buying
   - Check ownership before selling
   - Immediate UI feedback

## Modifying the Diagrams

All diagrams are in PlantUML format, which is text-based and easy to edit:

```plantuml
' Add a new method to Game_manager
class Game_manager {
  + new_method(): void  ' <-- Add this line
}

' Add a new relationship
Game_manager --> NewClass : uses  ' <-- Add this line
```

After editing, just re-render using any of the viewing methods above.

## Integration with Documentation

These diagrams support Section 3 of the project documentation:
- Visual representation of the architecture described in Section 2
- Complete documentation of all major classes
- Relationships and interactions clearly shown
- Accessible format that can be updated as the project evolves

## Notes

- **Omitted Classes**: Godot built-in classes (Node, Control, etc.) are shown only for context but not fully documented as they're framework classes
- **Focus**: Core game logic and custom components that developers will work with
- **Extensibility**: Adding new stocks, features, or UI elements is clearly documented through these diagrams
