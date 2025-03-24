//
//  ReqResAPIService.swift
//  UsersList
//
//  Created by Alexey Burmistrov on 24.03.2025.
//

import Foundation

enum APIError: Error, Equatable {
    case invalidURL
    case requestFailed
    case decodingFailed
    case serverError(Int)
    case connectionError
    case unknown(Error)
    
    var message: String {
        switch self {
        case .invalidURL:
            return String(localized: "Unsupported URL")
        case .requestFailed:
            return String(localized: "Request Failed")
        case .decodingFailed:
            return String(localized: "Decoding error")
        case .serverError(let code):
            return String(localized: "Server error: \(code)")
        case .connectionError:
            return String(localized: "Connection error")
        case .unknown(let error):
            return String(localized: "Unknown error: \(error.localizedDescription)")
        }
    }
    
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        lhs.message == rhs.message
    }
}

class APIService {
    private let baseURL = "https://reqres.in/api"
    
    func getUsers(page: Int) async throws -> APIResponse {
        guard let url = URL(string: "\(baseURL)/users?page=\(page)") else { throw APIError.invalidURL }
        
        do {
            var request = URLRequest(url: url)
            request.cachePolicy = .reloadIgnoringLocalCacheData
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.requestFailed
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                throw APIError.serverError(httpResponse.statusCode)
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(APIResponse.self, from: data)
            } catch {
                throw APIError.decodingFailed
            }
        } catch _ as URLError {
            throw APIError.connectionError
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.unknown(error)
        }
    }
}
