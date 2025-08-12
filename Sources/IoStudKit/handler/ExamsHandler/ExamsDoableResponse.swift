import Foundation

internal struct ExamsDoableResponse: Codable {
    
    let esito: InfostudRequestResultFlags
    let ritorno: ExamsDoableResponse.Ritorno
    
    struct Ritorno: Codable {
        let esami: [ExamsDoableResponse.Esame]
    }
    
    struct Esame: Codable {
        let codiceInsegnamento: String
        let codiceModuloDidattico: String
        let codiceCorsoInsegnamento: String
        let descrizione: String // Name Insegnamento
        let cfu: Double
        let ssd: String
    }
}

internal func examsDoableConverter(from response: [ExamsDoableResponse.Esame]) -> [ExamDoable] {
    var exams: [ExamDoable] = []
    
    for exam in response {
        exams.append(ExamDoable(
            courseCode: exam.codiceCorsoInsegnamento,
            didacticModuleCode: exam.codiceModuloDidattico,
            courseTeachingCode: exam.codiceInsegnamento,
            courseName: exam.descrizione,
            cfu: Int(exam.cfu),
            ssd: exam.ssd
        ))
    }

    return exams
}

