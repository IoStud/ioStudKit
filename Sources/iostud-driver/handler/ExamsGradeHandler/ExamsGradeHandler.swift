import Foundation

public class ExamsGradeHandler {
    private var ioStud: IoStud

    public init(ioStud: IoStud) {
        self.ioStud = ioStud
    }

    public func requestStudentExams() async throws -> ExamsGradeResponse {
        
        guard let token = try? ioStud.getSessionToken() else {
            throw IoStudError.missingToken
        }
        
        let endpoint = "\(ioStud.getEndpointAPI())/studente/\(ioStud.getStudentID())/esamiall?ingresso=\(token)"
        
        guard let url = URL(string: endpoint) else { throw ExamsGradeError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(ioStud.getUserAgent(), forHTTPHeaderField: "User-Agent")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw ExamsGradeError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(ExamsGradeResponse.self, from: data)
        } catch {
            throw ExamsGradeError.invalidData
        }
    }
}

public enum ExamsGradeError: Error {
    case invalidURL, invalidResponse, invalidData
}
