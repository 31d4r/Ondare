//
//  SettingsRegionViewModel.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import SwiftUI
import TinyAPI

protocol SettingsRegionNavDelegate: AnyObject {
    func onSettingsRegionBackButtonTapped()
    func onSettingsRegionMoreButtonTapped()
}

extension SettingsRegionView {
    struct SettingsRegionViewState {
        var stationCountries = [RadioStationCountry]()
        var filteredStationCountries = [RadioStationCountry]()
        var didUserSelectRegion = false
        var regionAlertText = ""
        var countrySearchText = ""
    }

    enum Action {
        case fetchStationCountries
        case searchCountry(text: String)
        case toggleRegionSelection(country: RadioStationCountry)
    }

    class ViewModel: BaseViewModel, ObservableObject {
        weak var navDelegate: SettingsRegionNavDelegate?

        @Published private(set) var state = SettingsRegionViewState()
        private var networkClient = NetworkClient()

        var showBackButton = false
    }
}

// MARK: - Utils

extension SettingsRegionView.ViewModel {
    func set<T>(_ keyPath: WritableKeyPath<SettingsRegionView.SettingsRegionViewState, T>, to value: T) {
        state[keyPath: keyPath] = value
    }

    func binding<T>(for keyPath: WritableKeyPath<SettingsRegionView.SettingsRegionViewState, T>) -> Binding<T> {
        Binding<T>(
            get: { self.state[keyPath: keyPath] },
            set: { newValue in
                self.state[keyPath: keyPath] = newValue
            }
        )
    }

    func send(_ action: SettingsRegionView.Action) {
        Task {
            await handle(action)
        }
    }
}

// MARK: - Actions

extension SettingsRegionView.ViewModel {
    @MainActor
    private func handle(_ action: SettingsRegionView.Action) async {
        switch action {
        case .fetchStationCountries:
            let call = FetchCountriesCall()
            let result = await networkClient.execute(call)

            switch result {
            case .success(let response):
                state.stationCountries = response
                state.filteredStationCountries = response
            case .failure(let error):
                print("Request failed:", error)
            }
        case .searchCountry(text: let text):
            if !text.isEmpty {
                state.filteredStationCountries = state.stationCountries
                    .filter {
                        $0.name.lowercased().contains(text.lowercased())
                    }
            } else {
                state.filteredStationCountries = state.stationCountries
            }
        case .toggleRegionSelection(country: let country):
            toggleRegionSelection(for: country)
        }
    }

    private func toggleRegionSelection(for country: RadioStationCountry) {
        do {
            let isSelected = DatabaseManager.shared.isRegionSelected(isoCode: country.iso3166_1)

            if isSelected {
                try DatabaseManager.shared.removeSelectedRegion(isoCode: country.iso3166_1)
                updateRegionSelectionAlert(message: "Region Deselected")
            } else {
                try DatabaseManager.shared.removeSelectedRegions()

                let selectedRegion = SelectedRegion(iso3166_1: country.iso3166_1, name: country.name)
                try DatabaseManager.shared.saveSelectedRegion(selectedRegion)
                updateRegionSelectionAlert(message: "Region Selected")
            }
        } catch {
            print("Database error: \(error)")
            updateRegionSelectionAlert(message: "Selection failed")
        }
    }

    private func updateRegionSelectionAlert(message: String) {
        set(\.didUserSelectRegion, to: true)
        set(\.regionAlertText, to: message)
    }

    func onBackButtonTapped() {
        navDelegate?.onSettingsRegionBackButtonTapped()
    }

    func onMoreButtonTapped() {
        navDelegate?.onSettingsRegionMoreButtonTapped()
    }
}
