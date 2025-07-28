import Foundation

public struct AuthRequest: Codable {
    
    public struct Credentials: Codable {
        let user: String
        let passwd: String
    }
    
    let request: AuthRequest.Credentials
    let id: String
}
