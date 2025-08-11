xir IEx Cheat Sheet — Inspecting Modules & Functions
# ============================================================

# 1. Show documentation for a module:
h Map
h Poison.Parser

# 2. Show documentation for a specific function (with arity):
h Map.get/2
h Map.get/3
h Poison.Parser.parse!/1
h Poison.Parser.parse!/2

# 3. Inspect the typespecs and info about a function or value:
i Map.get
i %{"a" => 1}   # Shows type and protocols implemented

# 4. List all functions/macros for a module via tab-completion:
# Type the module name + dot and press Tab:
# Example: Map.<TAB>

# 5. Get the BEAM file path for a module (source location):
:code.which(Map)
:code.which(Poison.Parser)

# 6. Check all loaded modules:
:code.all_loaded()


# 7. Another way to get functions/macros

Map.__info__(:functions)
#=> [delete: 2, drop: 2, equal?: 2, fetch: 2, fetch!: 2, ... ]

Map.__info__(:macros)
#=> [new_macro_name: 1, ...]  # if the module has macros

# Notes:
# - `h` works for documentation stored in @doc/@moduledoc.
# - `i` works for both functions and values.
# - Always specify correct arity for functions with multiple versions.
# ============================================================
