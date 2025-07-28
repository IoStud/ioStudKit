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
        } catch AuthError.invalidResponse {
            print("Invalid response from login portal")
        } catch AuthError.invalidURL {
            print("Invalid URL for login")
        } catch AuthError.invalidData {
            print("Invalid data from login request")
        } catch {
            print("Unexpected error from login")
        }
    }
    
    public func retrieveStudentBio() async -> StudentBio? {
        do {
            let studentBio = try await studentBioHandler.requestStudentBio()
            return studentBio
        } catch StudentBioError.invalidResponse {
            print("Invalid response from studentbio portal")
        } catch ExamsGradeError.invalidURL {
            print("Invalid URL for studentbio")
        } catch ExamsGradeError.invalidData {
            print("Invalid data from studentbio request")
        } catch {
            print("Unexpected error from studentbio request")
        }
        return nil
    }
    
    // TODO Controllare che ci sia il token / ancora valido
    public func retrieveExamsGrades() async -> [ExamGrade]? {
        do {
            return try await examsGradeHandler.requestStudentExams()

        } catch ExamsGradeError.invalidResponse {
            print("Invalid response from exam portal")
        } catch ExamsGradeError.invalidURL {
            print("Invalid URL for exam")
        } catch ExamsGradeError.invalidData {
            print("Invalid data from exams request")
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
