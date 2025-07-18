//
//  UIViewControllerExtensions.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import UIKit

extension UIViewController {
    func setCustomBackButton(target: Any?, selector: Selector) {
        navigationItem.hidesBackButton = true
        navigationItem.setHidesBackButton(true, animated: false)

        let backImage = UIImage(systemName: "chevron.left")?.withTintColor(.oText, renderingMode: .alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: target, action: selector)
        navigationItem.leftBarButtonItem = backButton
    }
}
