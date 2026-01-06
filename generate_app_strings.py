import json
import re
import os

def to_camel_case(s):
    # Split by any non-alphanumeric character (including space, dot, underscore, hyphen)
    parts = re.split(r'[^a-zA-Z0-9]', s)
    parts = [p for p in parts if p]
    if not parts:
        return "unknown"
    
    # CamelCase: first lower, rest Title
    res = parts[0].lower() + "".join(p.title() for p in parts[1:])
    
    # Ensure it starts with a letter (or prefix k if digit)
    if res[0].isdigit():
        res = 'k' + res
    
    # Reserved words check
    reserved = {'class', 'case', 'switch', 'default', 'break', 'continue', 'if', 'else', 'for', 'while', 'do', 'return', 'true', 'false', 'null', 'this', 'super', 'extends', 'implements', 'with', 'new', 'is', 'in', 'var', 'final', 'const', 'static', 'void', 'int', 'double', 'String', 'bool', 'List', 'Map', 'dynamic', 'get', 'set', 'import', 'export', 'library', 'part', 'of', 'show', 'hide', 'as', 'on', 'typedef', 'function', 'try', 'catch', 'finally', 'throw', 'rethrow', 'async', 'await', 'yield', 'interface', 'abstract', 'mixin', 'enum', 'assert'}
    if res in reserved:
        res = res + 'Val'
        
    return res

input_file = 'assets/locales/i18n_en.json'
output_file = 'lib/core/utils/appstring/app_string.dart'

# Verify input file exists
if not os.path.exists(input_file):
    print(f"Error: {input_file} not found")
    exit(1)

try:
    with open(input_file, 'r', encoding='utf-8') as f:
        data = json.load(f)
except Exception as e:
    print(f"Error parsing JSON: {e}")
    exit(1)

lines = []
lines.append("class AppString {")
lines.append("  AppString._();")

seen_vars = set()

# Sort keys to be deterministic and maybe grouped
sorted_keys = sorted(data.keys())

for key in sorted_keys:
    if not key.strip() or key.startswith('_comment'): continue
    
    var_name = to_camel_case(key)
    
    # Handle duplicates if any (shouldn't be with unique keys, but mapping might collide)
    # e.g. "foo.bar" and "foo_bar" -> "fooBar"
    original_var_name = var_name
    counter = 2
    while var_name in seen_vars:
        var_name = f"{original_var_name}{counter}"
        counter += 1
        
    seen_vars.add(var_name)
    
    escaped_key = key.replace("'", "\\'").replace("$", "\\$")
    lines.append(f"  static const String {var_name} = '{escaped_key}';")

lines.append("}")
lines.append("") # Final newline

with open(output_file, 'w', encoding='utf-8') as f:
    f.write("\n".join(lines))

print(f"Detailed: Generated {len(seen_vars)} keys in {output_file}")
