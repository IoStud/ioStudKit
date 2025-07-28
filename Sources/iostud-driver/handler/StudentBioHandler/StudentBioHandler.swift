import Foundation

public class StudentBioHandler {
    private let ioStud: IoStud
    
    init(ioStud: IoStud) {
        self.ioStud = ioStud
    }
    
    public func requestStudentBio() async throws -> StudentBio {
        guard let token = try? ioStud.getSessionToken() else {
            throw IoStudError.missingToken
        }
        
        let endpoint = "\(ioStud.getEndpointAPI())/studente/\(ioStud.getStudentID())?ingresso=\(token)"
        
        guard let url = URL(string: endpoint) else {
            throw InfostudRequestError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(ioStud.getUserAgent(), forHTTPHeaderField: "User-Agent")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw InfostudRequestError.invalidHTTPResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw InfostudRequestError.httpRequestError
        }
        
        guard let jsonResponse = try? JSONDecoder().decode(StudentBioResponse.self, from: data) else {
            throw InfostudRequestError.jsonDecodingError
        }
            
        return studentBioConverter(response: jsonResponse)
    }
    
    private func studentBioConverter(response: StudentBioResponse) -> StudentBio {
        let values = response.ritorno
        let student = StudentBio(
              cf: values.codiceFiscale,
              surname: values.cognome,
              name: values.nome,
              birthDay: values.dataDiNascita,
              placeOfBirth: values.luogoDiNascita,
              courseYear: values.annoCorso,
              firstEnrollment: values.primaIscr,
              lastEnrollment: values.ultIscr,
              faculty: values.facolta,
              courseName: values.nomeCorso,
              currentAcademicYear: values.annoAccaAtt,
              studentId: String(values.matricola),
              courseCode: values.codCorso,
              enrollmentType: values.tipoIscrizione,
              gender: values.sesso,
              degreeType: values.tipoLaurea,
              birthCountry: values.nazioneNascita,
              personalEmail: values.indiMail,
              totalCredits: values.creditiTotali,
              institutionalEmail: values.indiMailIstituzionale,
              academicYearOfCourse: values.annoAccaCors,
        )
        return student
    }
}
