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
        
        guard let url = URL(string: endpoint) else { throw ExamsGradeError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(ioStud.getUserAgent(), forHTTPHeaderField: "User-Agent")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw ExamsGradeError.invalidResponse
        }
        
        do {
            let jsonResponse = try JSONDecoder().decode(ExamsGradeResponse.self, from: data)
            return examGradeConverter(response: jsonResponse.ritorno.esami)
        } catch {
            throw ExamsGradeError.invalidData
        }
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

public enum ExamsGradeError: Error {
    case invalidURL, invalidResponse, invalidData
}
