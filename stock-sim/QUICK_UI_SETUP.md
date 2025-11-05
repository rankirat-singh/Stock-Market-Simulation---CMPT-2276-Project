# Quick UI Setup Instructions

Since modifying `.tscn` files directly is complex, here's what you need to do in Godot:

## Quick Setup (5 minutes):

### 1. Add Quarter Display

1. Open `Scenes/main_scene.tscn` in Godot
2. Find `GameWindow` node
3. Right-click → Add Child Node → `Label`
4. Name it: **"QuarterLabel"**
5. In Inspector:
   - Layout → Anchors Preset: "Top Left"
   - Position: X=20, Y=20
   - Text: "Quarter 1 of 4"
   - Theme Overrides → Font Size: 28
   - Theme Overrides → Colors → Font Color: White

### 2. Add Next Quarter Button

1. Find the existing button container (or create new `VBoxContainer`)
2. Add a new `Button` node
3. Name it: **"NextQuarterButton"**
4. Properties:
   - Text: "⏭️ Next Quarter"
   - Custom Minimum Size: X=200, Y=50
   - Theme → Font Size: 18
5. Click on "Node" tab (top right)
6. Find "Signals" → "pressed()"
7. Click "Connect" → Select "MainScene" (your Game_manager script)
8. Method: `advance_quarter`
9. Click "Connect"

### 3. Add Tutorial Button

1. Add another `Button` near the top
2. Name it: **"LearnButton"**
3. Properties:
   - Text: "📚 Learn"
   - Position: Top-right corner
   - Font Size: 18
4. Attach the `tutorial_button.gd` script to it:
   - Select the button
   - In Inspector → Script → Load → Navigate to `scripts/tutorial_button.gd`
   - Or drag the script file onto the button
5. In Inspector, you'll see "Tutorial Key" export variable
   - Set it to: "sma" (or "welcome", "sentiment", etc.)

### 4. Add Tutorial Dialog

1. In Scene tree, right-click on `MainScene`
2. Select "Instantiate Child Scene"
3. Navigate to `Scenes/tutorial_dialog.tscn`
4. Select it → Open
5. The dialog will be added as a child
6. Make sure it's named: **"TutorialDialog"**

### 5. Test It!

1. Press F5 to run
2. Console should show: "Quarter 1 of 4" update message
3. Click "Next Quarter" button → Should advance to Q2
4. Click "Learn" button → Should show tutorial popup
5. Stock prices should change each quarter

## Alternative: Manual Scene Update

If you prefer to edit the .tscn file directly, add these nodes after line 45 (after GameWindow):

```
[node name="QuarterLabel" type="Label" parent="GameWindow"]
offset_left = 20.0
offset_top = 20.0
offset_right = 250.0
offset_bottom = 60.0
theme_override_font_sizes/font_size = 28
text = "Quarter 1 of 4"

[node name="TutorialDialog" parent="." instance=ExtResource("tutorial_dialog")]
visible = false

[node name="NextQuarterButton" type="Button" parent="GameWindow/TabContainer/Stock View/ButtonContainer"]
custom_minimum_size = Vector2(200, 50)
text = "⏭️ Next Quarter"
```

Then connect the signal in code or in inspector.

## What Each Component Does:

- **QuarterLabel**: Shows "Quarter 1 of 4", updates automatically
- **NextQuarterButton**: Advances game to next quarter
- **LearnButton**: Shows educational tutorial popup
- **TutorialDialog**: Popup window that displays tutorial content

## Testing Checklist:

- [ ] QuarterLabel shows "Quarter 1 of 4"
- [ ] NextQuarterButton exists and is clickable
- [ ] Clicking Next Quarter advances the game
- [ ] Stock prices change when quarter advances
- [ ] QuarterLabel updates to "Quarter 2 of 4", etc.
- [ ] Learn button shows tutorial popup (not just console)
- [ ] Tutorial popup has title and formatted content
- [ ] Can close tutorial popup with "Got it!" button

## Styling (Optional but Recommended):

For professional look, select each `PanelContainer` and:
1. Theme Overrides → Styles → Panel
2. Create new StyleBoxFlat
3. Set Background Color: #16213E (dark blue)
4. Border → Width All: 2
5. Border → Color: #3498DB (light blue)

For buttons:
1. Theme Overrides → Colors → Font Color: #2ECC71 (green for Buy)
2. Custom Minimum Size: 200x50 for larger clickable area

---

**After setup, commit the changes:**
```powershell
git add .
git commit -m "Add quarter display, next quarter button, and tutorial dialog"
```
