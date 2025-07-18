import Foundation

/// API Request structure
public struct APIRequest {
    public let method: HTTPMethod
    public let path: String
    public let queryParameters: [String: String]?
    public let headers: [String: String]?
    public let body: RequestBody?

    public init(
        method: HTTPMethod = .get,
        path: String,
        queryParameters: [String: String]? = nil,
        headers: [String: String]? = nil,
        body: RequestBody? = nil
    ) {
        self.method = method
        self.path = path
        self.queryParameters = queryParameters
        self.headers = headers
        self.body = body
    }
}
