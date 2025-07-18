//
//  LibraryCoordinator.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import SwiftUI
import UIKit

class LibraryCoordinator: BaseCoordinator<UINavigationController> {
    private let audioPlayer: AudioPlayerViewModel

    init(presenter: UINavigationController, audioPlayer: AudioPlayerViewModel) {
        self.audioPlayer = audioPlayer
        super.init(presenter: presenter)
    }

    override func start() {
        showLibraryScreen()
    }
}

// MARK: - Showing Screens

private extension LibraryCoordinator {
    func showLibraryScreen() {
        let viewModel = LibraryView.ViewModel()

        let view = LibraryView(viewModel: viewModel, audioPlayer: audioPlayer)
        let controller = LibraryHostingController(rootView: view, viewModel: viewModel)
        controller.title = "My Library"

        pushInitialControllerBasedOnEmbeddedNavState(controller: controller)
    }
}
