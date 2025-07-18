//
//  RadioStationCountry.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import Foundation

struct RadioStationCountry: Identifiable, Codable {
    let id = UUID()
    let name: String
    let iso3166_1: String
    let stationCount: Int
    var selected: Bool = false

    enum CodingKeys: String, CodingKey {
        case name
        case iso3166_1 = "iso_3166_1"
        case stationCount = "stationcount"
    }
}
