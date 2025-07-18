//
//  LibraryHostingController.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import UIKit

class LibraryHostingController: HostingController<LibraryView, LibraryView.ViewModel> {}

// MARK: - Lifecycle

extension LibraryHostingController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - View Setup / Configuration

private extension LibraryHostingController {
    func setupView() {
        title = "My Library"
        view.backgroundColor = .oBackground
    }
}

// MARK: - Actions

extension LibraryHostingController {}
