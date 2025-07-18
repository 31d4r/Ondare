//
//  RadioHostingController.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import UIKit

class RadioHostingController: HostingController<RadioView, RadioView.ViewModel> {}

// MARK: - Lifecycle

extension RadioHostingController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - View Setup / Configuration

private extension RadioHostingController {
    func setupView() {
        title = "Top"
        view.backgroundColor = .oBackground
    }
}

// MARK: - Actions

extension RadioHostingController {}
