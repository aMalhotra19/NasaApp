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

// Contains the initial default search value function, search history (dummy), and the image search result function based on the input string
@MainActor // Main data fetch queue (Main thread)
class SearchViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var collection: [Item] = []
    @Published var phase: FetchPhase = FetchPhase<[Item]>.empty
    @Published private(set) var viewState: ViewState?
    
    private var page = 1
    private let totalPages = 100
    
    let api: APIServiceProtocol
    let historyDataStore = ["mars", "space", "earth"] // Dummmy list. Future implementation for a dataStore such as plist to save user last search
    
    // NASA API object as a initializer Dependency, can be passed from parent or testable code
    init(api: APIServiceProtocol = NasaApi.shared) {
        self.api = api
    }
    
    // Trim the character in the search column so that only the keywords are valid
    private var trimmedSearchQuery: String {
        searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
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
        
        // if there is no input in the search field then nothing will happen
        if searchQuery.isEmpty {
            return
        }
        
        // Error Handling when searching based on search field input
        // DO (success) and CATCH (error)
        do {
            let searchResponse = try await api.search(from: trimmedSearchQuery, for: Constants.mediaType, page: page)
            collection += searchResponse.collection.items
            phase = .success(collection)
        } catch {
            phase = .failure(error)
        }
    }
    
    // Function to check end of page
    func reachedEnd(of item: Item) -> Bool {
        collection.last?.id == item.id
    }
    
    // Function to fetch next set of data
    func fetchNextSetOfData() async {
        
        //Check if page do not exceed total page
        guard page <= totalPages else { return }
        page += 1
        
        await search()
    }
}

extension SearchViewModel {
    // ViewState to avoid multiple calls to API
    enum ViewState {
        case fetching
        case loading
        case finished
    }
}
