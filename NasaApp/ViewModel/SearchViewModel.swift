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
    @Published var collection: [Item] = []
    @Published var phase: FetchPhase = FetchPhase<[Item]>.empty
    @Published private(set) var viewState: ViewState?
    
    private var page = 1
    private let totalPages = 100
    
    let api: NasaApi
    
    init(api: NasaApi = NasaApi.shared) {
        self.api = api
    }
    
    var isLoading: Bool {
        viewState == .loading
    }
    
    var isFetching: Bool {
        viewState == .fetching
    }
    
    func search() async {
        viewState = .fetching
        defer { viewState = .finished }
        
        do {
            let searchResponse = try await api.search(from: searchQuery, for: Constants.mediaType, page: page)
            collection += searchResponse.collection.items
            phase = .success(collection)
        } catch {
            phase = .failure(error)
        }
    }
    
    func reachedEnd(of item: Item) -> Bool {
        collection.last?.id == item.id
    }
    
    func fetchNextSetOfData() async {
        
        guard page != totalPages else { return }
        page += 1
        Task {
            await search()
        }
    }
}

extension SearchViewModel {
    enum ViewState {
        case fetching
        case loading
        case finished
    }
}
