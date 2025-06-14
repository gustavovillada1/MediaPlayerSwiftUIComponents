//
//  File.swift
//  
//
//  Created by Gustavo Adolfo Villada Molina on 6/05/25.
//

import SwiftUI
import Combine

public struct MusicMiniPlayerView: View {
    @Binding var isExpanded: Bool
    
    private let title: String
    private let artist: String
    private let image: Image
    private let onPlayPause: () -> Void
    private let isPlaying: Bool

    public init(
        isExpanded: Binding<Bool>,
        title: String,
        artist: String,
        image: Image,
        isPlaying: Bool,
        onPlayPause: @escaping () -> Void
    ) {
        self._isExpanded = isExpanded
        self.title = title
        self.artist = artist
        self.image = image
        self.onPlayPause = onPlayPause
        self.isPlaying = isPlaying
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            if !isExpanded {
                collapsedView
            } else {
                expandedView
            }
        }
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 5)
        .padding(.horizontal)
        .animation(.easeInOut, value: isExpanded)
    }

    private var collapsedView: some View {
        HStack {
            image
                .resizable()
                .scaledToFill()
                .frame(width: 45, height: 45)
                .cornerRadius(6)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .lineLimit(1)
                Text(artist)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            Spacer()
            Button(action: onPlayPause) {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .font(.title2)
            }
        }
        .padding()
        .onTapGesture {
            withAnimation {
                isExpanded = true
            }
        }
    }

    private var expandedView: some View {
        VStack(spacing: 16) {
            image
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .cornerRadius(12)
            
            Text(title)
                .font(.title2)
                .bold()
                .lineLimit(1)
            
            Text(artist)
                .font(.title3)
                .foregroundColor(.secondary)
                .lineLimit(1)

            HStack(spacing: 40) {
                Button(action: {}) {
                    Image(systemName: "backward.fill")
                        .font(.title)
                }
                Button(action: onPlayPause) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 50))
                }
                Button(action: {}) {
                    Image(systemName: "forward.fill")
                        .font(.title)
                }
            }

            Button("Close") {
                withAnimation {
                    isExpanded = false
                }
            }
            .padding(.top)
        }
        .padding()
    }
}
