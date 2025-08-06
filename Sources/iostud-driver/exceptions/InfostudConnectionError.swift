import Foundation

public enum RequestError: Error {
    case invalidURL(url: String)
    case invalidHTTPResponse
    case httpRequestError(code: Int)
    case jsonDecodingError
    case infostudError(info: String)
}

public enum IoStudError: Error {
    case invalidPassword
    case invalidUsername
    case notWorking
}
