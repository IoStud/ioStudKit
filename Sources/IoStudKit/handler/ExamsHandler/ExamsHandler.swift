import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

class ExamsHandler {
    private var ioStud: IoStud

    public init(ioStud: IoStud) {
        self.ioStud = ioStud
    }
    
    func requestDoneExams() async throws -> [ExamDone] {
        // Note: If no DoneExams are present, an empty array is returned
        
        let endpoint = "\(IoStud.ENDPOINT_API)/studente/\(ioStud.STUDENT_ID)/esamiall?ingresso=\(ioStud.getSessionToken())"
        
        let data = try await CallHelper.getRequest(for: endpoint)
        
        guard let jsonResponse = try? JSONDecoder().decode(ExamsDoneResponse.self, from: data) else {
            throw RequestError.jsonDecodingError
        }
        
        return examsDoneConverter(from: jsonResponse.ritorno.esami)
    }
    
    func requestDoableExams() async throws -> [ExamDoable] {
        // Note: If no DoableExams are present, an empty array is returned
        
        let endpoint = "\(IoStud.ENDPOINT_API)/studente/\(ioStud.STUDENT_ID)/insegnamentisostenibili?ingresso=\(ioStud.getSessionToken())"
        
        let data = try await CallHelper.getRequest(for: endpoint)
        
        guard let jsonResponse = try? JSONDecoder().decode(ExamsDoableResponse.self, from: data) else {
            throw RequestError.jsonDecodingError
        }
        
        return examsDoableConverter(from: jsonResponse.ritorno.esami)
    }
}
