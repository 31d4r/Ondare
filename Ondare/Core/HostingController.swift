//
//  HostingController.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import SwiftUI
import UIKit

class HostingController<Content: View, VM: BaseViewModel>: UIHostingController<Content> {
    var viewModel: VM

    init(rootView: Content, viewModel: VM) {
        self.viewModel = viewModel
        super.self.init(rootView: rootView)
        viewModel.hostingController = self
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
}
