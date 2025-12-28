# Input & Focus Reference

## Keyboard Input

```typescript
import { type KeyEvent } from "@opentui/core"

renderer.keyInput.on("keypress", (key: KeyEvent) => {
  console.log("Key:", key.name)      // "a", "enter", "escape", "up", "f1"
  console.log("Ctrl:", key.ctrl)     // boolean
  console.log("Shift:", key.shift)   // boolean
  console.log("Alt:", key.meta)      // boolean
  console.log("Sequence:", key.sequence)  // Raw escape sequence

  if (key.ctrl && key.name === "c") process.exit()
  if (key.name === "escape") modal.visible = false
})

renderer.keyInput.on("paste", (text: string) => {
  console.log("Pasted:", text)
})
```

**KeyEvent properties:**
- `name`: Key identifier ("a", "enter", "escape", "up", "down", "f1", etc.)
- `ctrl`, `shift`, `meta`: Modifier states
- `sequence`: Raw terminal escape sequence

---

## Focus Management

```typescript
import { RenderableEvents } from "@opentui/core"

// Focus/blur
input.focus()
input.blur()

// Check focus state
if (input.focused) { ... }

// Focus events
input.on(RenderableEvents.FOCUSED, () => console.log("Focused"))
input.on(RenderableEvents.BLURRED, () => console.log("Blurred"))
```

Only one element can be focused at a time. Focusing one element automatically blurs the previous.

---

## Colors (RGBA)

```typescript
import { RGBA, parseColor } from "@opentui/core"

// Create RGBA
const red = RGBA.fromInts(255, 0, 0, 255)        // 0-255 integers
const blue = RGBA.fromValues(0.0, 0.0, 1.0, 1.0) // 0.0-1.0 floats
const green = RGBA.fromHex("#00FF00")            // Hex string
const transparent = RGBA.fromValues(1, 1, 1, 0.5)// Semi-transparent

// Props accept strings or RGBA
{
  fg: "#FF0000",
  bg: RGBA.fromHex("#0000FF"),
  backgroundColor: "transparent",
}
```

---

## Lifecycle

```typescript
// Add/remove from tree
renderer.root.add(element)
renderer.root.remove(element.id)

// Find elements
const found = container.getRenderable("child-id")

// Destroy (cleanup resources)
element.destroy()

// Renderer events
renderer.on("resize", (width, height) => {
  console.log(`Terminal: ${width}x${height}`)
})

// Graceful shutdown
renderer.exit()
```

---

## Console Overlay

Built-in debug console captures console.log output.

```typescript
import { ConsolePosition } from "@opentui/core"

const renderer = await createCliRenderer({
  consoleOptions: {
    position: ConsolePosition.BOTTOM,
    sizePercent: 30,
    colorInfo: "#00FFFF",
    colorWarn: "#FFFF00",
    colorError: "#FF0000",
    startInDebugMode: false,
  },
})

console.log("Appears in overlay")
renderer.console.toggle()  // Toggle visibility (backtick key by default)
```

---

## Environment Variables

| Variable | Description |
|----------|-------------|
| `OTUI_USE_CONSOLE` | Enable console overlay (default: true) |
| `SHOW_CONSOLE` | Show console at startup |
| `OTUI_NO_NATIVE_RENDER` | Disable native rendering (debug) |
| `OTUI_USE_ALTERNATE_SCREEN` | Use alternate screen buffer |
