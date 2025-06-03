//
//  ApiClient.swift
//  Networking
//
//  Created by Oleksiy Zhytnetsky on 27.05.2025.
//

import Foundation

public final class ApiClient {
    
    private struct Const {
        static let API_KEY = "live_X2bbMlK6mblfiIeOaS2r4IR7TEuPVg0wFEoIOcuT5byrFbCTM9FvYf4b0GKaAve8"
        static let Order = "ASC"
        static let HasBreeds = "1"
    }
    
    public static func fetchCats(
        limit: Int = 10,
        page: Int = 0
    ) async throws -> [CatData] {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.thecatapi.com"
        components.path = "/v1/images/search"
        components.queryItems = [
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "order", value: Const.Order),
            URLQueryItem(name: "has_breeds", value: Const.HasBreeds),
            URLQueryItem(name: "api_key", value: Const.API_KEY)
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        let (resp, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([CatData].self, from: resp)
    }
    
}
