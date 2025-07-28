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
        
        guard let url = URL(string: endpoint) else { throw StudentBioError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(ioStud.getUserAgent(), forHTTPHeaderField: "User-Agent")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw StudentBioError.invalidResponse
        }
        
        do {
            let jsonResponse = try JSONDecoder().decode(StudentBioResponse.self, from: data)
            return studentBioConverter(response: jsonResponse)
        } catch {
            throw StudentBioError.invalidData
        }
    }
    
    private func studentBioConverter(response: StudentBioResponse) -> StudentBio {
        let values = response.ritorno
        let student = StudentBio(
              cf: values.codiceFiscale,
              surname: values.cognome,
              name: values.nome,
              birthDay: values.dataNascita,
              placeOfBirth: values.luogoDiNascita,
              courseYear: values.annoCorso,
              firstEnrollment: values.primaIscr,
              lastEnrollment: values.ultIscr,
              faculty: values.facolta,
              courseName: values.nomeCorso,
              currentAcademicYear: values.annoAccAtt,
              studentId: values.matricola,
              courseCode: values.codCorso,
              enrollmentType: values.tipoIscrizione,
              gender: values.sesso,
              degreeType: values.tipoLaurea,
              birthProvince: values.provinciaDiNascita,
              birthCountry: values.nazioneDiNascita,
              birthTown: values.comuneDiNascita,
              personalEmail: values.indiMail,
              totalCredits: values.creditiTotali,
              institutionalEmail: values.indiMailIstituzionale,
              academicYearOfCourse: values.annoAccaCors,
              citizenship: values.cittadinanza,
              citizenshipEn: values.cittadinanzaEn
        )
        return student
    }
}

public enum StudentBioError: Error {
    case invalidResponse, invalidData, invalidURL
}
