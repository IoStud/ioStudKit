import Foundation

public class AuthenticationHandler {
    private var ioStud: IoStud
    
    public init(ioStud: IoStud) {
        self.ioStud = ioStud
    }
    
    public func login() async throws -> AuthResponse {
        let endpoint = self.ioStud.getEndpointLogin()
        guard let endpointURL = URL(string: endpoint) else {
            throw AuthError.invalidURL
        }
        
        let loginData = AuthRequest (
            request: .init(user: ioStud.getStudentID(), passwd: ioStud.getStudentPwd()),
            id: "1"
        )
        
        let jsonData = try JSONEncoder().encode(loginData)
        
        var request = URLRequest(url: endpointURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(ioStud.getUserAgent(), forHTTPHeaderField: "User-Agent")
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // TODO Gestire codici errori
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw AuthError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(AuthResponse.self, from: data)
        } catch {
            throw AuthError.invalidData
        }
    }
}

public enum AuthError: Error {
    case invalidURL, invalidResponse, invalidData
}

