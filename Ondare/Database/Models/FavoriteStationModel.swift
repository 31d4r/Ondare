//
//  FavoriteStationModel.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import Foundation
import GRDB

struct FavoriteStation: Codable, FetchableRecord, PersistableRecord, Identifiable {
    var id: String
    var name: String
    var favicon: String?
    var streamUrl: String
    var tags: String
}
