//
//  NasaAPI.swift
//  NasaApp
//
//  Created by Anju Malhotra on 11/5/22.
//

import Foundation

struct Constants {
    static let mediaType = "image"
}

// Contains API initialization, Session URL, JSON data decode, search(query, mediaType, page), fetchData response status code function, generateSearchURL(query, mediaType, page), generateError for NASA Api

// Future implementation to seperate API service in seperate module
struct NasaApi {
    static let shared = NasaApi()
    private init() {}
    
    var searchKey = ""
    private let session = URLSession.shared
    
    // Function decode JSON File (standard iso8601 -> this is from its API) into Native Swift Date Type
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    func search(from query: String, for mediaType: String, page: Int) async throws -> NasaAPIResponse {
        try await fetchData(from: generateSearchURL(from: query, for: mediaType, page: page))
    }
    
    // Function Fetching Data and Response Code from URL
    private func fetchData(from url: URL) async throws -> NasaAPIResponse {
        let (data, response) = try await session.data(from: url)
        
        // Error handling response from API Provider
        guard let response = response as? HTTPURLResponse else {
            throw generateError(description: "Bad response")
        }
        
        // Decode the API Response Code with jsonDecoder and Generate Error Results based on the response Code
        switch response.statusCode {
        case 200...209, 400...409:
            let parsedResponse = try jsonDecoder.decode(NasaAPIResponse.self, from: data)
            return parsedResponse
        default:
            throw generateError(description: "Parsing Error")
        }
    }
    
    // Function Generate Search URL
    private func generateSearchURL(from query: String, for mediaType: String, page: Int) -> URL {
        let percentEncodedString = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        var urlString = "https://images-api.nasa.gov/search?"
        urlString += "&q=\(percentEncodedString)"
        urlString += "&media_type=\(Constants.mediaType)"
        urlString += "&page=\(page)"
        return URL(string: urlString)!
    }
    
    // Function Generate Error Domain
    private func generateError(code: Int = 1, description: String) -> Error {
        NSError(domain: "NasaApi", code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
}
