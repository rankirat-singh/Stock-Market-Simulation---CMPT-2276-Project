# Troubleshooting Guide - Game Won't Start

## Common Issues When Godot Won't Run:

### 1. Check Godot Console Output

When you press F5, look at the **Output** tab (bottom of Godot):

**Look for:**
- Red error messages
- "Failed to load script"
- "Module not found"
- "Syntax error"
- "Exception occurred"

### 2. Common Py4Godot Issues

**Error: "Cannot load script"**
- **Fix:** Make sure py4godot plugin is enabled
- Go to: Project → Project Settings → Plugins
- Check that "py4godot" is enabled (checkmark)

**Error: "Python module not found"**
- **Fix:** py4godot isn't installed properly
- Check if `addons/py4godot/` folder exists

**Error: "Import error: Stock/Portfolio"**
- **Fix:** Already fixed in the code, should work now

### 3. Quick Fixes to Try

**Fix 1: Reload Godot**
1. Close Godot completely
2. Reopen the project
3. Try running again (F5)

**Fix 2: Clear Script Cache**
1. In Godot: Editor → Editor Settings
2. Search for "Clear Script Cache"
3. Click it
4. Restart Godot

**Fix 3: Check Main Scene is Set**
1. Project → Project Settings → Application → Run
2. Make sure "Main Scene" is set to `res://Scenes/main_scene.tscn`
3. If not, click the folder icon and select it

**Fix 4: Test with Simple Scene**
1. Create a new scene (Scene → New Scene)
2. Add a Node2D as root
3. Press F6 (run current scene)
4. If this works, the issue is in main_scene.tscn

### 4. Test Python Separately

Run this in PowerShell to test if imports work:

```powershell
cd "c:\Users\Rankirat\Douglas\CMPT 2276\Project\stock-sim"
python -c "from scripts.Stock import Stock; from scripts.Portfolio import Portfolio; print('✅ Imports work!')"
```

If you get an error, Python itself has issues.

### 5. Check File Permissions

Sometimes Windows blocks files:

1. Right-click `scripts/Game_manager.py`
2. Properties → General tab
3. If you see "This file came from another computer...", click "Unblock"
4. Do the same for Stock.py and Portfolio.py

### 6. Godot Version Check

Make sure you're using **Godot 4.x** (not 3.x):
- Top menu bar should say "Godot Engine v4.x.x"
- Py4godot doesn't work with Godot 3.x

### 7. Still Not Working?

Create a minimal test scene:

**test_scene.tscn:**
1. New Scene → Node2D
2. Save as "test_scene.tscn"
3. Don't attach any script
4. Press F6 (run current scene)

If even this doesn't work, Godot itself is broken.

---

## What to Send Me:

If nothing works, copy and paste:

1. **The FIRST error message** from Godot Output tab (the red text)
2. **Godot version** (Help → About, copy version number)
3. **Result of this command:**
```powershell
python --version
python -c "import sys; print(sys.executable)"
```

I'll help you debug it! 🐛🔧
