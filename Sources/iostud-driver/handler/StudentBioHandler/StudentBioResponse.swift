import Foundation

public struct StudentBioResponse: Codable {
    
    // TODO Filtrare ancora su solo cose necessarie o aggiungere altro
    public struct Ritorno: Codable {
        let codiceFiscale: String
        let cognome: String
        let nome: String
        let dataNascita: String
        let luogoDiNascita: String
        let annoCorso: String
        let primaIscr: String
        let ultIscr: String
        let facolta: String
        let nomeCorso: String
        let annoAccAtt: String
        let matricola: String
        let codCorso: String
        let tipoIscrizione: String
        let sesso: String
        let tipoLaurea: String?
        let provinciaDiNascita: String
        let nazioneDiNascita: String
        let comuneDiNascita: String
        let indiMail: String
        let creditiTotali: String
        let indiMailIstituzionale: String
        let annoAccaCors: String
        let cittadinanza: String
        let cittadinanzaEn: String
    }
    
    let ritorno: StudentBioResponse.Ritorno
}


