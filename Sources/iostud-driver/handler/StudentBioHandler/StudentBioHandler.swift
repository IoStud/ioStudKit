import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

internal class StudentBioHandler {
    private let ioStud: IoStud
    
    init(ioStud: IoStud) {
        self.ioStud = ioStud
    }
    
    internal func requestStudentBio() async throws -> StudentBio {
        
        let endpoint = "\(IoStud.ENDPOINT_API)/studente/\(ioStud.STUDENT_ID)?ingresso=\(ioStud.getSessionToken())"
        
        let data = try await CallHelper.getRequest(for: endpoint)
        
        guard let jsonResponse = try? JSONDecoder().decode(StudentBioResponse.self, from: data) else {
            throw RequestError.jsonDecodingError
        }
        
        return studentBioConverter(from: jsonResponse)
    }
}
