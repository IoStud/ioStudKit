import Foundation

public class AuthenticationHandler {
    private var ioStud: IoStud
    
    public init(ioStud: IoStud) {
        self.ioStud = ioStud
    }
    
    public func login() async throws -> AuthResponse {
        
        guard let endpointURL = URL(string: ioStud.getEndpointLogin()) else {
            throw InfostudRequestError.invalidURL
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
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw InfostudRequestError.invalidHTTPResponse("Invalid HTTP Response")
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw InfostudRequestError.httpRequestError(httpResponse.statusCode)
        }
        
        guard let jsonResponse = try? JSONDecoder().decode(AuthResponse.self, from: data) else {
            throw InfostudRequestError.jsonDecodingError
        }
        
        return jsonResponse
    }
}
