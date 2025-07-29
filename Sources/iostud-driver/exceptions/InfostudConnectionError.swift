import Foundation

public enum RequestError: Error {
    case invalidURL(url: String)
    case invalidHTTPResponse
    case httpRequestError(code: Int)
    case jsonDecodingError
    case infostudError(info: String)
}
