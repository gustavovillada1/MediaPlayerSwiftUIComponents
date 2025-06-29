//
//  SwiftUIView.swift
//  
//
//  Created by Gustavo Adolfo Villada Molina on 25/06/25.
//
import SwiftUI

/// Represents the available visual styles for `ListHorizontalItem`.
///
/// - `large`: Displays a large image with title and subtitle below.
/// - `medium`: Medium-sized image with smaller text.
/// - `compact`: Small image and minimal text, subtitle omitted.
public enum ListItemStyle {
    case large
    case medium
    case compact
}

/// A reusable horizontal list item view, ideal for representing songs, albums, artists or playlists.
///
/// This component is designed to be placed inside a horizontal `ScrollView`.
/// It supports different styles (`large`, `medium`, `compact`) and is fully interactive via a tap action.
///
/// The item displays a remote image (`imageURL`), a title and optionally a subtitle, adapting its layout according to the provided style.
public struct ListHorizontalItem: View {
    let imageURL: String?
    let title: String
    let subtitle: String?
    let style: ListItemStyle
    let action: () -> Void
    let isPlaying: Bool
    let isFocused: Bool

    public init(
        imageURL: String?,
        title: String,
        subtitle: String? = nil,
        style: ListItemStyle,
        isPlaying: Bool = false,
        isFocused: Bool = false,
        action: @escaping () -> Void
    ) {
        self.imageURL = imageURL
        self.title = title
        self.subtitle = subtitle
        self.style = style
        self.action = action
        self.isPlaying = isPlaying
        self.isFocused = isFocused
    }


    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                AsyncImage(url: URL(string: imageURL ?? "")) { phase in
                    switch phase {
                    case .empty:
                        Color.gray.opacity(0.2)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Color.red.opacity(0.3)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: imageSize, height: imageSize)
                .cornerRadius(cornerRadius)
                .clipped()

                if isPlaying {
                    Color.black.opacity(0.3)
                    MusicBarsView()
                }
                
                if isFocused {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.white, lineWidth: 3)
                        .frame(width: imageSize, height: imageSize)
                        .animation(.easeInOut, value: isPlaying)
                }
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(titleFont)
                    .lineLimit(1)
                    .preferredColorScheme(.dark)
                if let subtitle = subtitle, style != .compact {
                    Text(subtitle)
                        .font(subtitleFont)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .preferredColorScheme(.dark)
                }
            }
            .frame(width: imageSize, alignment: .leading)
        }
        .onTapGesture {
            action()
        }
    }

    private var imageSize: CGFloat {
        switch style {
        case .large: return 140
        case .medium: return 100
        case .compact: return 70
        }
    }

    private var cornerRadius: CGFloat {
        style == .compact ? 8 : 12
    }

    private var titleFont: Font {
        switch style {
        case .large: return .headline
        case .medium: return .subheadline
        case .compact: return .caption
        }
    }

    private var subtitleFont: Font {
        switch style {
        case .large: return .subheadline
        case .medium: return .caption
        case .compact: return .caption2
        }
    }
}

#Preview {
    ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 16) {
            ForEach(0..<5) { i in
                ListHorizontalItem(
                    imageURL: "https://e-cdns-images.dzcdn.net/images/artist/abc123456789/264x264-000000-80-0-0.jpg",
                    title: "Artist \(i + 1)",
                    subtitle: "Pop",
                    style: (i % 3 == 0 ? .large : i % 3 == 1 ? .medium : .compact),
                    isPlaying: true,
                    isFocused: true,
                    action: {}
                )
            }
        }
        .padding()
    }
}
