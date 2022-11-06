//
//  SearchView.swift
//  NasaApp
//
//  Created by Anju Malhotra on 11/5/22.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel: SearchViewModel = SearchViewModel()
    
    var body: some View {
        NavigationView {
            landingView()
                .navigationTitle("Nasa Image Search")
        }
        .searchable(text: $viewModel.searchQuery) { suggestionsView }
        .onSubmit(of: .search, search)
    }
    
    func search() {
        Task {
            await viewModel.search()
        }
    }

    @ViewBuilder
    private var suggestionsView: some View {
        // Manual: List Suggestion define as Button and display as Text String
        ForEach(viewModel.historyDataStore, id: \.self) { text in
            Button {
                viewModel.searchQuery = text
            } label: {
                Text(text)
            }
        }
    }
    
    @ViewBuilder
    private func landingView() -> some View {
        switch viewModel.phase {
        case .empty:
            if !viewModel.searchQuery.isEmpty {
                ProgressView()
            } else {
                EmptyPlaceholderView(text: "Search", image: Image(systemName: "magnifyingglass"))
            }
        case .success(let apiResponse):
            if apiResponse.collection.items.isEmpty {
                EmptyView()
            } else {
                // ListView
            }
            
        case .failure(let error):
            EmptyView() // Error view
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
