import Foundation

public struct ReservationResponse: Codable {

    let esito: InfostudRequestResultFlags
    let ritorno: ReservationResponse.Ritorno

    struct Ritorno: Codable {
        let prenotazioni: [Prenotazione]
    }

    struct Prenotazione: Codable {
        let codIdenVerb: Int
        let canale: String
        let codAppe: Int
        let codCorsoStud: String
        let descrizione: String
        let descCorsoStud: String
        let crediti: Int
        let docente: String
        let annoAcca: String
        let facolta: String
        let numeroPrenotazione: Int?
        let ssd: String?
        let dataprenotazione: String?
        let note: String
        let dataAppe: String?
        let dataInizioPrenotazione: String?
        let dataFinePrenotazione: String?
        let SiglaModuloDidattico: String?
        //let modalitaSvolgimentoList: JSONARRAY (?)
        let modalitaSvolgimento: String
    }
}

public func reservationConverter(from response: ReservationResponse) -> [Reservation] {
    let values = response.ritorno.prenotazioni
    var reservations = [Reservation]()
    for response in values {
        let reservation = Reservation (
            codIdenVerb: response.codIdenVerb,
            channel: response.canale,
            codAppe: response.codAppe,
            codCourseStud: response.codCorsoStud,
            description: response.descrizione,
            descCourseStud: response.descCorsoStud,
            cfu: response.crediti,
            teacher: response.docente,
            accYear: response.annoAcca,
            faculty: response.facolta,
            prenotationNumber: response.numeroPrenotazione,
            ssd: response.ssd,
            prenotationDate: response.dataprenotazione,
            notes: response.note,
            appeDate: response.dataAppe,
            startDatePrenotation: response.dataInizioPrenotazione,
            endDatePrenotatation: response.dataFinePrenotazione,
            didacticModuleInitials: response.SiglaModuloDidattico,
            executionMode: response.modalitaSvolgimento
        )
        reservations.append(reservation)
    }
    
    return reservations
}