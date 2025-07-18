//
//  LibraryViewModel.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import Foundation
import GRDB
import SwiftUI

extension LibraryView {
    struct LibraryViewState {
        var favoriteStations = [FavoriteStation]()
        var filteredRadioStations = [FavoriteStation]()

        var radioStationSearchText = ""
    }

    enum Action {
        case loadFavoritesRadioStation
        case removeFavoriteRadioStation(for: FavoriteStation)
        case searchRadioStationByNameOrGengre(text: String)
    }

    class ViewModel: BaseViewModel, ObservableObject {
        @Published private(set) var state = LibraryViewState()
    }
}

// MARK: - Utils {

extension LibraryView.ViewModel {
    func send(_ action: LibraryView.Action) {
        Task {
            await handle(action)
        }
    }

    func binding<T>(for keyPath: WritableKeyPath<LibraryView.LibraryViewState, T>) -> Binding<T> {
        Binding<T>(
            get: { self.state[keyPath: keyPath] },
            set: { newValue in
                self.state[keyPath: keyPath] = newValue
            }
        )
    }
}

// MARK: - Actions

extension LibraryView.ViewModel {
    @MainActor
    private func handle(_ action: LibraryView.Action) async {
        switch action {
        case .loadFavoritesRadioStation:
            loadFavorites()
        case .removeFavoriteRadioStation(for: let station):
            removeFavorite(station: station)
        case .searchRadioStationByNameOrGengre(text: let text):
            if !text.isEmpty {
                state.filteredRadioStations = state.favoriteStations
                    .filter {
                        $0.name.lowercased().contains(text.lowercased()) || $0.tags.contains(text.lowercased())
                    }
            } else {
                state.filteredRadioStations = state.favoriteStations
            }
        }
    }
}

// MARK: - Functions {

extension LibraryView.ViewModel {
    func loadFavorites() {
        do {
            state.favoriteStations = try DatabaseManager.shared.fetchAllFavorites()
        } catch {
            print("Failed to load favorites: \(error)")
        }
    }

    func removeFavorite(station: FavoriteStation) {
        do {
            try DatabaseManager.shared.removeFavorite(withId: station.id)
            loadFavorites()
        } catch {
            print("Failed to remove: \(error)")
        }
    }

    func isFavorite(_ station: RadioStationModel) -> Bool {
        DatabaseManager.shared.isFavorite(id: station.id)
    }
}
