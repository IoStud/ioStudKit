import Foundation

public enum RequestError: Error {
    case invalidURL(url: String)
    case invalidHTTPResponse
    case httpRequestError(code: Int)
    case jsonDecodingError
    case infostudError(info: String)
}

public enum AuthServerError: Error {
    case invalidUsername
    case invalidPassword
}

public enum InfostudError: Error {
    case infostudNotWorking
    case opisRequired(url: String)
}
