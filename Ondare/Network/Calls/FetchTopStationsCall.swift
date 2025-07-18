//
//  FetchTopStationsCall.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import Foundation
import TinyAPI

struct FetchTopStationsCall: APICall {
    typealias ResponseType = [RadioStationModel]

    let limit: Int

    var request: APIRequest {
        .get(path: "stations/topclick/\(limit)")
    }
}
