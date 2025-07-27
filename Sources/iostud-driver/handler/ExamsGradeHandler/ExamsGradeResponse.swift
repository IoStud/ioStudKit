import Foundation

public struct ExamsGradeResponse: Codable {
    let ritorno: Ritorno?
}

public struct Ritorno: Codable {
    let esami: [Esame]
}

public struct Esame: Codable {
    let codiceInsegnamento: String
    let descrizione: String // Name
    let data: String
    let esito: Esito
    let cfu: Double
    let ssd: String
    let annoAcca: String
}

public struct Esito: Codable {
    let valoreNominale: String
    let valoreNonNominale: Int? // Optional because idoneity exam doesn't have a grade
}
