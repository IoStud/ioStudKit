public class IoStud {
    public let ENDPOINT_LOGIN: String = "https://www.studenti.uniroma1.it/authws/login/idm_ldap/iws"
    public let ENDPOINT_API: String = "https://www.studenti.uniroma1.it/phoenixws"
    public let USER_AGENT: String = "Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0"
    public let STUDENT_ID: String
    
    private let password: String
    
    lazy private var authenticationHandle =  AuthenticationHandler(ioStud: self, password: password)
    lazy private var examsHandler = ExamsHandler(ioStud: self)
    lazy private var studentBioHandler = StudentBioHandler(ioStud: self)
    lazy private var reservationsHandler = ReservationsHandler(ioStud: self)
    
    public init(studentID: String, studentPassword: String) {
        self.STUDENT_ID = studentID
        self.password = studentPassword
    }
    
    // TODO: rimuovere catch da refreshSessionToken() e retrieveStudentBio() e getire gli errori in doLogin()
    public func doLogin() async {
        await refreshSessionToken()
    }
    
    // TODO: rimuovere catch fare throws
    public func refreshSessionToken() async {
        do {
            try await authenticationHandle.login()
        } catch RequestError.invalidHTTPResponse {
            print("Invalid invalid HTTP Response for login")
        } catch RequestError.invalidURL {
            print("Invalid URL for login")
        } catch RequestError.jsonDecodingError {
            print("Invalid data from login request")
        } catch RequestError.httpRequestError(let errCode) {
            print("HTTP Request error, error code:\(errCode)")
        } catch RequestError.infostudError(let info){
            print("Invalid infostud response for login, message: \(info)")
        } catch {
            print("Unexpected error from login")
        }
    }
    
    // TODO: rimuovere catch fare throws
    public func retrieveStudentBio() async -> StudentBio? {
        do {
            return try await studentBioHandler.requestStudentBio()
        } catch RequestError.invalidHTTPResponse {
            print("Invalid HTTP response for student Bio")
        } catch RequestError.invalidURL {
            print("Invalid URL for studentbio")
        } catch RequestError.jsonDecodingError {
            print("Invalid data from studentbio request")
        } catch RequestError.httpRequestError(let errCode) {
            print("HTTP Request error, error code:\(errCode)")
        } catch RequestError.infostudError(let info){
            print("Invalid infostud response for student bio request, message: \(info)")
        } catch {
            print("Unexpected error from studentbio request")
        }
        return nil
    }
    
    // TODO: Controllare che ci sia il token / ancora valido
    public func retrieveDoneExams() async -> [ExamDone]? {
        do {
            return try await examsHandler.requestDoneExams()
        } catch RequestError.invalidHTTPResponse {
            print("Invalid HTTP request for done exams")
        } catch RequestError.invalidURL {
            print("Invalid URL for done exam")
        } catch RequestError.jsonDecodingError {
            print("Invalid data from done exams request")
        } catch RequestError.httpRequestError(let errCode) {
            print("HTTP Request error for done exams, error code:\(errCode)")
        } catch RequestError.infostudError(let info) {
            print("Invalid response from infostud for done exams request\nMessage error: \(info)")
        } catch {
            print("Unexpected error from done exams request")
        }
        return nil
    }
    
    // TODO: Controllare che ci sia il token / ancora valido
    public func retrieveDoableExams() async -> [ExamDoable]? {
        do {
            return try await examsHandler.requestDoableExams()
        } catch RequestError.invalidHTTPResponse {
            print("Invalid HTTP request for doable exams")
        } catch RequestError.invalidURL {
            print("Invalid URL for doable exams")
        } catch RequestError.jsonDecodingError {
            print("Invalid data from doable exams request")
        } catch RequestError.httpRequestError(let errCode) {
            print("HTTP Request error for doable exams, error code:\(errCode)")
        } catch RequestError.infostudError(let info) {
            print("Invalid response from infostud for doable exams request\nMessage error: \(info)")
        } catch {
            print("Unexpected error from doable exams request")
        }
        return nil
    }
    
    public func retrieveActiveReservations() async -> [ActiveReservation]? {
        do {
            return try await reservationsHandler.requestActiveReservations()
        } catch RequestError.invalidHTTPResponse {
            print("Invalid HTTP response for active reservations")
        } catch RequestError.invalidURL {
            print("Invalid URL for active reservations")
        } catch RequestError.jsonDecodingError {
            print("Invalid data from active reservations request")
        } catch RequestError.httpRequestError(let errCode) {
            print("HTTP Request error, error code:\(errCode)")
        } catch RequestError.infostudError(let info){
            print("Invalid infostud response for active reservations request, message: \(info)")
        } catch {
            print("Unexpected error from active reservations request")
        }
        return nil
    }
    
    public func retrieveAvailableReservations(for examDoable: ExamDoable) async -> [AvailableReservation]? {
        do {
            return try await reservationsHandler.requestAvailableReservations(for: examDoable)
        } catch RequestError.invalidHTTPResponse {
            print("Invalid HTTP response for available reservations")
        } catch RequestError.invalidURL {
            print("Invalid URL for available reservations")
        } catch RequestError.jsonDecodingError {
            print("Invalid data from available reservations request")
        } catch RequestError.httpRequestError(let errCode) {
            print("HTTP Request error, error code:\(errCode)")
        } catch RequestError.infostudError(let info){
            print("Invalid infostud response for available reservations request, message: \(info)")
        } catch {
            print("Unexpected error from available reservations request")
        }
        return nil
    }
    
    public func insertReservation(for avRes: AvailableReservation, attendingMode: AvailableReservation.AttendingMode) async {
        do {
            let response = try await reservationsHandler.insertReservationRequest(for: avRes, attendingMode: attendingMode)
            if let urlOpis = response.urlOpis {
                print("Do opis before reservation, url: \(urlOpis)")
            }
        } catch RequestError.invalidHTTPResponse {
            print("Invalid HTTP response for insert reservation")
            
        } catch RequestError.invalidURL {
            print("Invalid URL for insert reservation")
        } catch RequestError.jsonDecodingError {
            print("Invalid data from insert reservation request")
        } catch RequestError.httpRequestError(let errCode) {
            print("HTTP Request error, error code:\(errCode)")
        } catch RequestError.infostudError(let info){
            print("Invalid infostud response for insert reservation request, message: \(info)")
        } catch {
            print("Unexpected error from insert reservation request")
        }
    }
    
    public func getSessionToken() throws -> String {
        do {
            return try authenticationHandle.getToken()
        } catch IoStudError.missingToken {
            throw IoStudError.missingToken
        }
    }
    
    //TODO: to remove before official release, used only for testing
    public func setSessionToken(token: String) {
        authenticationHandle.setSessionToken(token: token)
    }
}

public enum IoStudError: Error {
    case missingToken
}
