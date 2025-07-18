//
//  DiscoverCoordinator.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import SwiftUI
import UIKit

class DiscoverCoordinator: BaseCoordinator<UINavigationController> {
    private let audioPlayer: AudioPlayerViewModel

    init(presenter: UINavigationController, audioPlayer: AudioPlayerViewModel) {
        self.audioPlayer = audioPlayer
        super.init(presenter: presenter)
    }

    override func start() {
        showDiscoverScreen()
    }
}

// MARK: - Showing Screens

private extension DiscoverCoordinator {
    func showDiscoverScreen() {
        let viewModel = DiscoverView.ViewModel()

        let view = DiscoverView(viewModel: viewModel, audioPlayer: audioPlayer)
        let controller = DiscoverHostingController(rootView: view, viewModel: viewModel)
        controller.title = "Discover"

        pushInitialControllerBasedOnEmbeddedNavState(controller: controller)
    }
}
