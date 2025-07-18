import Foundation

/// Request body types
public enum RequestBody {
    case json(Data)
    case formData([String: String])
    case multipart([MultipartFormData])
    case raw(Data)
    
    var data: Data {
        switch self {
        case .json(let data), .raw(let data):
            return data
        case .formData(let params):
            return params.map { "\($0.key)=\($0.value)" }
                .joined(separator: "&")
                .data(using: .utf8) ?? Data()
        case .multipart(let parts):
            return createMultipartBody(parts: parts)
        }
    }
    
    var contentType: String {
        switch self {
        case .json:
            return "application/json"
        case .formData:
            return "application/x-www-form-urlencoded"
        case .multipart:
            return "multipart/form-data; boundary=\(multipartBoundary)"
        case .raw:
            return "application/octet-stream"
        }
    }
    
    private func createMultipartBody(parts: [MultipartFormData]) -> Data {
        var body = Data()
        
        for part in parts {
            body.append("--\(multipartBoundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(part.name)\"".data(using: .utf8)!)
            
            if let filename = part.filename {
                body.append("; filename=\"\(filename)\"".data(using: .utf8)!)
            }
            
            body.append("\r\n".data(using: .utf8)!)
            
            if let mimeType = part.mimeType {
                body.append("Content-Type: \(mimeType)\r\n".data(using: .utf8)!)
            }
            
            body.append("\r\n".data(using: .utf8)!)
            body.append(part.data)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(multipartBoundary)--\r\n".data(using: .utf8)!)
        return body
    }
    
    private var multipartBoundary: String {
        "Boundary-\(UUID().uuidString)"
    }
}
