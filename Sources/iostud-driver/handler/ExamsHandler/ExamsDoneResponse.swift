import Foundation

internal struct ExamsDoneResponse: Codable {
    
    let esito: InfostudRequestResultFlags
    let ritorno: ExamsDoneResponse.Ritorno
    
    struct Ritorno: Codable {
        let esami: [ExamsDoneResponse.Esame]
    }
    
    struct Esame: Codable {
        let codiceInsegnamento: String
        let descrizione: String // Name Insegnamento
        let cfu: Double
        let ssd: String
        let data: String
        let esito: ExamsDoneResponse.EsitoEsame
        let annoAcca: String
    }
    
    struct EsitoEsame: Codable {
        let valoreNominale: String
        let valoreNonNominale: Int? // Optional because idoneity exam doesn't have a grade
    }
}

internal func examsDoneConverter(from response: [ExamsDoneResponse.Esame]) -> [ExamDone] {
    var exams: [ExamDone] = []
    
    for exam in response {
        exams.append(ExamDone(
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
