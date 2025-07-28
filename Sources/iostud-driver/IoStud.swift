public class IoStud {
    private let endpointLogin: String = "https://www.studenti.uniroma1.it/authws/login/idm_ldap/iws"
    private let endpointAPI: String = "https://www.studenti.uniroma1.it/phoenixws"
    private let userAgent: String = "Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0"
    
    private var studentID: String
    private var studentPwd: String
    private var sessionToken: String?
    
    lazy private var authenticator = AuthenticationHandler(ioStud: self)
    lazy private var examsGradeHandler = ExamsGradeHandler(ioStud: self)
    lazy private var studentBioHandler = StudentBioHandler(ioStud: self)
    
    public init(studentID: String, studentPwd: String) {
        self.studentID = studentID
        self.studentPwd = studentPwd
    }
    
    public func doLogin() async {
        do {
            let loginResponse = try await authenticator.login()
            self.sessionToken = loginResponse.result.tokeniws
        } catch InfostudRequestError.invalidHTTPResponse {
            print("Invalid response from login portal")
        } catch InfostudRequestError.invalidURL {
            print("Invalid URL for login")
        } catch InfostudRequestError.jsonDecodingError {
            print("Invalid data from login request")
        /*} catch InfostudRequestError.httpRequestError(error: Int) {
            print("HTTP Request error, error code:\(error)")*/
        } catch {
            print("Unexpected error from login")
        }
    }
    
    public func retrieveStudentBio() async -> StudentBio? {
        do {
            let studentBio = try await studentBioHandler.requestStudentBio()
            return studentBio
        } catch InfostudRequestError.invalidHTTPResponse {
            print("Invalid response from studentbio portal")
        } catch InfostudRequestError.invalidURL {
            print("Invalid URL for studentbio")
        } catch InfostudRequestError.jsonDecodingError {
            print("Invalid data from studentbio request")
        /*} catch InfostudRequestError.httpRequestError(error: Int) {
            print("HTTP Request error, error code:\(error)")*/
        } catch {
            print("Unexpected error from studentbio request")
        }
        return nil
    }
    
    // TODO Controllare che ci sia il token / ancora valido
    public func retrieveExamsGrades() async -> [ExamGrade]? {
        do {
            return try await examsGradeHandler.requestStudentExams()

        } catch InfostudRequestError.invalidHTTPResponse {
            print("Invalid response from exam portal")
        } catch InfostudRequestError.invalidURL {
            print("Invalid URL for exam")
        } catch InfostudRequestError.jsonDecodingError {
            print("Invalid data from exams request")
        /*} catch InfostudRequestError.httpRequestError(error: Int) {
            print("HTTP Request error, error code:\(error)")*/
        } catch {
            print("Unexpected error from exams request")
        }
        return nil
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
    
    public func getEndpointLogin() -> String {
        return self.endpointLogin
    }
    
    public func getEndpointAPI() -> String {
        return self.endpointAPI
    }
    
    public func getUserAgent() -> String {
        return self.userAgent
    }
}

public enum IoStudError: Error {
    case missingToken
}
