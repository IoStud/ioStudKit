import Foundation

public struct AuthResponse: Codable {
    
    let error: AuthResponse.Error
    let result: AuthResponse.Result
    
    public struct Error: Codable {
        let httpcode: Int?
        let code: String?
        let message: String?
        let devMessage: String?
    }
    
    public struct Result: Codable {
        let token: String
        let tokeniws: String
    }
}
