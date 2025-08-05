import Foundation

public struct StudentBioResponse: Codable {
    
    let esito: InfostudRequestResultFlags
    let ritorno: StudentBioResponse.Ritorno
    
    public struct Ritorno: Codable {
        let codiceFiscale: String
        let cognome: String
        let nome: String
        let dataDiNascita: String
        let luogoDiNascita: String
        let annoCorso: String
        let primaIscr: String
        let ultIscr: String
        let facolta: String
        let nomeCorso: String
        let annoAccaAtt: String
        let matricola: Int
        let codCorso: String
        let tipoIscrizione: String
        let sesso: String
        let tipoLaurea: String?
        let nazioneNascita: String
        let indiMail: String
        let creditiTotali: String
        let indiMailIstituzionale: String
        let annoAccaCors: String
    }
}

public func studentBioConverter(from response: StudentBioResponse) -> StudentBio {
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
