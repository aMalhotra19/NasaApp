//
//  SearchViewModel.swift
//  NasaApp
//
//  Created by Anju Malhotra on 11/5/22.
//

import Foundation
import Combine

enum FetchPhase<T> {
    case empty // default: initial application opening
    case success(T) // generate news
    case failure(Error) // error
}

@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    let historyDataStore = ["mars", "space", "earth"]
    @Published var phase: FetchPhase = FetchPhase<NasaAPIResponse>.empty
    
    let api: NasaApi
    
    init(api: NasaApi = NasaApi.shared) {
        self.api = api
    }
    
    func search() async {
        do {
            let searchResponse = try await api.search(from: searchQuery, for: Constants.mediaType)
            phase = .success(searchResponse)
        } catch {
            phase = .failure(error)
        }
    }
}
