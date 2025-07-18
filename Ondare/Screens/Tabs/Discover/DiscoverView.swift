//
//  DiscoverView.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import SwiftUI

struct DiscoverView: View {
    @Namespace private var underlineNamespace

    @StateObject var viewModel: ViewModel
    @ObservedObject var audioPlayer: AudioPlayerViewModel

    var body: some View {
        VStack {
            radioStationTopCategoryFilter()
            radioStationDiscoverView()
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
            if DatabaseManager.shared.fetchAllSelectedRegions().isEmpty {
                viewModel.send(
                    .fetchStations(
                        offset: viewModel.state.currentOffset,
                        limit: viewModel.state.itemsPerPage
                    )
                )
            } else {
                viewModel.send(.fetchStationsByCountry)
            }
        }
    }

    func radioStationTopCategoryFilter() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(RadioStationCategory.allCases, id: \.self) { category in
                    VStack {
                        Text(category.rawValue)
                            .fontWeight(viewModel.state.selectedCategory == category ? .bold : .regular)
                            .foregroundStyle(viewModel.state.selectedCategory == category ? .oText : .gray)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    viewModel.set(\.selectedCategory, to: category)
                                }
                            }

                        ZStack {
                            if viewModel.state.selectedCategory == category {
                                Capsule()
                                    .frame(height: 3)
                                    .foregroundStyle(.oBlue)
                                    .matchedGeometryEffect(id: "underline", in: underlineNamespace)
                            } else {
                                Capsule()
                                    .frame(height: 3)
                                    .foregroundColor(.clear)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 50)
        .onChange(of: viewModel.state.selectedCategory) { _ in
            viewModel.send(.filterByCategory(viewModel.state.selectedCategory))
        }
    }

    func radioStationDiscoverView() -> some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.state.filteredRadioStations, id: \.id) { station in
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

                if viewModel.state.isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                            .scaleEffect(1.2)
                            .padding()
                        Spacer()
                    }
                }
            }
        }
        .onChange(of: viewModel.state.filteredRadioStations.count) { newCount in
            if DatabaseManager.shared.fetchAllSelectedRegions().isEmpty {
                if newCount > 0 && newCount % 200 == 0 && !viewModel.state.isLoading && viewModel.state.hasMoreData {
                    viewModel.send(.loadMoreStations)
                }
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
