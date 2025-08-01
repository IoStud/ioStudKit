public class IoStud {
    private let endpointLogin: String = "https://www.studenti.uniroma1.it/authws/login/idm_ldap/iws"
    private let endpointAPI: String = "https://www.studenti.uniroma1.it/phoenixws"
    private let userAgent: String = "Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0"
    
    private var studentID: String
    private var studentPwd: String
    private var sessionToken: String?
    private var studentBio: StudentBio?
    
    lazy private var authenticator = AuthenticationHandler(ioStud: self)
    lazy private var examsHandler = ExamsHandler(ioStud: self)
    lazy private var studentBioHandler = StudentBioHandler(ioStud: self)
    lazy private var reservationsHandler = ReservationsHandler(ioStud: self)
    
    public init(studentID: String, studentPwd: String) {
        self.studentID = studentID
        self.studentPwd = studentPwd
    }
    
    // TODO: rimuovere catch da refreshSessionToken() e retrieveStudentBio() e getire gli errori in doLogin()
    public func doLogin() async {
        await refreshSessionToken()
        await retrieveStudentBio()
    }
    
    // TODO: rimuovere catch fare throws
    public func refreshSessionToken() async {
        do {
            let response = try await authenticator.login()
            self.sessionToken = response.result.tokeniws
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
    public func retrieveStudentBio() async {
        do {
            studentBio = try await studentBioHandler.requestStudentBio()
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
            if response.urlOpis != nil {
                print("Do opis before reservation, url: \(response.urlOpis)")
            }
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
    }
    
    public func getStudentID() -> String {
        return self.studentID
    }
    
    public func getStudentPwd() -> String {
        return self.studentPwd
    }
    
    public func getSessionToken() throws -> String {
        if let sessionToken = self.sessionToken {
            return sessionToken
        } else {
            throw IoStudError.missingToken
        }
    }
    
    public func getStudentBio() throws -> StudentBio {
        if let studentBio = self.studentBio {
            return studentBio
        } else {
            throw IoStudError.missingStudentBio
        }
    }
    
    public func getEndpointLogin() -> String {
        return self.endpointLogin
    }
    
    public func getEndpointAPI() -> String {
        return self.endpointAPI
    }
    
    public func getUserAgent() -> String {
        return self.userAgent
    }
    
    public func setSessionToken(sessionToken: String) {
        self.sessionToken = sessionToken
    }
}

public enum IoStudError: Error {
    case missingToken, missingStudentBio
}
