//
//  DiscoverHostingController.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import UIKit

class DiscoverHostingController: HostingController<DiscoverView, DiscoverView.ViewModel> {}

// MARK: - Lifecycle

extension DiscoverHostingController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - View Setup / Configuration

private extension DiscoverHostingController {
    func setupView() {
        title = "Discover"
        view.backgroundColor = .oBackground
    }
}

// MARK: - Actions

extension DiscoverHostingController {}
