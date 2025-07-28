import Foundation

// Forse questo non va più usato con le nuove richieste di login, ma solo su alcune per i dati
public func checkErrorFlag(from response: StudentBioResponse) throws {
    switch response.esito.flagEsito {
    case -6:
      // Qualcosa sul captcha
        throw InfostudRequestError.invalidHTTPResponse("Infostud is not working as intended")
    case -4:
        throw InfostudRequestError.invalidHTTPResponse("User is not enabled to use Infostud service")
    case -2:
        throw InfostudRequestError.invalidHTTPResponse("Password expired")
    case -1:
        throw InfostudRequestError.invalidHTTPResponse("Invalid credentials when refreshing token")
    case 0:
        break
    default:
        throw InfostudRequestError.invalidHTTPResponse("Infostud is not working as intended")
    }
}

public func checkErrorValue(from response: AuthResponse) throws {
    switch response.error.code {
    case "auth110":
        throw InfostudRequestError.invalidHTTPResponse("Invalid credentials when refreshing token")
    case "auth151":
        throw InfostudRequestError.invalidHTTPResponse("User is not enabled to use Infostud service")
    case "auth500":
        throw InfostudRequestError.invalidHTTPResponse("Infostud is not working as intended")
    case "0":
        break
    default:
        throw InfostudRequestError.invalidHTTPResponse("Infostud is not working as expected")
    }
    
    // If tokeniws is empty: errore
}
