import Foundation

public struct AuthResponse: Codable {
    let error: AuthResponseError
    let result: AuthResponseResult
}

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
