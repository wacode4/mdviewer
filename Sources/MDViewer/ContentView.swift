import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var markdown = ""
    @State private var html = ""
    @State private var headings: [HeadingItem] = []
    @State private var fileName = ""
    @State private var fileURL: URL?
    @State private var scrollToID: String?
    @State private var columnVisibility: NavigationSplitViewVisibility = .detailOnly

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            Group {
                if headings.isEmpty {
                    Text("No headings")
                        .foregroundStyle(.tertiary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    TOCSidebar(headings: headings) { id in
                        scrollToID = id
                    }
                }
            }
            .navigationSplitViewColumnWidth(min: 160, ideal: 220, max: 300)
        } detail: {
            if markdown.isEmpty {
                WelcomeView(onOpen: openDocument)
            } else {
                MarkdownWebView(
                    html: html,
                    baseURL: fileURL?.deletingLastPathComponent(),
                    scrollToID: $scrollToID
                )
            }
        }
        .navigationTitle(fileName.isEmpty ? "MDViewer" : fileName)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: toggleTOC) {
                    Image(systemName: "list.bullet.indent")
                }
                .help("Toggle Table of Contents (T)")
                .disabled(headings.isEmpty)
                .keyboardShortcut("t", modifiers: [.command])
            }
        }
        .onDrop(of: [.fileURL], isTargeted: nil, perform: handleDrop)
        .onReceive(NotificationCenter.default.publisher(for: .openDocument)) { _ in
            openDocument()
        }
        .onReceive(NotificationCenter.default.publisher(for: .openFile)) { notification in
            if let url = notification.object as? URL {
                loadFile(url)
            }
        }
        .onAppear(perform: checkLaunchArguments)
    }

    private func toggleTOC() {
        withAnimation {
            columnVisibility = columnVisibility == .all ? .detailOnly : .all
        }
    }

    private func openDocument() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [
            UTType(filenameExtension: "md") ?? .plainText,
            UTType(filenameExtension: "markdown") ?? .plainText,
            .plainText,
        ]
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.message = "Select a Markdown file"

        if panel.runModal() == .OK, let url = panel.url {
            loadFile(url)
        }
    }

    private func loadFile(_ url: URL) {
        _ = url.startAccessingSecurityScopedResource()
        defer { url.stopAccessingSecurityScopedResource() }

        guard let content = try? String(contentsOf: url, encoding: .utf8) else { return }

        markdown = content
        fileName = url.lastPathComponent
        fileURL = url

        let result = HTMLRenderer.render(markdown: content)
        html = result.html
        headings = result.headings

        if !headings.isEmpty {
            withAnimation { columnVisibility = .all }
        }
    }

    private func handleDrop(_ providers: [NSItemProvider]) -> Bool {
        guard let provider = providers.first else { return false }
        provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { item, _ in
            guard let data = item as? Data,
                  let url = URL(dataRepresentation: data, relativeTo: nil)
            else { return }
            DispatchQueue.main.async { loadFile(url) }
        }
        return true
    }

    private func checkLaunchArguments() {
        let args = CommandLine.arguments
        if args.count > 1 {
            let path = args[1]
            let url = URL(fileURLWithPath: path)
            if FileManager.default.fileExists(atPath: url.path) {
                loadFile(url)
            }
        }
    }
}

// MARK: - Welcome View

struct WelcomeView: View {
    let onOpen: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.richtext")
                .font(.system(size: 56, weight: .thin))
                .foregroundStyle(.tertiary)

            Text("Open a Markdown File")
                .font(.title2)
                .foregroundStyle(.secondary)

            Text("Press \u{2318}O or drag a file here")
                .font(.callout)
                .foregroundStyle(.tertiary)

            Button("Open File...") { onOpen() }
                .buttonStyle(.bordered)
                .controlSize(.large)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
