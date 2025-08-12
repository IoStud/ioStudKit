import Foundation

internal struct AuthResponse: Codable {
    
    let error: AuthResponse.Error
    let result: AuthResponse.Result
    
    struct Error: Codable {
        let httpcode: Int?
        let code: String?
        let message: String?
        let devMessage: String?
    }
    
    struct Result: Codable {
        let token: String
        let tokeniws: String
    }
}
