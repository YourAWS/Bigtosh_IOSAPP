import Foundation

class ApiClient {
    static let shared = ApiClient()
    
    private let baseUrl = "https://shirtclub.net/api/message/"
    private let session = URLSession.shared
    
    private init() {}
    
    func searchShirtOrUser(code: String, completion: @escaping (Result<ApiResponse, Error>) -> Void) {
        let urlString = "\(baseUrl)\(code.lowercased())"
        guard let url = URL(string: urlString) else {
            completion(.failure(ApiError.invalidUrl))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(ApiError.noData))
                    return
                }
                
                do {
                    let apiResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
                    completion(.success(apiResponse))
                } catch {
                    print("Decoding error: \(error)")
                    completion(.failure(ApiError.decodingFailed))
                }
            }
        }
        
        task.resume()
    }
}

enum ApiError: Error {
    case invalidUrl
    case noData
    case decodingFailed
    case noMessageFound
    
    var localizedDescription: String {
        switch self {
        case .invalidUrl:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingFailed:
            return "Failed to decode response"
        case .noMessageFound:
            return "No message or user found for this number."
        }
    }
}
