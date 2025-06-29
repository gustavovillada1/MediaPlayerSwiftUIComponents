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
    
    /// Indicates whether the mini player is currently expanded or collapsed.
    @Binding var isExpanded: Bool

    /// Indicates whether auto-play is enabled, allowing infinite track playback.
    private var isAutoPlayOn: Bool?

    /// Indicates whether the current track should repeat when finished.
    private var isRepeatTrackOn: Bool?

    /// Indicates whether the current track is actively playing.
    private var isPlaying: Bool?

    /// The title text to be displayed in the mini player (usually the track title).
    private let title: String

    /// The subtitle text to be displayed in the mini player (usually the artist or album).
    private let subtitle: String

    /// A local image to display as the track's artwork.
    private let image: Image?

    /// A remote image URL to load and display as the track's artwork.
    private let urlImage: String?

    /// The color scheme to be used in the mini player (e.g. dark or light mode).
    private var colorScheme: ColorScheme = .dark

    /// Optional additional view content to display in the mini player (e.g. controls, lyrics).
    private var extraContent: AnyView?

    /// An action triggered when the play/pause button is pressed.
    private var onPlayPause: (() -> Void)?

    /// An action triggered when the next track button is pressed.
    private var onNextTrack: (() -> Void)?

    /// An action triggered when the previous track button is pressed.
    private var onPreviousTrack: (() -> Void)?

    /// An action triggered when the auto-play toggle is pressed.
    private var onAutoPlay: (() -> Void)?

    /// An action triggered when the repeat toggle is pressed.
    private var onRepeatTrack: (() -> Void)?
    
    
    public init(
        isExpanded: Binding<Bool>,
        title: String,
        artist: String,
        image: Image? = nil,
        urlImage: String? = nil
    ) {
        self._isExpanded = isExpanded
        self.title = title
        self.subtitle = artist
        self.image = image
        self.urlImage = urlImage
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
                if let onPreviousSong: () -> Void = onPreviousTrack {
                    Button(action: onPreviousSong) {
                        Icons.backwardFill.image
                            .font(.title3)
                    }
                    .buttonStyle(.plain)
                }
                
                if let onPlayPause: () -> Void = onPlayPause {
                    Button(action: onPlayPause) {
                        Image(systemName: isPlaying ?? false ? "pause.fill" : "play.fill")
                            .font(.title)
                    }
                    .buttonStyle(.plain)
                }
                
                if let onNextSong: () -> Void = onNextTrack {
                    Button(action: onNextSong) {
                        Icons.forwardFill.image
                            .font(.title3)
                    }
                    .buttonStyle(.plain)
                }
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
        HStack(spacing: 30) {
            if let onRepeatTrack: () -> Void = onRepeatTrack {
                Button(action: onRepeatTrack, label: {
                    Image(systemName: "repeat.1")
                        .font(.system(size: 20))
                        .foregroundStyle((isRepeatTrackOn ?? false) ? Color.blue: Color.white)
                })
            }

            if let onPreviousTrack: () -> Void = onPreviousTrack {
                Button(action: onPreviousTrack) {
                    Icons.backwardFill.image
                        .font(.title)
                }
                .buttonStyle(.plain)
            }
            
            if let onPlayPause: () -> Void = onPlayPause {
                Button(action: onPlayPause) {
                    Image(systemName: isPlaying ?? false ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 50))
                }
                .buttonStyle(.plain)
            }
            
            if let onNextTrack: () -> Void = onNextTrack {
                Button(action: onNextTrack) {
                    Icons.forwardFill.image
                        .font(.title)
                }
                .buttonStyle(.plain)
            }
            
            if let onAutoPlay: () -> Void = onAutoPlay {
                Button(
                    action: onAutoPlay,
                    label: {
                        Image(systemName: "infinity")
                            .font(.system(size: 20))
                            .foregroundStyle((isAutoPlayOn ?? false) ? Color.blue: Color.white)
                    })
            }
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
    
    public func onPlayPause(isPlaying: Bool, _ didTapOnPlayPause: @escaping () -> Void) -> MusicMiniPlayerView {
        var copy = self
        copy.isPlaying = isPlaying
        copy.onPlayPause = didTapOnPlayPause
        return copy
    }
    
    public func onNextTrack(_ didTapOnNextTrack: @escaping () -> Void) -> MusicMiniPlayerView {
        var copy = self
        copy.onNextTrack = didTapOnNextTrack
        return copy
    }
    
    public func onPreviousTrack(_ didTapOnPreviousTrack: @escaping () -> Void) -> MusicMiniPlayerView {
        var copy = self
        copy.onPreviousTrack = didTapOnPreviousTrack
        return copy
    }
    
    public func onRepeatTrack(isRepeatTrackOn: Bool, _ didTapOnRepeatTrack: @escaping () -> Void) -> MusicMiniPlayerView {
        var copy = self
        copy.isRepeatTrackOn = isRepeatTrackOn
        copy.onRepeatTrack = didTapOnRepeatTrack
        return copy
    }
    
    public func onAutoPlay(isAutoPlayOn: Bool, _ didTapOnAutoPlay: @escaping () -> Void) -> MusicMiniPlayerView {
        var copy = self
        copy.isAutoPlayOn = isAutoPlayOn
        copy.onAutoPlay = didTapOnAutoPlay
        return copy
    }

}

#Preview {
    PreviewWrapper()
}

private struct PreviewWrapper: View {
    @State var isExpanded: Bool = false
    @State var isPlaying: Bool = false
    @State var shouldRepeatTrack: Bool = false
    @State var isAutoPlayOn: Bool = false
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
                urlImage: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRC-uuewOTStCbsa8t4S5nUbBX3wf9sf6LfzA&s"
            )
            .setColorScheme(.dark)
            .onPlayPause(isPlaying: isPlaying) {
                isPlaying.toggle()
            }
            .onNextTrack {
                title = "Next track Title"
                subtitle = "NextTrack Subtitle"
            }
            .onPreviousTrack {
                title = "Previous track Title"
                subtitle = "Previous Subtitle"
            }
            .onRepeatTrack(isRepeatTrackOn: shouldRepeatTrack) {
                shouldRepeatTrack.toggle()
            }
            .onAutoPlay(isAutoPlayOn: isAutoPlayOn) { 
                isAutoPlayOn.toggle()
            }
        }
    }
}
