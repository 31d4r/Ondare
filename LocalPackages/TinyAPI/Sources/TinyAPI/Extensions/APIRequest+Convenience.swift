import Foundation

public extension APIRequest {
    /// Create a GET request
    static func get(
        path: String,
        queryParameters: [String: String]? = nil,
        headers: [String: String]? = nil
    ) -> APIRequest {
        APIRequest(method: .get, path: path, queryParameters: queryParameters, headers: headers)
    }

    /// Create a POST request with JSON body
    static func postJSON<T: Encodable>(
        path: String,
        body: T,
        queryParameters: [String: String]? = nil,
        headers: [String: String]? = nil,
        encoder: JSONEncoder = JSONEncoder()
    ) throws -> APIRequest {
        let jsonData = try encoder.encode(body)
        return APIRequest(
            method: .post,
            path: path,
            queryParameters: queryParameters,
            headers: headers,
            body: .json(jsonData)
        )
    }

    /// Create a POST request with multipart body
    static func postMultipart(
        path: String,
        parts: [MultipartFormData],
        queryParameters: [String: String]? = nil,
        headers: [String: String]? = nil
    ) -> APIRequest {
        APIRequest(
            method: .post,
            path: path,
            queryParameters: queryParameters,
            headers: headers,
            body: .multipart(parts)
        )
    }
}
