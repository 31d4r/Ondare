//
//  FetchCountriesCall.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import Foundation
import TinyAPI

struct FetchCountriesCall: APICall {
    typealias ResponseType = [RadioStationCountry]

    var request: APIRequest {
        .get(path: "countries")
    }
}
