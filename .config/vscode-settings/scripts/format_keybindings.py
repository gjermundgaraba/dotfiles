#!/usr/bin/env python3

import json
import json5

def format_keybindings():
    # Read and parse the keybindings file
    with open('config/keybindings.json', 'r') as f:
        data = json5.load(f)
    
    # Separate enables and disables
    enables = [item for item in data if not item['command'].startswith('-')]
    disables = [item for item in data if item['command'].startswith('-')]
    
    # Sort both by key
    enables.sort(key=lambda x: x['key'])
    disables.sort(key=lambda x: x['key'])
    
    # Generate formatted output
    lines = []
    lines.append("// Place your key bindings in this file to override the defaults")
    lines.append("[")
    lines.append("    // Enables")
    
    # Format enables
    for i, item in enumerate(enables):
        item_json = json.dumps(item, indent=4)
        item_lines = item_json.split('\n')
        for j, line in enumerate(item_lines):
            lines.append("    " + line)
        lines[-1] += ","  # Add comma to last line of this item
    
    lines.append("    // Disables")
    
    # Format disables
    for i, item in enumerate(disables):
        item_json = json.dumps(item, indent=4)
        item_lines = item_json.split('\n')
        for j, line in enumerate(item_lines):
            lines.append("    " + line)
        if i < len(disables) - 1:
            lines[-1] += ","  # Add comma to last line of this item
    
    lines.append("]")
    
    # Write back to file
    with open('config/keybindings.json', 'w') as f:
        f.write('\n'.join(lines))

if __name__ == "__main__":
    format_keybindings()
    print("Keybindings formatted successfully!")