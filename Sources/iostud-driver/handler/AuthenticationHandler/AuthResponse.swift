import Foundation

public struct AuthResponse: Codable {
    
    public struct AuthResponseError: Codable {
        let httpcode: Int?
        let code: String?
        let message: String?
        let devMessage: String?
    }
    
    public struct AuthResponseResult: Codable {
        let token: String
        let tokeniws: String
    }
    
    let error: AuthResponse.AuthResponseError
    let result: AuthResponse.AuthResponseResult
}
