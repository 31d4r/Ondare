//
//  FetchStationsCall.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import Foundation
import TinyAPI

struct FetchStationsCall: APICall {
    typealias ResponseType = [RadioStationModel]

    let offset: Int
    let limit: Int

    var request: APIRequest {
        .get(
            path: "stations",
            queryParameters: [
                "offset": "\(offset)",
                "limit": "\(limit)",
                "hidebroken": "true"
            ]
        )
    }
}
