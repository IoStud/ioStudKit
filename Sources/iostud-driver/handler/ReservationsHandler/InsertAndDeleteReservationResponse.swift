import Foundation

internal struct InsertReservationResponse: Codable {
    
    let esito: InfostudRequestResultFlags
    let output: String
    let url: String?
    let urlOpis: String?
}
