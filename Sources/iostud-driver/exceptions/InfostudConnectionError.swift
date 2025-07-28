import Foundation

public enum InfostudRequestError: Error {
        case invalidURL
        case invalidHTTPResponse
        case httpRequestError
        case jsonDecodingError
}
