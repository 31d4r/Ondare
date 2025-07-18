//
//  MainCoordinator.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import SwiftUI
import UIKit

enum NavigationBarTag: Int {
    case radio
    case discover
    case library
    case settings
}

class MainCoordinator: BaseCoordinator<UINavigationController> {
    private let audioPlayer = AudioPlayerViewModel()

    override func start() {
        presenter.setNavigationBarHidden(true, animated: false)
        showTabBarView()
    }
}

// MARK: - Showing Screens

private extension MainCoordinator {
    func showTabBarView() {
        let radioCoordinator = configureRadioCoordinator()
        let discoverCoordinator = configureDiscoverCoordinator()
        let libraryCoordinator = configureLibraryCoordinator()
        let settingsCoordinator = configureSettingsCoordinator()

        let controllers = [
            radioCoordinator.presenter,
            discoverCoordinator.presenter,
            libraryCoordinator.presenter,
            settingsCoordinator.presenter
        ]

        let tabBarController = UITabBarController()
        tabBarController.setViewControllers(controllers, animated: false)
        tabBarController.tabBar.tintColor = .oBlue

        presenter.setViewControllers([tabBarController], animated: true)
    }
}

// MARK: - Sub Coordinator

private extension MainCoordinator {
    func configureRadioCoordinator() -> RadioCoordinator {
        let flowPresenter = UINavigationController()
        flowPresenter.tabBarItem = UITabBarItem(
            title: "Radio",
            image: UIImage(systemName: "radio"),
            tag: NavigationBarTag.radio.rawValue
        )

        let coordinator = RadioCoordinator(
            presenter: flowPresenter,
            audioPlayer: audioPlayer
        )
        coordinator.start()

        store(coordinator: coordinator)
        return coordinator
    }

    func configureDiscoverCoordinator() -> DiscoverCoordinator {
        let flowPresenter = UINavigationController()
        flowPresenter.tabBarItem = UITabBarItem(
            title: "Discover",
            image: UIImage(systemName: "magnifyingglass"),
            tag: NavigationBarTag.discover.rawValue
        )

        let coordinator = DiscoverCoordinator(
            presenter: flowPresenter,
            audioPlayer: audioPlayer
        )
        coordinator.start()

        store(coordinator: coordinator)
        return coordinator
    }

    func configureLibraryCoordinator() -> LibraryCoordinator {
        let flowPresenter = UINavigationController()
        flowPresenter.tabBarItem = UITabBarItem(
            title: "Library",
            image: UIImage(systemName: "music.note.list"),
            tag: NavigationBarTag.library.rawValue
        )

        let coordinator = LibraryCoordinator(
            presenter: flowPresenter,
            audioPlayer: audioPlayer
        )
        coordinator.start()

        store(coordinator: coordinator)
        return coordinator
    }

    func configureSettingsCoordinator() -> SettingsCoordinator {
        let flowPresenter = UINavigationController()
        flowPresenter.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gear"),
            tag: NavigationBarTag.library.rawValue
        )

        let coordinator = SettingsCoordinator(presenter: flowPresenter)
        coordinator.start()

        store(coordinator: coordinator)
        return coordinator
    }
}
