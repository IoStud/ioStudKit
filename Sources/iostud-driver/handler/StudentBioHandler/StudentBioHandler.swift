import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public class StudentBioHandler {
    private let ioStud: IoStud
    
    init(ioStud: IoStud) {
        self.ioStud = ioStud
    }
    
    public func requestStudentBio() async throws -> StudentBio {
        guard let token = try? ioStud.getSessionToken() else {
            throw IoStudError.missingToken
        }
        
        let endpoint = "\(ioStud.ENDPOINT_API)/studente/\(ioStud.STUDENT_ID)?ingresso=\(token)"
        
        guard let url = URL(string: endpoint) else {
            throw RequestError.invalidURL(url: endpoint)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(ioStud.USER_AGENT, forHTTPHeaderField: "User-Agent")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw RequestError.invalidHTTPResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw RequestError.httpRequestError(code: httpResponse.statusCode)
        }
        
        guard let jsonResponse = try? JSONDecoder().decode(StudentBioResponse.self, from: data) else {
            throw RequestError.jsonDecodingError
        }
        
        return studentBioConverter(from: jsonResponse)
    }
}
