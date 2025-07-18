import Foundation

/// Protocol that defines a network call with request and expected response type
public protocol APICall {
    associatedtype ResponseType: Decodable & Sendable

    var request: APIRequest { get }
}
