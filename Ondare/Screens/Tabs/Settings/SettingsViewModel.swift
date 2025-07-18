//
//  SettingsViewModel.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

protocol SettingsViewNavDelegate: AnyObject {
    func onSettingsRegionTapped()
    func onSettingsRateAppTapped()
}

import Foundation
import UIKit

extension SettingsView {
    enum Action {
        case onSettingsRegionTapped
        case onRateOndareAppTapped
    }

    class ViewModel: BaseViewModel, ObservableObject {
        weak var navDelegate: SettingsViewNavDelegate?
    }
}

// MARK: - Utils

extension SettingsView.ViewModel {
    func send(_ action: SettingsView.Action) {
        Task {
            await handle(action)
        }
    }
}

// MARK: - Actions

extension SettingsView.ViewModel {
    @MainActor
    private func handle(_ action: SettingsView.Action) async {
        switch action {
        case .onSettingsRegionTapped:
            onSettingsRegionTapped()
        case .onRateOndareAppTapped:
            onSettingsRateAppTapped()
        }
    }

    func onSettingsRegionTapped() {
        navDelegate?.onSettingsRegionTapped()
    }

    func onSettingsRateAppTapped() {
        navDelegate?.onSettingsRateAppTapped()
    }
}
