//
//  SettingsViewHostingController.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import UIKit

class SettingsRegionViewHostingController: HostingController<SettingsRegionView, SettingsRegionView.ViewModel> {}

// MARK: - Lifecycle

extension SettingsRegionViewHostingController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - View Setup / Configuration

private extension SettingsRegionViewHostingController {
    func setupView() {
        title = "Region"
        view.backgroundColor = .oBackground

        setCustomBackButton(target: self, selector: #selector(onBackButtonTapped))

        customRightButton()
    }

    func customRightButton() {
        let rightButtonImage = UIImage(systemName: "ellipsis")?.withTintColor(.oText, renderingMode: .alwaysOriginal)

        let menu = UIMenu(title: "", children: [
            UIAction(title: "Reset Region") { _ in
                self.onMoreButtonTapped()
            }
        ])

        let rightButton = UIBarButtonItem(
            image: rightButtonImage,
            style: .plain,
            target: nil,
            action: nil
        )
        rightButton.menu = menu

        navigationItem.rightBarButtonItem = rightButton
    }
}

// MARK: - Actions

extension SettingsRegionViewHostingController {
    @objc func onBackButtonTapped() {
        viewModel.onBackButtonTapped()
    }

    @objc func onMoreButtonTapped() {
        viewModel.onMoreButtonTapped()
    }
}
