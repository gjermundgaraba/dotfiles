# Layout Reference

OpenTUI uses Yoga (flexbox) for layout. All container renderables support these properties.

## Flex Container

```typescript
{
  flexDirection: "row" | "column",
  justifyContent: "flex-start" | "center" | "flex-end" | "space-between" | "space-around",
  alignItems: "flex-start" | "center" | "flex-end" | "stretch",
  flexWrap: "nowrap" | "wrap",
}
```

## Flex Item

```typescript
{
  flexGrow: 1,      // Grow to fill available space
  flexShrink: 1,    // Shrink when space is limited
  flexBasis: 100,   // Base size before grow/shrink
}
```

## Sizing

```typescript
{
  width: 30,        // Fixed character width
  width: "100%",    // Percentage of parent
  width: "auto",    // Auto-size to content
  minWidth: 10,
  maxWidth: 50,
  height: 10,
  minHeight: 5,
  maxHeight: 20,
}
```

## Positioning

```typescript
{
  position: "relative",  // Default, participates in flex flow
  position: "absolute",  // Removed from flow, uses offsets
  left: 10,
  top: 5,
  right: 0,
  bottom: 0,
  zIndex: 100,  // Layer ordering for overlapping elements
}
```

## Spacing

```typescript
{
  // Padding (inside border)
  padding: 1,           // All sides
  paddingLeft: 2,
  paddingRight: 2,
  paddingTop: 1,
  paddingBottom: 1,
  
  // Margin (outside border)
  margin: 1,
  marginLeft: 2,
  marginRight: 2,
  marginTop: 1,
  marginBottom: 1,
}
```

## Common Layout Patterns

### Centered Content

```typescript
{
  justifyContent: "center",
  alignItems: "center",
}
```

### Sidebar + Main

```typescript
// Parent
{ flexDirection: "row" }

// Sidebar
{ width: 30 }

// Main
{ flexGrow: 1 }
```

### Header + Content + Footer

```typescript
// Parent
{ flexDirection: "column", height: "100%" }

// Header
{ height: 3 }

// Content
{ flexGrow: 1 }

// Footer
{ height: 1 }
```

### Absolute Overlay (Modal)

```typescript
{
  position: "absolute",
  left: 10,
  top: 5,
  zIndex: 1000,
}
```
