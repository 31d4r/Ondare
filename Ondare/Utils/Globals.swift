//
//  Globals.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import Foundation

func secureURL(from url: URL?) -> URL? {
    guard let url else { return nil }
    var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
    if components?.scheme == "http" {
        components?.scheme = "https"
    }
    return components?.url
}
