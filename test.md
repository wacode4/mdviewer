# MDViewer Test Document

Welcome to **MDViewer**, an extremely minimal Markdown reader for macOS.

## Features

- Native macOS look and feel
- Table of Contents sidebar
- Syntax highlighting for code blocks
- Light and dark mode support
- Drag and drop file opening

## Code Examples

### Swift

```swift
struct ContentView: View {
    @State private var count = 0

    var body: some View {
        VStack {
            Text("Count: \(count)")
            Button("Increment") { count += 1 }
        }
    }
}
```

### Python

```python
def fibonacci(n):
    """Generate the first n Fibonacci numbers."""
    a, b = 0, 1
    for _ in range(n):
        yield a
        a, b = b, a + b

for num in fibonacci(10):
    print(num)
```

### JavaScript

```javascript
const fetchData = async (url) => {
  const response = await fetch(url);
  if (!response.ok) throw new Error(`HTTP ${response.status}`);
  return response.json();
};
```

## Typography

This is a paragraph with **bold text**, _italic text_, and `inline code`. You can also use ~~strikethrough~~ text.

> This is a blockquote. It can contain **formatted text** and even
> multiple paragraphs if needed.

## Lists

### Ordered List

1. First item
2. Second item
3. Third item with a nested list:
   1. Sub-item A
   2. Sub-item B

### Task List

- [x] Design the app architecture
- [x] Implement Markdown rendering
- [x] Add syntax highlighting
- [ ] Add file watching for live reload
- [ ] Publish to App Store

## Tables

| Feature            | Status  | Priority |
| ------------------ | ------- | -------- |
| Markdown rendering | Done    | High     |
| TOC sidebar        | Done    | High     |
| Code highlighting  | Done    | Medium   |
| Dark mode          | Done    | Medium   |
| File watching      | Planned | Low      |

## Links and Images

Visit [Apple Developer](https://developer.apple.com) for more information.

---

_Built with SwiftUI and love._
