import Foundation

internal struct ReservationResponse: Codable {

    let esito: InfostudRequestResultFlags
    let ritorno: ReservationResponse.Ritorno

    struct Ritorno: Codable {
        let appelli: [Prenotazione]
    }

    struct Prenotazione: Codable {
        let codIdenVerb: Int
        let codAppe: Int
        //let tipoPren: ANKNOWN?            //never used + unknown data type (Sting uded as a filler)
        let codCorsoStud: String
        let descCorsoStud: String
        let descrizione: String
        let crediti: Int
        let canale: String
        let docente: String
        let facolta: String
        let annoAcca: String
        let dataAppe: String?
        let note: String
        let numeroPrenotazione: Int?
        let dataprenotazione: String?
        let dataInizioPrenotazione: String?
        let dataFinePrenotazione: String?
        //let dataSeduta: String?           //never used
        //let insegnamentoAuto: String?     //never used + unknown data type (Sting uded as a filler)
        //let tipologiaAuto: String?        //never used + unknown data type (Sting uded as a filler)
        //let questionario: Bool            //never used + unknown if it's optional or not
        //let annualita: String?            //never used + unknown data type (Sting uded as a filler)
        let SiglaModuloDidattico: String?
        let ssd: String?
        //let diviSeduta: String?           //never used
        //let noteCalendario: String?       //never used
        //let noteTurno: String?            //never used
        //let noteTurnoStud: String?        //never used
        let modalitaSvolgimento: String?
        let modalitaSvolgimentoList: [ModalitaSvolgimento]?
    }
    
    struct ModalitaSvolgimento: Codable {
        let tipoEsame : String
        let descrizioneTipoEsame : String
    }
}

internal func availableReservationConverter(from response: ReservationResponse) -> [AvailableReservation] {
    var reservations = [AvailableReservation]()
    for pren in response.ritorno.appelli {
        
        var attendingModeList = [AvailableReservation.AttendingMode]()
        let modList = pren.modalitaSvolgimentoList ?? []
        for mod in modList {
            attendingModeList.append(AvailableReservation.AttendingMode(examType: mod.tipoEsame, examTypeDescription:mod.descrizioneTipoEsame))
        }
        
        reservations.append(AvailableReservation(
                codIdenVerb: pren.codIdenVerb,
                codAppe: pren.codAppe,
                codCourseStud: pren.codCorsoStud,
                descCourseStud: pren.descCorsoStud,
                courseName: pren.descrizione,
                cfu: pren.crediti,
                channel: pren.canale,
                teacher: pren.docente,
                faculty: pren.facolta,
                accYear: pren.annoAcca,
                appealDate: pren.dataAppe ?? "",
                notes: pren.note,
                startDatePrenotation: pren.dataInizioPrenotazione ?? "",
                endDatePrenotatation: pren.dataFinePrenotazione ?? "",
                didacticModuleCode: pren.SiglaModuloDidattico,
                AttendingModeList: attendingModeList
            )
        )
    }
    return reservations
}

internal func activeReservationConverter(from response: ReservationResponse) -> [ActiveReservation] {
    var reservations = [ActiveReservation]()
    for pren in response.ritorno.appelli {
        reservations.append(ActiveReservation(
                codIdenVerb: pren.codIdenVerb,
                codAppe: pren.codAppe,
                codCourseStud: pren.descCorsoStud,
                descCourseStud: pren.descCorsoStud,
                courseName: pren.descrizione,
                cfu: pren.crediti,
                channel: pren.canale,
                teacher: pren.docente,
                faculty: pren.facolta,
                accYear: pren.annoAcca,
                appealDate: pren.dataAppe ?? "",
                notes: pren.note,
                prenotationNumber: pren.numeroPrenotazione ?? -1,
                prenotationDate: pren.dataprenotazione ?? "",
                didacticModuleInitials: pren.SiglaModuloDidattico ?? "",
                ssd: pren.ssd ?? "",
                executionMode: pren.modalitaSvolgimento ?? ""
            )
        )
    }
    return reservations
}
