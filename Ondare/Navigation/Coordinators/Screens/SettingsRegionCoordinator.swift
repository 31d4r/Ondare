//
//  SettingsRegionCoordinator.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import SwiftUI
import UIKit

protocol SettingsRegionCoordinatorDelegate: AnyObject {
    func onSettingsRegionCoordinatorComplete(coordinator: SettingsRegionCoordinator)
}

class SettingsRegionCoordinator: BaseCoordinator<UINavigationController> {
    weak var delegate: SettingsRegionCoordinatorDelegate?
    override func start() {
        showRegionView()
    }
}

// MARK: - Showing Screens

private extension SettingsRegionCoordinator {
    func showRegionView() {
        let viewModel = SettingsRegionView.ViewModel()
        viewModel.navDelegate = self
        let view = SettingsRegionView(viewModel: viewModel)
        let controller = SettingsRegionViewHostingController(rootView: view, viewModel: viewModel)
        controller.title = "Region"

        pushInitialControllerBasedOnEmbeddedNavState(controller: controller)
    }
}

// MARK: - SettingsRegionNavDelegate

extension SettingsRegionCoordinator: SettingsRegionNavDelegate {
    func onSettingsRegionMoreButtonTapped() {
        do {
            try DatabaseManager.shared.removeSelectedRegions()
            presenter.popViewController(animated: true)
        } catch {
            print("Error", error.localizedDescription)
        }
    }

    func onSettingsRegionBackButtonTapped() {
        presenter.popViewController(animated: true)
        delegate?.onSettingsRegionCoordinatorComplete(coordinator: self)
    }
}
