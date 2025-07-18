//
//  LibraryView.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import SwiftUI

struct LibraryView: View {
    @StateObject var viewModel: ViewModel
    @ObservedObject var audioPlayer: AudioPlayerViewModel

    var body: some View {
        VStack {
            if viewModel.state.favoriteStations.isEmpty {
                radioStationLibraryEmptyView()
            } else {
                radioStationLibraryView()
            }
        }
        .safeAreaInset(edge: .bottom) {
            radioStationPlayerView()
        }
        .searchable(
            text: viewModel.binding(for: \.radioStationSearchText),
            placement: .navigationBarDrawer(displayMode: .always)
        )
        .onChange(of: viewModel.state.radioStationSearchText) { _ in
            viewModel.send(.searchRadioStationByNameOrGengre(text: viewModel.state.radioStationSearchText))
        }
        .task {
            viewModel.send(.loadFavoritesRadioStation)
        }
    }

    func radioStationLibraryEmptyView() -> some View {
        Text("No favourites yet. Your liked radio stations will appear here.")
            .multilineTextAlignment(.center)
            .fontWeight(.light)
            .padding(.horizontal)
    }

    func radioStationLibraryView() -> some View {
        ScrollView {
            ForEach(viewModel.state.favoriteStations) { station in
                RadioStationRow(
                    imageUrl: station.favicon,
                    title: station.name,
                    isFavourite: true,
                    isPlaying: audioPlayer.state.currentStationURL?.absoluteString == station.streamUrl,
                    onToggleFavourite: {
                        viewModel.send(.removeFavoriteRadioStation(for: station))
                    },
                    action: {
                        if let streamURL = URL(string: station.streamUrl) {
                            audioPlayer.send(
                                .playRadioStation(streamURL),
                                metadata: AudioPlayerViewModel.Metadata(
                                    title: station.name,
                                    artist: station.tags,
                                    artworkURL: URL(string: station.favicon ?? "")
                                )
                            )
                        }
                    }
                )
            }
        }
    }

    @ViewBuilder
    func radioStationPlayerView() -> some View {
        if audioPlayer.state.currentStationURL != nil {
            AudioPlayerView(
                title: audioPlayer.state.currentStationName ?? "",
                imageUrl: audioPlayer.state.currentStationImageURL,
                isPlaying: audioPlayer.state.isPlaying,
                action: {
                    audioPlayer.send(.playOrPause)
                }
            )
        }
    }
}
