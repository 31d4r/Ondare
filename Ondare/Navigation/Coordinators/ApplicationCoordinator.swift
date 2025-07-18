//
//  ApplicationCoordinator.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import SwiftUI
import UIKit

class ApplicationCoordinator: BaseCoordinator<UINavigationController> {
    let window: UIWindow

    init(window: UIWindow) {
        self.window = window

        let presenter = UINavigationController()
        presenter.isToolbarHidden = true

        super.init(presenter: presenter)

        self.window.rootViewController = presenter
        self.window.makeKeyAndVisible()
    }

    override func start() {
        showMain()
    }
}

// MARK: - Showing Screens

extension ApplicationCoordinator {
    func showMain() {
        let mainCoordinator = MainCoordinator(presenter: presenter)
        mainCoordinator.start()

        self.store(coordinator: mainCoordinator)
    }
}
