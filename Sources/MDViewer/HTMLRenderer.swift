import Foundation
import Markdown

struct RenderResult {
    let html: String
    let headings: [HeadingItem]
}

enum HTMLRenderer {
    static func render(markdown source: String) -> RenderResult {
        let document = Document(parsing: source)

        // Extract headings for TOC
        var extractor = HeadingExtractor()
        extractor.visit(document)

        // Convert to HTML
        var visitor = HTMLVisitor()
        let body = visitor.visit(document)

        let fullHTML = wrapHTML(body)
        return RenderResult(html: fullHTML, headings: extractor.headings)
    }

    private static func wrapHTML(_ body: String) -> String {
        """
        <!DOCTYPE html>
        <html>
        <head>
        <meta charset="utf-8">
        <meta name="color-scheme" content="light dark">
        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/github.min.css"
              media="(prefers-color-scheme: light)">
        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/github-dark.min.css"
              media="(prefers-color-scheme: dark)">
        <style>
        \(css)
        </style>
        </head>
        <body>
        <article>
        \(body)
        </article>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"></script>
        <script>hljs.highlightAll();</script>
        </body>
        </html>
        """
    }

    private static let css = """
    :root {
        color-scheme: light dark;
        --text: #1d1d1f;
        --bg: #ffffff;
        --secondary: #86868b;
        --code-bg: #f5f5f7;
        --code-border: #e8e8ed;
        --border: #d2d2d7;
        --link: #0066cc;
        --blockquote-border: #d2d2d7;
        --blockquote-text: #6e6e73;
        --table-stripe: #f5f5f7;
        --table-border: #d2d2d7;
        --kbd-bg: #f5f5f7;
        --kbd-border: #c8c8cc;
    }

    @media (prefers-color-scheme: dark) {
        :root {
            --text: #f5f5f7;
            --bg: #1d1d1f;
            --secondary: #a1a1a6;
            --code-bg: #2c2c2e;
            --code-border: #3a3a3c;
            --border: #48484a;
            --link: #2997ff;
            --blockquote-border: #48484a;
            --blockquote-text: #a1a1a6;
            --table-stripe: #2c2c2e;
            --table-border: #48484a;
            --kbd-bg: #2c2c2e;
            --kbd-border: #48484a;
        }
    }

    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        font-family: -apple-system, BlinkMacSystemFont, "SF Pro Text", "Helvetica Neue", sans-serif;
        font-size: 16px;
        line-height: 1.75;
        color: var(--text);
        background: var(--bg);
        -webkit-font-smoothing: antialiased;
        -moz-osx-font-smoothing: grayscale;
    }

    article {
        max-width: 720px;
        margin: 0 auto;
        padding: 48px 32px 96px;
    }

    /* Headings */
    h1, h2, h3, h4, h5, h6 {
        font-family: -apple-system, BlinkMacSystemFont, "SF Pro Display", sans-serif;
        font-weight: 600;
        line-height: 1.3;
        margin-top: 2em;
        margin-bottom: 0.5em;
        scroll-margin-top: 24px;
    }

    h1 {
        font-size: 2em;
        font-weight: 700;
        letter-spacing: -0.025em;
        margin-top: 0;
        padding-bottom: 0.3em;
        border-bottom: 1px solid var(--border);
    }

    h2 {
        font-size: 1.5em;
        letter-spacing: -0.015em;
        padding-bottom: 0.25em;
        border-bottom: 1px solid var(--border);
    }

    h3 { font-size: 1.25em; }
    h4 { font-size: 1.1em; }
    h5 { font-size: 1em; }
    h6 { font-size: 0.9em; color: var(--secondary); }

    /* Paragraphs & inline */
    p {
        margin-bottom: 1em;
    }

    a {
        color: var(--link);
        text-decoration: none;
    }
    a:hover {
        text-decoration: underline;
    }

    strong { font-weight: 600; }

    /* Code */
    code {
        font-family: "SF Mono", SFMono-Regular, Menlo, Consolas, monospace;
        font-size: 0.875em;
        background: var(--code-bg);
        border: 1px solid var(--code-border);
        border-radius: 4px;
        padding: 0.15em 0.35em;
    }

    pre {
        margin-bottom: 1em;
        border-radius: 8px;
        overflow-x: auto;
        background: var(--code-bg) !important;
        border: 1px solid var(--code-border);
    }

    pre code {
        display: block;
        padding: 16px 20px;
        border: none;
        border-radius: 0;
        font-size: 0.85em;
        line-height: 1.6;
        background: transparent !important;
    }

    /* Blockquote */
    blockquote {
        margin: 0 0 1em;
        padding: 0.5em 1em;
        border-left: 3px solid var(--blockquote-border);
        color: var(--blockquote-text);
    }

    blockquote p:last-child {
        margin-bottom: 0;
    }

    /* Lists */
    ul, ol {
        margin-bottom: 1em;
        padding-left: 1.75em;
    }

    li {
        margin-bottom: 0.25em;
    }

    li > ul, li > ol {
        margin-top: 0.25em;
        margin-bottom: 0;
    }

    /* Task lists */
    input[type="checkbox"] {
        margin-right: 0.5em;
        transform: scale(1.1);
    }

    /* Horizontal rule */
    hr {
        border: none;
        height: 1px;
        background: var(--border);
        margin: 2em 0;
    }

    /* Images */
    img {
        max-width: 100%;
        height: auto;
        border-radius: 8px;
        margin: 1em 0;
    }

    /* Tables */
    table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 1em;
        font-size: 0.925em;
    }

    th, td {
        padding: 8px 12px;
        text-align: left;
        border: 1px solid var(--table-border);
    }

    th {
        font-weight: 600;
        background: var(--table-stripe);
    }

    tbody tr:nth-child(even) {
        background: var(--table-stripe);
    }

    /* Keyboard shortcut styling */
    kbd {
        font-family: "SF Mono", SFMono-Regular, Menlo, monospace;
        font-size: 0.85em;
        background: var(--kbd-bg);
        border: 1px solid var(--kbd-border);
        border-radius: 4px;
        padding: 0.1em 0.4em;
        box-shadow: 0 1px 0 var(--kbd-border);
    }

    /* Selection */
    ::selection {
        background: rgba(0, 102, 204, 0.25);
    }

    @media (prefers-color-scheme: dark) {
        ::selection {
            background: rgba(41, 151, 255, 0.3);
        }
    }
    """
}

// MARK: - Heading Extractor

private struct HeadingExtractor: MarkupWalker {
    var headings: [HeadingItem] = []
    private var headingCounts: [String: Int] = [:]

    mutating func visitHeading(_ heading: Heading) {
        let text = collectText(heading)
        var id = text.lowercased()
            .replacingOccurrences(of: " ", with: "-")
            .replacingOccurrences(of: "[^a-z0-9\\-]", with: "", options: .regularExpression)

        // Handle duplicate heading IDs
        let count = headingCounts[id, default: 0]
        headingCounts[id] = count + 1
        if count > 0 { id += "-\(count)" }

        headings.append(HeadingItem(id: id, title: text, level: heading.level))
        descendInto(heading)
    }
}

// MARK: - HTML Visitor

private struct HTMLVisitor: MarkupVisitor {
    typealias Result = String

    private var isInTableHeader = false
    private var headingCounts: [String: Int] = [:]

    mutating func defaultVisit(_ markup: any Markup) -> String {
        markup.children.map { visit($0) }.joined()
    }

    mutating func visitDocument(_ document: Document) -> String {
        document.children.map { visit($0) }.joined()
    }

    // MARK: Block elements

    mutating func visitHeading(_ heading: Heading) -> String {
        let text = collectText(heading)
        var id = text.lowercased()
            .replacingOccurrences(of: " ", with: "-")
            .replacingOccurrences(of: "[^a-z0-9\\-]", with: "", options: .regularExpression)

        let count = headingCounts[id, default: 0]
        headingCounts[id] = count + 1
        if count > 0 { id += "-\(count)" }

        let content = heading.children.map { visit($0) }.joined()
        return "<h\(heading.level) id=\"\(id)\">\(content)</h\(heading.level)>\n"
    }

    mutating func visitParagraph(_ paragraph: Paragraph) -> String {
        "<p>\(paragraph.children.map { visit($0) }.joined())</p>\n"
    }

    mutating func visitBlockQuote(_ blockQuote: BlockQuote) -> String {
        "<blockquote>\n\(blockQuote.children.map { visit($0) }.joined())</blockquote>\n"
    }

    mutating func visitCodeBlock(_ codeBlock: CodeBlock) -> String {
        let lang = codeBlock.language ?? ""
        let langAttr = lang.isEmpty ? "" : " class=\"language-\(escapeAttr(lang))\""
        return "<pre><code\(langAttr)>\(escapeHTML(codeBlock.code))</code></pre>\n"
    }

    mutating func visitThematicBreak(_ thematicBreak: ThematicBreak) -> String {
        "<hr>\n"
    }

    mutating func visitHTMLBlock(_ html: HTMLBlock) -> String {
        html.rawHTML
    }

    // MARK: Lists

    mutating func visitOrderedList(_ orderedList: OrderedList) -> String {
        let start = orderedList.startIndex
        let startAttr = start != 1 ? " start=\"\(start)\"" : ""
        return "<ol\(startAttr)>\n\(orderedList.children.map { visit($0) }.joined())</ol>\n"
    }

    mutating func visitUnorderedList(_ unorderedList: UnorderedList) -> String {
        "<ul>\n\(unorderedList.children.map { visit($0) }.joined())</ul>\n"
    }

    mutating func visitListItem(_ listItem: ListItem) -> String {
        let checkbox: String
        if let cb = listItem.checkbox {
            let checked = cb == .checked ? " checked" : ""
            checkbox = "<input type=\"checkbox\"\(checked) disabled> "
        } else {
            checkbox = ""
        }
        return "<li>\(checkbox)\(listItem.children.map { visit($0) }.joined())</li>\n"
    }

    // MARK: Tables

    mutating func visitTable(_ table: Table) -> String {
        "<table>\n\(table.children.map { visit($0) }.joined())</table>\n"
    }

    mutating func visitTableHead(_ tableHead: Table.Head) -> String {
        isInTableHeader = true
        let content = tableHead.children.map { visit($0) }.joined()
        isInTableHeader = false
        return "<thead>\n\(content)</thead>\n"
    }

    mutating func visitTableBody(_ tableBody: Table.Body) -> String {
        "<tbody>\n\(tableBody.children.map { visit($0) }.joined())</tbody>\n"
    }

    mutating func visitTableRow(_ tableRow: Table.Row) -> String {
        "<tr>\(tableRow.children.map { visit($0) }.joined())</tr>\n"
    }

    mutating func visitTableCell(_ tableCell: Table.Cell) -> String {
        let tag = isInTableHeader ? "th" : "td"
        return "<\(tag)>\(tableCell.children.map { visit($0) }.joined())</\(tag)>"
    }

    // MARK: Inline elements

    mutating func visitText(_ text: Text) -> String {
        escapeHTML(text.string)
    }

    mutating func visitStrong(_ strong: Strong) -> String {
        "<strong>\(strong.children.map { visit($0) }.joined())</strong>"
    }

    mutating func visitEmphasis(_ emphasis: Emphasis) -> String {
        "<em>\(emphasis.children.map { visit($0) }.joined())</em>"
    }

    mutating func visitInlineCode(_ inlineCode: InlineCode) -> String {
        "<code>\(escapeHTML(inlineCode.code))</code>"
    }

    mutating func visitLink(_ link: Link) -> String {
        let href = link.destination ?? ""
        let content = link.children.map { visit($0) }.joined()
        return "<a href=\"\(escapeAttr(href))\">\(content)</a>"
    }

    mutating func visitImage(_ image: Image) -> String {
        let src = image.source ?? ""
        let alt = collectText(image)
        return "<img src=\"\(escapeAttr(src))\" alt=\"\(escapeAttr(alt))\" loading=\"lazy\">"
    }

    mutating func visitStrikethrough(_ strikethrough: Strikethrough) -> String {
        "<del>\(strikethrough.children.map { visit($0) }.joined())</del>"
    }

    mutating func visitInlineHTML(_ html: InlineHTML) -> String {
        html.rawHTML
    }

    mutating func visitSoftBreak(_ softBreak: SoftBreak) -> String {
        "\n"
    }

    mutating func visitLineBreak(_ lineBreak: LineBreak) -> String {
        "<br>\n"
    }

    // MARK: Helpers

    private func escapeHTML(_ string: String) -> String {
        string
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
    }

    private func escapeAttr(_ string: String) -> String {
        escapeHTML(string)
    }
}

// MARK: - Shared Helpers

private func collectText(_ markup: any Markup) -> String {
    if let text = markup as? Text {
        return text.string
    }
    return markup.children.map { collectText($0) }.joined()
}
