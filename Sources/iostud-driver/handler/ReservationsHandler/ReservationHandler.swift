import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public class ReservationsHandler {
    private var ioStud: IoStud

    public init(ioStud: IoStud) {
        self.ioStud = ioStud
    }

public func requestAvailableReservations(for exam: ExamDoable) async throws -> [AvailableReservation] {
        // Note: If no AvailableReservations are present, an empty array is returned

        guard let token = try? ioStud.getSessionToken() else {
            throw IoStudError.missingToken
        }
        
        let endpoint = "\(ioStud.ENDPOINT_API)/appello/ricerca?ingresso=\(token)&codiceCorso=\(exam.courseCode)&criterio=\(exam.didacticModuleCode)&tipoRicerca=4"
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
        
        guard let jsonResponse = try? JSONDecoder().decode(ReservationResponse.self, from: data) else {
            throw RequestError.jsonDecodingError
        }
        
        return availableReservationConverter(from: jsonResponse)
    }

    public func requestActiveReservations() async throws -> [ActiveReservation]{
        // Note: If no ActiveReservations are present, an empty array is returned
        
        guard let token = try? ioStud.getSessionToken() else {
            throw IoStudError.missingToken
        }
        
        let endpoint = "\(ioStud.ENDPOINT_API)/studente/\(ioStud.STUDENT_ID)/prenotazioni?ingresso=\(token)"
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
        
        guard let jsonResponse = try? JSONDecoder().decode(ReservationResponse.self, from: data) else {
            throw RequestError.jsonDecodingError
        }
        
        return activeReservationConverter(from: jsonResponse)
    }

    public func insertReservationRequest(for avRes: AvailableReservation, attendingMode: AvailableReservation.AttendingMode) async throws -> InsertReservationResponse {
        guard let token = try? ioStud.getSessionToken() else {
            throw IoStudError.missingToken
        }
        
        if !avRes.AttendingModeList.contains(attendingMode) {
            print("errore, seleziona un attendingMode disponibile, per l'esame selezionato")
        }
        
        let endpoint = "\(ioStud.ENDPOINT_API)/prenotazione/\(avRes.codIdenVerb)/\(avRes.codAppe)/\(avRes.codCourseStud)/\(attendingMode.examTypeDescription)/?ingresso=\(token)"
        guard let url = URL(string: endpoint) else {
            throw RequestError.invalidURL(url: endpoint)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // set Content-Type to JSON body (even if empty)
        request.httpBody = Data() // empty body
        request.setValue(ioStud.USER_AGENT, forHTTPHeaderField: "User-Agent")
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw RequestError.invalidHTTPResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw RequestError.httpRequestError(code: httpResponse.statusCode)
        }
        
        guard let jsonResponse = try? JSONDecoder().decode(InsertReservationResponse.self, from: data) else {
            throw RequestError.jsonDecodingError
        }
        
        return jsonResponse
    }

    public func deleteReservation(for activeReservation: ActiveReservation) async throws {}
}
