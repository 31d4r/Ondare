//
//  SelectedRegionModel.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import Foundation
import GRDB

struct SelectedRegion: Codable, FetchableRecord, PersistableRecord, Identifiable {
    var id: String { iso3166_1 }
    let iso3166_1: String
    let name: String
}
