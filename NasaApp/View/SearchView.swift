//
//  SearchView.swift
//  NasaApp
//
//  Created by Anju Malhotra on 11/5/22.
//

import SwiftUI

/// SearchView with search option using NASA API, with a dropdown hardcoded suggestion list
/// Implements EmptyPlaceholder when the api fails or in default scenario
struct SearchView: View {
    @StateObject var viewModel: SearchViewModel = SearchViewModel()
    
    var body: some View {
        NavigationView {
            LandingView()
                .navigationTitle("Nasa Image Search")
        }
        .searchable(text: $viewModel.searchQuery) { suggestionsView }
        .onSubmit(of: .search, search)
        .onChange(of: viewModel.searchQuery) { newValue in
            if newValue.isEmpty {
                viewModel.phase = .empty
            }
        }
    }
    
    // Search for results based on user query param
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
            .buttonStyle(.plain)
        }
    }
    
    @ViewBuilder
    private func LandingView() -> some View {
        switch viewModel.phase {
        case .empty: // Default state when screen is first loaded
            if !viewModel.searchQuery.isEmpty {
                ProgressView()
            } else {
                EmptyPlaceholderView(text: "Search", image: Image(systemName: "magnifyingglass"))
            }
        case .success(let collection): // Updates the view after returning from API call success response
            if collection.isEmpty {
                EmptyPlaceholderView(text: "No Data available at this time. Try again Later", image: Image(systemName: "exclamationmark.triangle"))
            } else {
                ImageListView(viewModel: viewModel)
            }
            
        case .failure(let error): // Error UI, when API fails
            EmptyPlaceholderView(text: error.localizedDescription, image: Image(systemName: "exclamationmark.triangle"))
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
