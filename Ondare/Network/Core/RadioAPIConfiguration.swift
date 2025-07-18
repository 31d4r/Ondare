//
//  RadioAPIConfiguration.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import Foundation
import TinyAPI

// MARK: - Radio API Configuration

struct RadioAPIConfiguration: APIConfiguration {
    let baseURL = URL(string: "https://de1.api.radio-browser.info/json/")!
    let timeoutInterval: TimeInterval = 30
    let defaultHeaders = [
        "Accept": "application/json",
        "User-Agent": "Ondare/1.0"
    ]
    let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}
