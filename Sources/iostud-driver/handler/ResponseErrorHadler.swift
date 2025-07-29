import Foundation

// To be used in StudentBioHandler and ExamGradeHandler
public func checkErrorFlag(from response: StudentBioResponse) throws {
    switch response.esito.flagEsito {
    case -6:
      // Qualcosa sul captcha
        throw RequestError.infostudError(info: "Infostud is not working as intended")
    case -4:
        throw RequestError.infostudError(info: "User is not enabled to use Infostud service")
    case -2:
        throw RequestError.infostudError(info: "Password expired")
    case -1:
        throw RequestError.infostudError(info: "Invalid credentials when refreshing token")
    case 0:
        break
    default:
        throw RequestError.infostudError(info: "Infostud is not working as intended")
    }
}

// To be used in LoginHandler
public func checkErrorValue(from response: AuthResponse) throws {
    switch response.error.code {
    case "auth110":
        throw RequestError.infostudError(info: "Invalid credentials when refreshing token")
    case "auth151":
        throw RequestError.infostudError(info: "User is not enabled to use Infostud service")
    case "auth500":
        throw RequestError.infostudError(info: "Infostud is not working as intended")
    case "0":
        break
    default:
        throw RequestError.infostudError(info: "Infostud is not working as expected")
    }
    
    // If tokeniws is empty: errore
}
