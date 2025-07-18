//
//  AudioPlayerView.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import SwiftUI

private enum Constants {
    static let miniRadioStationPlayerArtwork: CGFloat = 50
    static let largeRadioStationPlayerArtwork: CGFloat = 250
    static let radioStationArtworkCornerRadius: CGFloat = 10
    static let miniRadioStationPlayerCornerRadius: CGFloat = 15
    static let miniRadioStationPlayerHeight: CGFloat = 80
}

struct AudioPlayerView: View {
    var title: String
    var imageUrl: URL?
    var isPlaying: Bool
    
    var action: (() -> Void)? = nil
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                if let url = secureURL(from: imageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(
                                width: 50,
                                height: 50
                            )
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 10
                                )
                            )
                    } placeholder: {
                        Image(.logo)
                            .resizable()
                            .scaledToFit()
                            .frame(
                                width: 50,
                                height: 50
                            )
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 10
                                )
                            )
                    }
                }
                
                Text(title)
                    .fontWeight(.light)
                
                Spacer()
                
                Button {
                    action?()
                } label: {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.title2)
                        .fontWeight(.light)
                        .foregroundStyle(.oText)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .background(.ultraThinMaterial)
        .frame(height: 80)
        .cornerRadius(15, corners: [.topLeft, .topRight])
    }
}
