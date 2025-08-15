//
//  RadioViewModel.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import Foundation
import TinyAPI

extension RadioView {
    struct RadioViewState {
        var radioStations = [RadioStationModel]()
        var favorites = Set<String>()
    }

    enum Action {
        case fetchTopStations(limit: Int)
        case toggleFavorite(for: RadioStationModel)
    }

    class ViewModel: BaseViewModel, ObservableObject {
        @Published private(set) var state = RadioViewState()
        private var networkClient = NetworkClient()
    }
}

// MARK: - Utils

extension RadioView.ViewModel {
    func send(_ action: RadioView.Action) {
        Task {
            await handle(action)
        }
    }
}

// MARK: - Actions

extension RadioView.ViewModel {
    @MainActor
    private func handle(_ action: RadioView.Action) async {
        switch action {
        case .fetchTopStations(limit: let limit):
            let call = FetchTopStationsCall(limit: limit)
            let result = await networkClient.execute(call)

            switch result {
            case .success(let response):
                state.radioStations = response.filter { !$0.streamUrl.isEmpty }
            case .failure(let error):
                print("Request failed:", error)
            }
        case .toggleFavorite(for: let station):
            toggleFavorite(for: station)
        }
    }
}

// MARK: - Functions

extension RadioView.ViewModel {
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
