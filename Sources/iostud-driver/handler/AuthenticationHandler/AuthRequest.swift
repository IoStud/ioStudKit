import Foundation

public struct AuthRequest: Codable {
    let request: Credentials
    let id: String
}

public struct Credentials: Codable {
    let user: String
    let passwd: String
}
