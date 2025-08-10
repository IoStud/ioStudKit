public class IoStud {
    public static let ENDPOINT_LOGIN = "https://www.studenti.uniroma1.it/authws/login/idm_ldap/iws"
    public static let ENDPOINT_API   = "https://www.studenti.uniroma1.it/phoenixws"
    private let MAX_TRIES = 3
    
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

    // TODO: rimuovere catch fare throws
    public func refreshSessionToken() async {
        do {
            try await authenticationHandler.login()
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
        } catch IoStudError.invalidPassword {
            print("Invalid password")
        } catch IoStudError.invalidUsername {
            print("Invalid user name")
        } catch {
            print("Unexpected error from login")
        }
    }

    // TODO: Remove catch, optional and request name. Only for testing
    private func tryWithTokenRefresh<T> (
        requestName: String,
        task: @escaping () async throws -> T
    ) async -> T? {
        var count = 0
        while true {
            do {
                if count > 0 {
                    await refreshSessionToken()
                }
                return try await task()
            } catch RequestError.httpRequestError(code: 401) {
                count += 1
                if count == MAX_TRIES {
                    print("Infostud not working")
                    break
                }
            } catch RequestError.invalidURL {
                print("Invalid URL for \(requestName)")
                break
            } catch RequestError.jsonDecodingError {
                print("Invalid data from \(requestName) request")
                break
            } catch RequestError.httpRequestError(let errCode) {
                print("HTTP Request error in \(requestName), error code:\(errCode)")
                break
            } catch RequestError.infostudError(let info) {
                print("Invalid infostud response for \(requestName) request, message: \(info)")
                break
            } catch {
                print("Unexpected error from \(requestName) request")
                break
            }
        }
        return nil
    }
    
    public func retrieveStudentBio() async throws -> StudentBio? {
        await tryWithTokenRefresh(requestName: "StudentBio") {
            try await self.studentBioHandler.requestStudentBio()
        }
    }
    
    // TODO: Controllare che ci sia il token / ancora valido
    public func retrieveDoneExams() async throws -> [ExamDone]? {
        await tryWithTokenRefresh(requestName: "DoneExams") {
            try await self.examsHandler.requestDoneExams()
        }
    }
    
    // TODO: Controllare che ci sia il token / ancora valido
    public func retrieveDoableExams() async throws -> [ExamDoable]? {
        await tryWithTokenRefresh(requestName: "DoableExams") {
            try await self.examsHandler.requestDoableExams()
        }
    }
    
    public func retrieveActiveReservations() async throws -> [ActiveReservation]? {
        await tryWithTokenRefresh(requestName: "ActiveReservations") {
            try await self.reservationsHandler.requestActiveReservations()
        }
    }
    
    public func retrieveAvailableReservations(for examDoable: ExamDoable) async throws -> [AvailableReservation]? {
        await tryWithTokenRefresh(requestName: "AvailableReservations") {
            try await self.reservationsHandler.requestAvailableReservations(for: examDoable)
        }
    }
    
    public func insertReservation(for avRes: AvailableReservation, attendingMode: AvailableReservation.AttendingMode) async throws {
        await tryWithTokenRefresh(requestName: "InsertReservation") {
            let response = try await self.reservationsHandler.insertReservationRequest(for: avRes, attendingMode: attendingMode)
            if let urlOpis = response.urlOpis {
                print("Do opis before reservation, url: \(urlOpis)")
                throw IoStudError.opisRequired(url: urlOpis)
            }
        }
    }
    
    public func getSessionToken() -> String {
        return authenticationHandler.getToken()
    }
    
    //TODO: to remove before official release, used only for testing
    public func setSessionToken(token: String) {
        authenticationHandler.setSessionToken(token: token)
    }
}
