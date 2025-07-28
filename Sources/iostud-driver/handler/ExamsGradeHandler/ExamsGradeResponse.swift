import Foundation

public struct ExamsGradeResponse: Codable {
    
    public struct Esito: Codable {
        let valoreNominale: String
        let valoreNonNominale: Int? // Optional because idoneity exam doesn't have a grade
    }
    
    public struct Esame: Codable {
        let codiceInsegnamento: String
        let descrizione: String // Name
        let data: String
        let esito: ExamsGradeResponse.Esito
        let cfu: Double
        let ssd: String
        let annoAcca: String
    }
    
    public struct Ritorno: Codable {
        let esami: [ExamsGradeResponse.Esame]
    }
    
    let ritorno: ExamsGradeResponse.Ritorno //TODO: Validate behavior for students with empty exam history
}
