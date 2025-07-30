import Foundation
//import FoundationNetworking

public class ReservationsHandler {
    private var ioStud: IoStud

    public init(ioStud: IoStud) {
        self.ioStud = ioStud
    }

    public func requestAvailableReservations(for exam: ExamDoable, and student: StudentBio) async throws -> [Reservation] {
        
        guard let token = try? ioStud.getSessionToken() else {
            throw IoStudError.missingToken
        }
        
        let endpoint = "\(ioStud.getEndpointAPI())/appello/ricerca?ingresso=\(token)&tipoRicerca=4&criterio=\(exam.didacticModuleCode)&codiceCorso=\(exam.courseCode)&annoAccaAuto=\(student.academicYearOfCourse)"
        
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
        
        guard let jsonResponse = try? JSONDecoder().decode(ReservationResponse.self, from: data) else {
            throw RequestError.jsonDecodingError
        }
        
        return reservationConverter(from: jsonResponse)
    }
}
