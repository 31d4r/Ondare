import Foundation

/// Protocol for configuring API client behavior
public protocol APIConfiguration {
    var baseURL: URL { get }
    var timeoutInterval: TimeInterval { get }
    var defaultHeaders: [String: String] { get }
    var jsonDecoder: JSONDecoder { get }
}

/// Default API configuration
public struct DefaultAPIConfiguration: APIConfiguration {
    public let baseURL: URL
    public let timeoutInterval: TimeInterval
    public let defaultHeaders: [String: String]
    public let jsonDecoder: JSONDecoder

    public init(
        baseURL: URL,
        timeoutInterval: TimeInterval = 30,
        defaultHeaders: [String: String] = [
            "Accept": "application/json"
        ],
        jsonDecoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return decoder
        }()
    ) {
        self.baseURL = baseURL
        self.timeoutInterval = timeoutInterval
        self.defaultHeaders = defaultHeaders
        self.jsonDecoder = jsonDecoder
    }
}
