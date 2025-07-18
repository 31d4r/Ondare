//
//  SettingsCoordinator.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import SwiftUI
import UIKit

class SettingsCoordinator: BaseCoordinator<UINavigationController> {
    override func start() {
        showSettingsView()
    }
}

// MARK: - Showing Screens

private extension SettingsCoordinator {
    func showSettingsView() {
        let viewModel = SettingsView.ViewModel()
        viewModel.navDelegate = self

        let view = SettingsView(viewModel: viewModel)
        let controller = SettingsHostingController(rootView: view, viewModel: viewModel)
        controller.title = "Settings"

        presenter.setViewControllers([controller], animated: true)
    }

    func showSettingsRegionView() {
        let coordinator = SettingsRegionCoordinator(presenter: presenter)
        coordinator.delegate = self
        coordinator.start()

        store(coordinator: coordinator)
    }
}

// MARK: - SettingsViewDelegate

extension SettingsCoordinator: SettingsViewNavDelegate {
    func onSettingsRegionTapped() {
        showSettingsRegionView()
    }

    func onSettingsRateAppTapped() {
        if let url = URL(string: "https://apps.apple.com/us/app/6748566886") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - SettingsRegionCoordinatorDelegate

extension SettingsCoordinator: SettingsRegionCoordinatorDelegate {
    func onSettingsRegionCoordinatorComplete(coordinator: SettingsRegionCoordinator) {
        free(coordinator: coordinator)
    }
}
