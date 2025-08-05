import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public class AuthenticationHandler {
    private let ioStud: IoStud
    private var password: String
    private var token: String?
    
    public init(ioStud: IoStud, password: String) {
        self.ioStud = ioStud
        self.password = password
    }
    
    public func login() async throws {
        let endpoint = ioStud.ENDPOINT_LOGIN
        
        guard let endpointURL = URL(string: endpoint) else {
            throw RequestError.invalidURL(url: endpoint)
        }
        
        let loginData = AuthRequest (
            request: .init(user: ioStud.STUDENT_ID, passwd: password),
            id: "1"
        )
        
        let jsonData = try JSONEncoder().encode(loginData)
        
        var request = URLRequest(url: endpointURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(ioStud.USER_AGENT, forHTTPHeaderField: "User-Agent")
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw RequestError.invalidHTTPResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw RequestError.httpRequestError(code: httpResponse.statusCode)
        }

        guard !(401 == httpResponse.statusCode) else {
            throw IoStudError.passwordInvalid
        }
        
        guard let authResponse = try? JSONDecoder().decode(AuthResponse.self, from: data) else {
            throw RequestError.jsonDecodingError
        }

        switch authResponse.error.code {
            case "auth110", "auth500":
                throw RequestError.infostudError(info: "Infostud is not working as intended")
            case "auth151":
                throw RequestError.infostudError(info: "User is not enabled to use Infostud service") 
            case "0":
                break
            default:
                throw RequestError.infostudError(info: "Infostud is not working as expected")
        }
        
        self.token = authResponse.result.tokeniws
    }
    
    public func getToken() throws -> String{
        if let currentToken = token {
            return currentToken
        } 
        throw IoStudError.missingToken
    }
    
    //TODO: to remove before official release, used only for testing
    public func setSessionToken(token: String) {
        self.token = token
    }
}
