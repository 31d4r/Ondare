import Foundation

/// Multipart form data structure
public struct MultipartFormData {
    public let name: String
    public let data: Data
    public let filename: String?
    public let mimeType: String?
    
    public init(name: String, data: Data, filename: String? = nil, mimeType: String? = nil) {
        self.name = name
        self.data = data
        self.filename = filename
        self.mimeType = mimeType
    }
    
    // Convenience initializers
    public static func text(name: String, value: String) -> MultipartFormData {
        MultipartFormData(
            name: name,
            data: value.data(using: .utf8) ?? Data(),
            mimeType: "text/plain"
        )
    }
    
    public static func file(name: String, data: Data, filename: String, mimeType: String) -> MultipartFormData {
        MultipartFormData(
            name: name,
            data: data,
            filename: filename,
            mimeType: mimeType
        )
    }
}
