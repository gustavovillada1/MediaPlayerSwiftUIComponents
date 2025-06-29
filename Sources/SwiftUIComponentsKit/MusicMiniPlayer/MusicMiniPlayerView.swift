//
//  MusicMiniPlayerView.swift
//
//  Created by Gustavo Adolfo Villada Molina on 6/05/25.
//

import SwiftUI
import Combine

/// A customizable and animated mini music player view.
///
/// This view can be used in collapsed or expanded state. It shows the song's
/// title, artist, artwork, and controls to play/pause or skip songs.
///
/// The background uses a blur material with rounded corners and a subtle shadow.
///
/// Use `isExpanded` to control the current state (collapsed/expanded).
public struct MusicMiniPlayerView: View {
    private let constants: UIConstants = UIConstants()
    
    @Binding var isExpanded: Bool
    
    private let title: String
    private let subtitle: String
    private let image: Image?
    private let urlImage: String?
    private let onPlayPause: () -> Void
    private let onNextSong: () -> Void
    private let onPreviousSong: () -> Void
    private let isPlaying: Bool
    private var colorScheme: ColorScheme = .dark
    private var extraContent: AnyView?
    
    /// Initializes a new `MusicMiniPlayerView`.
    ///
    /// - Parameters:
    ///   - isExpanded: A binding that controls whether the player is expanded or collapsed.
    ///   - title: The title of the current song.
    ///   - artist: The artist of the current song.
    ///   - image: A local `Image` to display (optional). If provided, this will be used instead of `urlImage`.
    ///   - urlImage: A remote URL string pointing to the artwork image (optional).
    ///   - isPlaying: Boolean indicating if the music is currently playing.
    ///   - onPlayPause: Action to perform when the play/pause button is tapped.
    ///   - onNextSong: Action to perform when the next button is tapped.
    ///   - onPreviousSong: Action to perform when the previous button is tapped.
    public init(
        isExpanded: Binding<Bool>,
        title: String,
        artist: String,
        image: Image? = nil,
        urlImage: String? = nil,
        isPlaying: Bool,
        onPlayPause: @escaping () -> Void,
        onNextSong: @escaping () -> Void,
        onPreviousSong: @escaping () -> Void
    ) {
        self._isExpanded = isExpanded
        self.title = title
        self.subtitle = artist
        self.image = image
        self.urlImage = urlImage
        self.onPlayPause = onPlayPause
        self.onNextSong = onNextSong
        self.onPreviousSong = onPreviousSong
        self.isPlaying = isPlaying
    }
    
    public var body: some View {
        ZStack {
            if isExpanded {
                Color.black.opacity(0.4)
            }
            VStack(spacing: Double.zero) {
                if !isExpanded {
                    collapsedView
                } else {
                    expandedView
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.thinMaterial)
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
            .shadow(radius: 5)
            .padding(.horizontal)
            .animation(.easeInOut, value: isExpanded)
        }
    }
    
    private var collapsedView: some View {
        HStack {
            if let unwrappedImage: Image = image {
                unwrappedImage
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: constants.musicMiniPlayerCollapsedImageSize,
                        height: constants.musicMiniPlayerCollapsedImageSize
                    )
                    .cornerRadius(constants.musicMiniPlayerCollapsedImageCornerRadius)
            }
            if let urlString = urlImage, let imageURL = URL(string: urlString) {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        Icons.backwardFill.image
                            .resizable()
                            .scaledToFit()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                    case .failure:
                        Icons.pauseFill.image
                            .resizable()
                            .scaledToFit()
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(
                    width: constants.musicMiniPlayerCollapsedImageSize,
                    height: constants.musicMiniPlayerCollapsedImageSize
                )
                .cornerRadius(constants.musicMiniPlayerCollapsedImageCornerRadius)
            }
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .lineLimit(1)
                    .preferredColorScheme(colorScheme)
                Text(subtitle)
                    .font(.subheadline)
                    .lineLimit(1)
                    .preferredColorScheme(colorScheme)
            }
            Spacer()
            HStack(spacing: 15) {
                Button(action: onPreviousSong) {
                    Icons.backwardFill.image
                        .font(.title3)
                }
                .buttonStyle(.plain)
                
                Button(action: onPlayPause) {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.title)
                }
                .buttonStyle(.plain)
                
                Button(action: onNextSong) {
                    Icons.forwardFill.image
                        .font(.title3)
                }
                .buttonStyle(.plain)
                
            }
        }
        .padding()
        .onTapGesture {
            withAnimation {
                isExpanded = true
            }
        }
    }
    
    // MARK: Expanded View
    private var expandedView: some View {
        VStack(spacing: 16) {
            closeButtonView
            if let unwrappedExtraContent: AnyView = extraContent {
                ScrollView(showsIndicators: false) {
                    trackBasicInformationView
                    playerManagerButtonsView
                    unwrappedExtraContent
                }
            } else {
                trackBasicInformationView
                playerManagerButtonsView
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    // MARK: Close button
    private var closeButtonView: some View {
        HStack {
            Button {
                withAnimation {
                    isExpanded = false
                }
            } label: {
                Image(systemName: "chevron.down")
                    .font(.system(size: 20))
            }
            .buttonStyle(.plain)
            .padding(.top)
            
        }
    }
    
    // MARK: Track basic information
    private var trackBasicInformationView: some View {
        VStack {
            if let unwrappedImage: Image = image {
                unwrappedImage
                    .resizable()
                    .scaledToFit()
                    .frame(
                        height: 200
                    )
                    .cornerRadius(12)
            }
            if let urlString = urlImage, let imageURL = URL(string: urlString) {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        Icons.backwardFill.image
                            .resizable()
                            .aspectRatio(1, contentMode: .fill)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(1, contentMode: .fill)
                    case .failure:
                        Icons.pauseFill.image
                            .resizable()
                            .aspectRatio(1, contentMode: .fill)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 300, height: 300)
                .cornerRadius(12)
            }
            
            
            Text(title)
                .font(.title2)
                .bold()
                .lineLimit(1)
                .preferredColorScheme(colorScheme)
            
            Text(subtitle)
                .font(.title3)
                .foregroundColor(.secondary)
                .lineLimit(1)
                .preferredColorScheme(colorScheme)
        }
    }
    
    // MARK: Player manager buttons
    private var playerManagerButtonsView: some View {
        HStack(spacing: 40) {
            Button(action: onPreviousSong) {
                Icons.backwardFill.image
                    .font(.title)
            }
            .buttonStyle(.plain)
            
            Button(action: onPlayPause) {
                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 50))
            }
            .buttonStyle(.plain)
            
            Button(action: onNextSong) {
                Icons.forwardFill.image
                    .font(.title)
            }
            .buttonStyle(.plain)
            
        }
    }
    
    // MARK: Modifiers
    public func setColorScheme(_ colorScheme: ColorScheme) -> MusicMiniPlayerView {
        var copy: MusicMiniPlayerView = self
        copy.colorScheme = colorScheme
        return copy
    }
    
    public func addExtraContentView<Content: View>(@ViewBuilder _ view: () -> Content) -> MusicMiniPlayerView {
        var copy = self
        copy.extraContent = AnyView(view())
        return copy
    }
}

#Preview {
    PreviewWrapper()
}

private struct PreviewWrapper: View {
    @State var isExpanded: Bool = false
    @State var isPlaying: Bool = false
    @State var title: String = "Title"
    @State var subtitle: String = "Song.artist.name"

    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                Color.blue
                Color.red
            }
            .ignoresSafeArea()
            MusicMiniPlayerView(
                isExpanded: $isExpanded,
                title: title,
                artist: subtitle,
                urlImage: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRC-uuewOTStCbsa8t4S5nUbBX3wf9sf6LfzA&s",
                isPlaying: isPlaying,
                onPlayPause: {
                    isPlaying.toggle()
                },
                onNextSong: {
                    title = "Next title"
                    subtitle = "Next title"
                },
                onPreviousSong: {
                    title = "Previous title"
                    subtitle = "Previous title"
                }
            )
            .setColorScheme(.dark)
        }
    }
}
