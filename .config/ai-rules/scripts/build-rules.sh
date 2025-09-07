#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
RULES_DIR="$PROJECT_DIR/rules"
BUILD_DIR="$PROJECT_DIR/build"
TEMPLATES_DIR="$RULES_DIR/templates"

# Function to extract YAML frontmatter value
extract_yaml_value() {
    local file="$1"
    local key="$2"
    local default="$3"
    
    # Extract frontmatter (between --- markers) and parse with yq
    local value=$(sed -n '/^---$/,/^---$/{ /^---$/d; p; }' "$file" | yq eval -r ".${key}" - 2>/dev/null)
    if [ -z "$value" ] || [ "$value" = "null" ]; then
        echo "$default"
    else
        echo "$value"
    fi
}

# Function to build rules for a specific platform
build_platform_rules() {
    local platform="$1"
    local output_dir="$BUILD_DIR/$platform"
    
    echo "Building $platform rules..."
    mkdir -p "$output_dir"
    
    # Process each rule file
    for rule_file in "$RULES_DIR"/*.md; do
        [ -f "$rule_file" ] || continue
        
        local basename=$(basename "$rule_file" .md)
        local rule_type=$(extract_yaml_value "$rule_file" "type" "unknown")
        
        case "$platform" in
            cursor)
                local template="$TEMPLATES_DIR/cursor.mdc.t"
                local output_file="$output_dir/${basename}.mdc"
                local description=$(extract_yaml_value "$rule_file" "description" "")
                local always_apply="true"
                
                if [ "$rule_type" = "on-demand" ]; then
                    always_apply="false"
                fi
                
                # Create a temporary file with just the body content (skip YAML frontmatter)
                local temp_body=$(mktemp)
                awk '/^---$/{c++} c==2{if(!printed){getline; printed=1} print}' "$rule_file" > "$temp_body"
                
                DESCRIPTION="$description" ALWAYS_APPLY="$always_apply" \
                    gomplate --file="$template" --out="$output_file" --template body="$temp_body"
                rm "$temp_body"
                ;;
                
            windsurf)
                local template="$TEMPLATES_DIR/windsurf.mdc.t"
                local output_file="$output_dir/${basename}.mdc"
                local description=$(extract_yaml_value "$rule_file" "description" "")
                local trigger="manual"
                
                if [ "$rule_type" = "always-on" ]; then
                    trigger="always_on"
                fi
                
                # Create a temporary file with just the body content (skip YAML frontmatter)
                local temp_body=$(mktemp)
                awk '/^---$/{c++} c==2{if(!printed){getline; printed=1} print}' "$rule_file" > "$temp_body"
                
                DESCRIPTION="$description" TRIGGER="$trigger" \
                    gomplate --file="$template" --out="$output_file" --template body="$temp_body"
                rm "$temp_body"
                ;;
                
            qoder)
                local template="$TEMPLATES_DIR/qoder.mdc.t"
                local output_file="$output_dir/${basename}.mdc"
                local description=$(extract_yaml_value "$rule_file" "description" "")
                local trigger="manual"
                local always_apply=""

                if [ "$rule_type" = "always-on" ]; then
                    trigger="always_on"
                    always_apply="true"
                else
                    # on-demand rules
                    if [ -z "$description" ]; then
                        trigger="manual"
                        always_apply="false"
                    else
                        trigger="model_decision"
                        always_apply=""
                    fi
                fi

                # Create a temporary file with just the body content (skip YAML frontmatter)
                local temp_body=$(mktemp)
                awk '/^---$/{c++} c==2{if(!printed){getline; printed=1} print}' "$rule_file" > "$temp_body"
                
                DESCRIPTION="$description" TRIGGER="$trigger" ALWAYS_APPLY="$always_apply" \
                    gomplate --file="$template" --out="$output_file" --template body="$temp_body"
                rm "$temp_body"
                ;;

            claude)
                local template="$TEMPLATES_DIR/claude.md.t"
                local output_file="$output_dir/claude.md"
                
                # For Claude, only build always-on rules
                if [ "$rule_type" = "always-on" ]; then
                    # Create a temporary file with just the body content (skip YAML frontmatter)
                    local temp_body=$(mktemp)
                    awk '/^---$/{if(++c==2){while((getline)>0)print}} END{if(c<2){print "No content found after frontmatter"}}' "$rule_file" > "$temp_body"
                    
                    gomplate --file="$template" --out="$output_file" --template body="$temp_body"
                    rm "$temp_body"
                fi
                ;;
        esac
    done
}

# Main script: always build all platforms
build_platform_rules "cursor"
build_platform_rules "windsurf"
build_platform_rules "qoder"
build_platform_rules "claude"

echo "Build complete!"