//
//  RadioStation.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import Foundation

struct RadioStationModel: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let streamUrl: String
    let favicon: String?
    let tags: String

    enum CodingKeys: String, CodingKey {
        case id = "stationuuid"
        case name
        case streamUrl = "url_resolved"
        case favicon
        case tags
    }
}
