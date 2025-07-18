//
//  SettingsHostingController.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import UIKit

class SettingsHostingController: HostingController<SettingsView, SettingsView.ViewModel> {}

// MARK: - Lifecycle

extension SettingsHostingController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - View Setup / Configuration

private extension SettingsHostingController {
    func setupView() {
        title = "Settings"
        view.backgroundColor = .oBackground
    }
}

// MARK: - Actions

extension SettingsHostingController {}
