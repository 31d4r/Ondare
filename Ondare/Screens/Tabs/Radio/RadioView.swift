//
//  RadioView.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import SwiftUI

private enum Constants {
    static let stationsLimit = 20
}

struct RadioView: View {
    @StateObject var viewModel: ViewModel
    @ObservedObject var audioPlayer: AudioPlayerViewModel

    var body: some View {
        radioStationRadioView()
            .safeAreaInset(edge: .bottom) {
                radioStationPlayerView()
            }
            .task {
                viewModel.send(
                    .fetchTopStations(
                        limit: Constants.stationsLimit
                    )
                )
            }
    }

    func radioStationRadioView() -> some View {
        ScrollView {
            ForEach(viewModel.state.radioStations, id: \.id) { station in
                RadioStationRow(
                    imageUrl: station.favicon,
                    title: station.name,
                    isFavourite: viewModel.isFavorite(station),
                    isPlaying: audioPlayer.state.currentStationURL?.absoluteString == station.streamUrl,
                    onToggleFavourite: {
                        viewModel.send(.toggleFavorite(for: station))
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
