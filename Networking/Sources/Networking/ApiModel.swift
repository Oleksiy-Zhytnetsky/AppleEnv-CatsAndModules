//
//  ApiModel.swift
//  Networking
//
//  Created by Oleksiy Zhytnetsky on 27.05.2025.
//

import Foundation

public struct CatData : Codable, Identifiable, Hashable {
    
    public let id: String
    public let url: String
    public let breeds: [BreedData]
    
    public var mainBreed: String {
        return self.breeds.first?.name ?? "Unknown"
    }
    
}

public struct BreedData : Codable, Identifiable, Hashable {
    
    public let id: String
    public let name: String
    
}
