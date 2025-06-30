//
//  ListItem.swift
//
//
//  Created by Gustavo Adolfo Villada Molina on 29/06/25.
//

import SwiftUI

public struct ListItem: View {
    private let imageUrl: String
    private let title: String
    private let subtitle: String
    private let isPlaying: Bool
    private let isFocused: Bool
    private let action: () -> Void
    private let imageSize: CGFloat = 60

    public init(
        imageUrl: String,
        title: String,
        subtitle: String,
        isPlaying: Bool = false,
        isFocused: Bool = false,
        action: @escaping () -> Void
    ) {
        self.imageUrl = imageUrl
        self.title = title
        self.subtitle = subtitle
        self.isPlaying = isPlaying
        self.isFocused = isFocused
        self.action = action
    }

    public var body: some View {
        HStack(spacing: 15) {
            ZStack {
                AsyncImage(url: URL(string: imageUrl)) { phase in
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
                .cornerRadius(10)
                .clipped()

                if isPlaying {
                    Color.black.opacity(0.3)
                        .cornerRadius(10)

                    MusicBarsView()
                }

                if isFocused {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 3)
                        .frame(width: imageSize, height: imageSize)
                }
            }
            .frame(width: imageSize, height: imageSize)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.title3)
                    .lineLimit(1)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            Spacer()
        }
        .onTapGesture {
            action()
        }
    }
}

#Preview {
    ListItem(
        imageUrl: "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcRqVynzweYGqPI0Hp959-UioSArS71yRkciXETh_juzHFAkOk5shXJ5tp9u-N9Rr4TD-fCydwUijtV5oDbaUcnjCYhx-UXIDwovoO0fNA",
        title: "Teclado",
        subtitle: "Hola",
        isPlaying: true,
        isFocused: true,
        action: {}
    )
}
