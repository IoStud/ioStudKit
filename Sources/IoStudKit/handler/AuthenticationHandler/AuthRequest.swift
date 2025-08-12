import Foundation

internal struct AuthRequest: Codable {
    
    struct Credentials: Codable {
        let user: String
        let passwd: String
    }
    
    let request: AuthRequest.Credentials
    let id: String
}
