//
//  NasaDataModel.swift
//  NasaApp
//
//  Created by Anju Malhotra on 11/5/22.
//

import Foundation

struct NasaAPIResponse: Decodable {
    let collection: Collection
}

// MARK: - Collection
struct Collection: Decodable {
    let href: String
    let items: [Item]
    let links: [PageReference]
}

// MARK: - Items
struct Item: Decodable {
    let data: [ImageData]
    let links: [ItemLink]
}

// MARK: - ImageData
struct ImageData: Decodable {
    let title: String
    let dataDescription: String
    let dateCreated: Date
    
    enum CodingKeys: String, CodingKey {
        case title
        case dataDescription = "description"
        case dateCreated = "date_created"
    }
}

extension Item: Identifiable {
    var id: String? { links.first?.href }
}

// MARK: - ItemLink
struct ItemLink: Codable {
    let href: String
}

// MARK: - Page
struct PageReference: Decodable {
    let rel: String
    let prompt: String
    let href: String
}
