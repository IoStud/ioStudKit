import Foundation

public enum InfostudRequestError: Error {
        case invalidURL
        case invalidHTTPResponse(String)
        case httpRequestError(Int)
        case jsonDecodingError
}
