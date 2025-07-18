# TinyAPI

[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%2015%2B%20|%20macOS%2012%2B%20|%20tvOS%2015%2B%20|%20watchOS%208%2B-blue.svg)](https://developer.apple.com/swift/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

TinyAPI is a lightweight, type-safe networking library for Swift that makes API calls simple and elegant. Built with modern Swift features including async/await, generics, and protocols.

## Features

- **Type-safe** API calls with compile-time checks
- **Async/await** support for modern Swift development
- **Multipart form data** support for file uploads
- **JSON encoding/decoding** with custom configurations
- **Generic architecture** - reusable across different projects
- **Error handling** with detailed error types
- **Configurable** base URLs, headers, and timeouts
- **Clean architecture** with protocol-oriented design
- **No external dependencies** - built with Foundation only

## Requirements

- iOS 15.0+ / macOS 12.0+ / tvOS 15.0+ / watchOS 8.0+
- Xcode 14.0+
- Swift 5.9+

## Installation

### Swift Package Manager

Add TinyAPI to your project using Xcode:

1. File → Add Package Dependencies
2. Enter the repository URL: `https://github.com/31d4r/TinyAPI.git`
3. Select the version you want to use

Or add it to your `Package.swift`:

```swift
dependencies: [
   .package(url: "https://github.com/31d4r/TinyAPI.git", from: "1.0.0")
]
```

## Quick Start

### 1. Configuration

```swift
import TinyAPI

let config = DefaultAPIConfiguration(
    baseURL: URL(string: "https://api.example.com/v1/")!,
    timeoutInterval: 30,
    defaultHeaders: [
        "Accept": "application/json",
        "Authorization": "Bearer your-token"
    ]
)

let apiClient = APIClient(configuration: config)
```

### 2. Define Your Models

```swift
struct User: Codable, Sendable {
    let id: Int
    let name: String
    let email: String
}

struct CreateUserRequest: Codable {
    let name: String
    let email: String
}
```

### 3. Create API Calls

```swift
struct FetchUsersCall: APICall {
    typealias ResponseType = [User]

    var request: APIRequest {
        .get(path: "users")
    }
}

struct CreateUserCall: APICall {
    typealias ResponseType = User

    let userData: CreateUserRequest

    var request: APIRequest {
        try! .postJSON(path: "users", body: userData)
    }
}
```

### 4. Execute Calls

```swift
@MainActor
class UserService {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchUsers() async -> Result<[User], APINetworkError> {
        await apiClient.execute(FetchUsersCall())
    }

    func createUser(name: String, email: String) async -> Result<User, APINetworkError> {
        let userData = CreateUserRequest(name: name, email: email)
        return await apiClient.execute(CreateUserCall(userData: userData))
    }
}
```

## Advanced Usage

### File Upload with Multipart

```swift
struct UploadAvatarCall: APICall {
    typealias ResponseType = UploadResponse

    let imageData: Data
    let userId: Int

    var request: APIRequest {
        let parts = [
            MultipartFormData.file(
                name: "avatar",
                data: imageData,
                filename: "avatar.jpg",
                mimeType: "image/jpeg"
            ),
            MultipartFormData.text(name: "user_id", value: "\(userId)")
        ]

        return .postMultipart(path: "users/avatar", parts: parts)
    }
}
```

### Custom Configuration

```swift
let customDecoder = JSONDecoder()
customDecoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)

let config = DefaultAPIConfiguration(
    baseURL: URL(string: "https://api.example.com/")!,
    timeoutInterval: 60,
    defaultHeaders: [
        "Accept": "application/json",
        "User-Agent": "MyApp/1.0"
    ],
    jsonDecoder: customDecoder
)
```

### Error Handling

```swift
let result = await apiClient.execute(FetchUsersCall())

switch result {
case .success(let users):
    print("Fetched \(users.count) users")
case .failure(let error):
    switch error {
    case .httpError(let statusCode):
        print("HTTP error: \(statusCode)")
    case .decodingError(let decodingError):
        print("Failed to decode response: \(decodingError)")
    case .networkError(let networkError):
        print("Network error: \(networkError)")
    case .invalidURL:
        print("Invalid URL")
    case .noData:
        print("No data received")
    case .invalidResponse:
        print("Invalid response")
    }
}
```

### Query Parameters

```swift
struct SearchUsersCall: APICall {
    typealias ResponseType = [User]

    let query: String
    let limit: Int

    var request: APIRequest {
        .get(
            path: "users/search",
            queryParameters: [
                "q": query,
                "limit": "\(limit)"
            ]
        )
    }
}
```

### Custom Headers

```swift
struct AuthenticatedCall: APICall {
    typealias ResponseType = UserProfile

    let authToken: String

    var request: APIRequest {
        .get(
            path: "profile",
            headers: [
                "Authorization": "Bearer \(authToken)"
            ]
        )
    }
}
```

## Architecture

TinyAPI follows a protocol-oriented architecture inspired by modern Swift best practices:

- **APICall** - Protocol defining a network request and expected response
- **APIClient** - Main class responsible for executing API calls
- **APIConfiguration** - Protocol for configuring client behavior
- **APIRequest** - Structure encapsulating request details
- **RequestBody** - Enum supporting different body types (JSON, multipart, etc.)

### This design promotes:

- Type safety at compile time
- Easy testing with mock configurations
- Separation of concerns
- Reusability across different projects

## Testing

TinyAPI is designed to be easily testable. You can create mock configurations for testing:

```swift
struct MockAPIConfiguration: APIConfiguration {
    let baseURL = URL(string: "https://mock.api.com")!
    let timeoutInterval: TimeInterval = 10
    let defaultHeaders: [String: String] = [:]
    let jsonDecoder = JSONDecoder()
}

let mockClient = APIClient(configuration: MockAPIConfiguration())
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Author

[31d4r - GitHub](https://github.com/31d4r)

## Acknowledgments

- Inspired by modern Swift networking patterns
- Built with ❤️ for the Swift community
