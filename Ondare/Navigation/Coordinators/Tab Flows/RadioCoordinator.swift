//
//  RadioCoordinator.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import SwiftUI
import UIKit

class RadioCoordinator: BaseCoordinator<UINavigationController> {
    private let audioPlayer: AudioPlayerViewModel

    init(presenter: UINavigationController, audioPlayer: AudioPlayerViewModel) {
        self.audioPlayer = audioPlayer
        super.init(presenter: presenter)
    }

    override func start() {
        showRadioScreen()
    }
}

// MARK: - Showing Screens

private extension RadioCoordinator {
    func showRadioScreen() {
        let viewModel = RadioView.ViewModel()

        let view = RadioView(viewModel: viewModel, audioPlayer: audioPlayer)
        let controller = RadioHostingController(rootView: view, viewModel: viewModel)
        controller.title = "Radio"

        pushInitialControllerBasedOnEmbeddedNavState(controller: controller)
    }
}
