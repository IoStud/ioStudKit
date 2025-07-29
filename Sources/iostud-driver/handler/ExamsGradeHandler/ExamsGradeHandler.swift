import Foundation

public class ExamsGradeHandler {
    private var ioStud: IoStud

    public init(ioStud: IoStud) {
        self.ioStud = ioStud
    }

    public func requestStudentExams() async throws -> [ExamGrade] {
        
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
        
        guard let jsonResponse = try? JSONDecoder().decode(ExamsGradeResponse.self, from: data) else {
            throw RequestError.jsonDecodingError
        }
        
        return examGradeConverter(response: jsonResponse.ritorno.esami)
    }
}

private func examGradeConverter(response: [ExamsGradeResponse.Esame]) -> [ExamGrade] {
    var exams: [ExamGrade] = []
    
    for exam in response {
        exams.append(ExamGrade(
            courseCode: exam.codiceInsegnamento,
            courseName: exam.descrizione,
            date: exam.data,
            cfu: Int(exam.cfu),
            ssd: exam.ssd,
            academicYear: exam.annoAcca,
            nominalGrade: exam.esito.valoreNominale,
            numericGrade: exam.esito.valoreNonNominale
        ))
    }

    return exams
}
