public class IoStud {
    static let ENDPOINT_LOGIN = "https://www.studenti.uniroma1.it/authws/login/idm_ldap/iws"
    static let ENDPOINT_API   = "https://www.studenti.uniroma1.it/phoenixws"
    
    public let STUDENT_ID: String
    private let password: String
    
    lazy private var authenticationHandler =  AuthenticationHandler(ioStud: self, password: password)
    lazy private var examsHandler = ExamsHandler(ioStud: self)
    lazy private var studentBioHandler = StudentBioHandler(ioStud: self)
    lazy private var reservationsHandler = ReservationsHandler(ioStud: self)
    
    public init(studentID: String, studentPassword: String) {
        self.STUDENT_ID = studentID
        self.password = studentPassword
    }
    
    public func doLogin() async throws {
        try await authenticationHandler.login()
    }

    private func tryWithTokenRefresh<T> (
            task: @escaping () async throws -> T
        ) async throws -> T {
            
            let MAX_TRIES = 3
            var count = 0
            
            while count < MAX_TRIES {
                do {
                    if count > 0 {
                        try await doLogin()
                    }
                    return try await task()
                } catch RequestError.httpRequestError(code: 401) {  // 401 http error code is used for expired token
                    count += 1
                }
            }
            
            throw InfostudError.infostudNotWorking

            //Errors: RequestError.invalidURL
            //        RequestError.jsonDecodingError {
            //        RequestError.httpRequestError(let errCode)
            //        RequestError.infostudError(let info)
            //        AuthServerError.invalidUsername
            //        AuthServerError.invalidPassword
    }
    
    public func retrieveStudentBio() async throws -> StudentBio {
        try await tryWithTokenRefresh() {
            try await self.studentBioHandler.requestStudentBio()
        }
    }
    
    public func retrieveDoneExams() async throws -> [ExamDone] {
        try await tryWithTokenRefresh() {
            try await self.examsHandler.requestDoneExams()
        }
    }
    
    public func retrieveDoableExams() async throws -> [ExamDoable] {
        try await tryWithTokenRefresh() {
            try await self.examsHandler.requestDoableExams()
        }
    }
    
    public func retrieveActiveReservations() async throws -> [ActiveReservation] {
        try await tryWithTokenRefresh() {
            try await self.reservationsHandler.requestActiveReservations()
        }
    }
    
    public func retrieveAvailableReservations(for examDoable: ExamDoable) async throws -> [AvailableReservation] {
        try await tryWithTokenRefresh() {
            try await self.reservationsHandler.requestAvailableReservations(for: examDoable)
        }
    }
    
    public func insertReservation(for avRes: AvailableReservation, attendingMode: AvailableReservation.AttendingMode) async throws {
        try await tryWithTokenRefresh() {
            let response = try await self.reservationsHandler.insertReservationRequest(for: avRes, attendingMode: attendingMode)
            if let urlOpis = response.urlOpis {
                throw InfostudError.opisRequired(url: urlOpis)
            }
        }
    }
    
    public func deleteReservation(for acRes: ActiveReservation) async throws {
        try await tryWithTokenRefresh() {
            try await self.reservationsHandler.deleteReservationRequest(for: acRes)
        }
    }
    
    public func getSessionToken() -> String {
        return authenticationHandler.getToken()
    }
}
