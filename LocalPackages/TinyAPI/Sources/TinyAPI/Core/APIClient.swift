import Foundation

@MainActor
public final class APIClient {
    private let configuration: APIConfiguration
    private let session: URLSession
    
    public init(configuration: APIConfiguration, session: URLSession = .shared) {
        self.configuration = configuration
        self.session = session
    }
    
    public func execute<T: APICall>(_ call: T) async -> Result<T.ResponseType, APINetworkError> {
        do {
            let urlRequest = try buildURLRequest(from: call.request)
            let (data, response) = try await session.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.invalidResponse)
            }
            
            guard 200 ... 299 ~= httpResponse.statusCode else {
                return .failure(.httpError(httpResponse.statusCode))
            }
            
            let decoded = try configuration.jsonDecoder.decode(T.ResponseType.self, from: data)
            return .success(decoded)
            
        } catch let decodingError as DecodingError {
            return .failure(.decodingError(decodingError))
        } catch {
            return .failure(.networkError(error))
        }
    }
    
    private func buildURLRequest(from request: APIRequest) throws -> URLRequest {
        guard var urlComponents = URLComponents(url: configuration.baseURL.appendingPathComponent(request.path), resolvingAgainstBaseURL: true) else {
            throw APINetworkError.invalidURL
        }
        
        // Add query parameters
        if let queryParameters = request.queryParameters {
            urlComponents.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = urlComponents.url else {
            throw APINetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.timeoutInterval = configuration.timeoutInterval
        
        // Set default headers
        for (key, value) in configuration.defaultHeaders {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        // Set custom headers
        if let headers = request.headers {
            for (key, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Set body and content type
        if let body = request.body {
            urlRequest.httpBody = body.data
            urlRequest.setValue(body.contentType, forHTTPHeaderField: "Content-Type")
        }
        
        return urlRequest
    }
}
