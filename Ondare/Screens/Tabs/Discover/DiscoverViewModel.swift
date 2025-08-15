//
//  DiscoverViewModel.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import SwiftUI
import TinyAPI

extension DiscoverView {
    struct DiscoverViewState {
        var radioStations = [RadioStationModel]()
        var favorites = Set<String>()

        var filteredRadioStations = [RadioStationModel]()
        var radioStationSearchText = ""

        var selectedCategory: DiscoverView.RadioStationCategory = .all

        var currentOffset = 0
        var isLoading = false
        var hasMoreData = true
        let itemsPerPage = 200
        var lastLoadedIndex = -1
    }

    enum Action {
        case fetchStations(offset: Int, limit: Int)
        case fetchStationsByCountry
        case toggleFavorite(for: RadioStationModel)
        case searchRadioStationByNameOrGengre(text: String)
        case filterByCategory(DiscoverView.RadioStationCategory)
        case loadMoreStations
    }

    enum RadioStationCategory: String, CaseIterable {
        case all = "All"
        case rock = "Rock"
        case dance = "Dance"
        case pop = "Pop"
        case chillOut = "Chill"
        case hipHop = "Hip Hop"
        case jazz = "Jazz"
        case classic = "Classic"
    }

    class ViewModel: BaseViewModel, ObservableObject {
        @Published private(set) var state = DiscoverViewState()
        private var networkClient = NetworkClient()
    }
}

// MARK: - Utils

extension DiscoverView.ViewModel {
    func value<T>(_ keyPath: KeyPath<DiscoverView.DiscoverViewState, T>) -> T {
        state[keyPath: keyPath]
    }

    func set<T>(_ keyPath: WritableKeyPath<DiscoverView.DiscoverViewState, T>, to value: T) {
        state[keyPath: keyPath] = value
    }

    func binding<T>(for keyPath: WritableKeyPath<DiscoverView.DiscoverViewState, T>) -> Binding<T> {
        Binding<T>(
            get: { self.state[keyPath: keyPath] },
            set: { newValue in
                self.state[keyPath: keyPath] = newValue
            }
        )
    }

    func send(_ action: DiscoverView.Action) {
        Task {
            await handle(action)
        }
    }
}

// MARK: - Actions

extension DiscoverView.ViewModel {
    @MainActor
    private func handle(_ action: DiscoverView.Action) async {
        switch action {
        case .fetchStations(offset: let offset, limit: let limit):
            state.isLoading = true

            let call = FetchStationsCall(offset: offset, limit: limit)
            let result = await networkClient.execute(call)

            switch result {
            case .success(let response):
                let validStations = response.filter { !$0.streamUrl.isEmpty }

                if offset == 0 {
                    state.radioStations = validStations
                    state.filteredRadioStations = validStations
                } else {
                    state.radioStations.append(contentsOf: validStations)
                    state.filteredRadioStations.append(contentsOf: validStations)
                }

                state.currentOffset += limit
                state.hasMoreData = validStations.count == limit
                state.isLoading = false

            case .failure(let error):
                print("Request failed:", error)
            }
        case .toggleFavorite(for: let station):
            toggleFavorite(for: station)
        case .searchRadioStationByNameOrGengre(text: let text):
            if !text.isEmpty {
                state.filteredRadioStations = state.radioStations
                    .filter {
                        $0.name.lowercased().contains(text.lowercased()) || $0.tags.contains(text.lowercased())
                    }
            } else {
                state.filteredRadioStations = state.radioStations
            }
        case .filterByCategory(let category):
            if category == .all {
                state.filteredRadioStations = state.radioStations
            } else {
                state.filteredRadioStations = state.radioStations.filter {
                    $0.tags.lowercased().contains(category.rawValue.lowercased())
                }
            }
        case .fetchStationsByCountry:
            guard let selectedRegion = DatabaseManager.shared.fetchAllSelectedRegions().first else { return }

            let call = FetchStationsByCountryCall(countryCode: selectedRegion.iso3166_1)
            let result = await networkClient.execute(call)

            switch result {
            case .success(let response):
                state.radioStations = response.filter { !$0.streamUrl.isEmpty }
                state.filteredRadioStations = response.filter { !$0.streamUrl.isEmpty }
            case .failure(let error):
                print("Request failed:", error)
            }
        case .loadMoreStations:
            if !state.isLoading && state.hasMoreData {
                state.lastLoadedIndex = state.filteredRadioStations.count - 1
                await handle(.fetchStations(offset: state.currentOffset, limit: state.itemsPerPage))
            }
        }
    }
}

// MARK: - Functions

extension DiscoverView.ViewModel {
    func toggleFavorite(for station: RadioStationModel) {
        if state.favorites.contains(station.id) {
            state.favorites.remove(station.id)
            do {
                try DatabaseManager.shared.removeFavorite(withId: station.id)
            } catch {
                print("Error", error.localizedDescription)
            }
        } else {
            state.favorites.insert(station.id)
            let favorite = FavoriteStation(
                id: station.id,
                name: station.name,
                favicon: station.favicon,
                streamUrl: station.streamUrl,
                tags: station.tags
            )
            try? DatabaseManager.shared.saveFavorite(favorite)
        }
    }

    func isFavorite(_ station: RadioStationModel) -> Bool {
        DatabaseManager.shared.isFavorite(id: station.id)
    }
}
