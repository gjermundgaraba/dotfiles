# Renderables Reference

Complete API for all OpenTUI renderable components.

## TextRenderable

Display styled text content.

```typescript
import { TextRenderable, TextAttributes, t, bold, fg, underline } from "@opentui/core"

new TextRenderable(renderer, {
  id: "text",
  content: "Plain text",
  fg: "#FFFF00",
  bg: "#000000",
  attributes: TextAttributes.BOLD | TextAttributes.UNDERLINE,
})

// Styled text with template literal
new TextRenderable(renderer, {
  content: t`${bold("Important")} ${fg("#FF0000")(underline("Warning"))}`,
})
```

**Props:**
- `content`: string | StyledText
- `fg`: color string or RGBA
- `bg`: color string or RGBA
- `attributes`: TextAttributes flags (BOLD, UNDERLINE, etc.)

---

## BoxRenderable

Container with border, background, and title.

```typescript
new BoxRenderable(renderer, {
  id: "panel",
  width: 30,
  height: 10,
  backgroundColor: "#333366",
  borderStyle: "single",  // "single" | "double" | "rounded"
  borderColor: "#FFFFFF",
  title: "Panel Title",
  titleAlignment: "center",  // "left" | "center" | "right"
  padding: 1,
  // Flexbox layout
  flexDirection: "row",
  justifyContent: "center",
  alignItems: "center",
})

// Mutate properties
box.backgroundColor = "#444477"
box.width = 40
```

**Props:**
- `width`, `height`: number | percentage string
- `backgroundColor`, `borderColor`: color
- `borderStyle`: "single" | "double" | "rounded"
- `title`, `titleAlignment`: title bar configuration
- All flexbox layout props (see layout.md)

---

## InputRenderable

Text input field with cursor and events.

```typescript
import { InputRenderable, InputRenderableEvents } from "@opentui/core"

const input = new InputRenderable(renderer, {
  id: "name-input",
  width: 25,
  placeholder: "Enter name...",
  placeholderColor: "#666666",
  backgroundColor: "#1a1a1a",
  focusedBackgroundColor: "#2a2a2a",
  textColor: "#FFFFFF",
  cursorColor: "#FFFF00",
  maxLength: 50,
})

input.on(InputRenderableEvents.INPUT, (value) => console.log("Typing:", value))
input.on(InputRenderableEvents.CHANGE, (value) => console.log("Changed:", value))
input.on(InputRenderableEvents.ENTER, (value) => console.log("Submitted:", value))
input.focus()  // Must focus to receive input
```

**Events:**
- `INPUT`: Fires on every keystroke
- `CHANGE`: Fires when value changes (debounced)
- `ENTER`: Fires on Enter key

**Props:**
- `placeholder`, `placeholderColor`: placeholder text
- `backgroundColor`, `focusedBackgroundColor`: normal/focused states
- `textColor`, `cursorColor`: text styling
- `maxLength`: character limit

---

## SelectRenderable

Scrollable list selection with keyboard navigation.

```typescript
import { SelectRenderable, SelectRenderableEvents, type SelectOption } from "@opentui/core"

const select = new SelectRenderable(renderer, {
  id: "menu",
  width: 30,
  height: 8,
  options: [
    { name: "New File", description: "Create new file", value: "new" },
    { name: "Open File", description: "Open existing file", value: "open" },
    { name: "Save", description: "Save current file", value: "save" },
  ],
  showDescription: true,
  showScrollIndicator: true,
  wrapSelection: false,
  // Styling
  backgroundColor: "#1e293b",
  selectedBackgroundColor: "#3b82f6",
  textColor: "#e2e8f0",
  selectedTextColor: "#ffffff",
})

select.on(SelectRenderableEvents.SELECTION_CHANGED, (index, option) => {
  console.log("Highlighted:", option.name)
})
select.on(SelectRenderableEvents.ITEM_SELECTED, (index, option) => {
  console.log("Selected:", option.value)
})
select.focus()  // Navigate with up/down/j/k, select with enter
```

**Events:**
- `SELECTION_CHANGED`: Fires when highlight moves
- `ITEM_SELECTED`: Fires on Enter

**Navigation:** Arrow keys, j/k, Enter to select

---

## TabSelectRenderable

Horizontal tab selection.

```typescript
import { TabSelectRenderable, TabSelectRenderableEvents } from "@opentui/core"

const tabs = new TabSelectRenderable(renderer, {
  id: "tabs",
  width: 60,
  options: [
    { name: "Home", description: "Dashboard" },
    { name: "Files", description: "File management" },
    { name: "Settings", description: "Preferences" },
  ],
  tabWidth: 20,
})

tabs.on(TabSelectRenderableEvents.ITEM_SELECTED, (index, option) => {
  // Switch tab content
})
tabs.focus()  // Navigate with left/right/[/]
```

**Navigation:** Arrow keys left/right, `[` and `]`

---

## GroupRenderable

Invisible layout container (no visual styling).

```typescript
import { GroupRenderable } from "@opentui/core"

const row = new GroupRenderable(renderer, {
  id: "row",
  flexDirection: "row",
  justifyContent: "space-between",
  alignItems: "center",
  width: "100%",
})

row.add(leftPanel)
row.add(rightPanel)
```

Use for layout organization without borders/backgrounds.
