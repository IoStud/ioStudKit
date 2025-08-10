import Foundation

public struct ActiveReservation{
    let codIdenVerb: Int
    let codAppe: Int
    let codCourseStud: String
    let descCourseStud: String
    let courseName: String
    let cfu: Int
    let channel: String
    let teacher: String
    let faculty: String
    let accYear: String
    let appealDate: String
    let notes: String?
    let prenotationNumber: Int
    let prenotationDate: String
    let didacticModuleInitials: String? // sigla modulo didattico è una stringa esampio 1015887 quindi il nome didacticModuleInitials è sbagliato
    let ssd: String
    let executionMode: String
}
