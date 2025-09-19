import Foundation

internal struct AuthResponse: Decodable {
    
    let error: AuthResponse.Error
    let result: AuthResponse.Result
    
    struct Error: Decodable {
        let httpcode: Int?
        let code: String?
        let message: String?
        let devMessage: String?
    }
    
    struct Result: Decodable {
        let token: String
        let tokeniws: String
    }
}
