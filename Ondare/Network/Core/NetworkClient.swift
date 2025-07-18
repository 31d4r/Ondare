//
//  NetworkClient.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import Foundation
import TinyAPI

// MARK: - Network Client

@MainActor
class NetworkClient {
    static let shared = NetworkClient()

    private let apiClient: APIClient

    init() {
        let config = RadioAPIConfiguration()
        self.apiClient = APIClient(configuration: config)
    }

    func execute<T: APICall>(_ call: T) async -> Result<
        T.ResponseType,
        APINetworkError
    > {
        await apiClient.execute(call)
    }
}
