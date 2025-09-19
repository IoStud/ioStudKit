import Foundation

struct InsertReservationResponse: Decodable {
    
    let esito: InfostudRequestResultFlags
    let output: String
    let url: String?
    let urlOpis: String?
}

struct DeleteReservationResponse: Decodable {
    
    let esito: InfostudRequestResultFlags
    let output: String
}
