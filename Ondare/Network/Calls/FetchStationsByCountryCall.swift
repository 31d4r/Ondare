//
//  FetchStationsByCountryCall.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import Foundation
import TinyAPI

struct FetchStationsByCountryCall: APICall {
    typealias ResponseType = [RadioStationModel]

    let countryCode: String

    var request: APIRequest {
        .get(path: "stations/bycountrycodeexact/\(countryCode)")
    }
}
