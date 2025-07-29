import Foundation

public class ExamsHandler {
    private var ioStud: IoStud

    public init(ioStud: IoStud) {
        self.ioStud = ioStud
    }

    public func requestDoneExams() async throws -> [ExamDone] {
        
        guard let token = try? ioStud.getSessionToken() else {
            throw IoStudError.missingToken
        }
        
        let endpoint = "\(ioStud.getEndpointAPI())/studente/\(ioStud.getStudentID())/esamiall?ingresso=\(token)"
        
        guard let url = URL(string: endpoint) else {
            throw RequestError.invalidURL(url: endpoint)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(ioStud.getUserAgent(), forHTTPHeaderField: "User-Agent")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw RequestError.invalidHTTPResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw RequestError.httpRequestError(code: httpResponse.statusCode)
        }
        
        guard let jsonResponse = try? JSONDecoder().decode(ExamsDoneResponse.self, from: data) else {
            throw RequestError.jsonDecodingError
        }
        
        return examsDoneConverter(from: jsonResponse.ritorno.esami)
    }
    
    public func requestDoableExams() async throws -> [ExamDoable] {
        
        guard let token = try? ioStud.getSessionToken() else {
            throw IoStudError.missingToken
        }
        
        let endpoint = "\(ioStud.getEndpointAPI())/studente/\(ioStud.getStudentID())/insegnamentisostenibili?ingresso=\(token)"
        
        guard let url = URL(string: endpoint) else {
            throw RequestError.invalidURL(url: endpoint)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(ioStud.getUserAgent(), forHTTPHeaderField: "User-Agent")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw RequestError.invalidHTTPResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw RequestError.httpRequestError(code: httpResponse.statusCode)
        }
        
        guard let jsonResponse = try? JSONDecoder().decode(ExamsDoableResponse.self, from: data) else {
            throw RequestError.jsonDecodingError
        }
        
        return examsDoableConverter(from: jsonResponse.ritorno.esami)
    }
}
