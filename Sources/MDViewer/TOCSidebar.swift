import SwiftUI

struct HeadingItem: Identifiable, Equatable {
    let id: String
    let title: String
    let level: Int
}

struct TOCSidebar: View {
    let headings: [HeadingItem]
    let onSelect: (String) -> Void

    @State private var selected: String?

    var body: some View {
        List(headings, selection: $selected) { heading in
            Button(action: {
                selected = heading.id
                onSelect(heading.id)
            }) {
                Text(heading.title)
                    .font(fontForLevel(heading.level))
                    .foregroundStyle(heading.level == 1 ? .primary : .secondary)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .padding(.leading, indentation(for: heading.level))
        }
        .listStyle(.sidebar)
    }

    private func fontForLevel(_ level: Int) -> Font {
        switch level {
        case 1: return .headline
        case 2: return .subheadline
        default: return .caption
        }
    }

    private func indentation(for level: Int) -> CGFloat {
        CGFloat(max(0, level - 1)) * 14
    }
}
