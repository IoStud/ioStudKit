import Foundation

internal struct AuthRequest: Encodable {
    
    struct Credentials: Encodable {
        let user: String
        let passwd: String
    }
    
    let request: AuthRequest.Credentials
    let id: String
}
