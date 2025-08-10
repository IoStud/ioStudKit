import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif


internal struct CallHelper{
    public static let USER_AGENT = "Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0"
    
    private init() {}
    
    internal static func getRequest(for endpoint: String) async throws -> Data {
        
        guard let url = URL(string: endpoint) else {
            throw RequestError.invalidURL(url: endpoint)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(USER_AGENT, forHTTPHeaderField: "User-Agent")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw RequestError.invalidHTTPResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw RequestError.httpRequestError(code: httpResponse.statusCode)
        }
        
        return data
    }
}
