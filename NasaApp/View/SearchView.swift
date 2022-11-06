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
            Text("Text")
                .navigationTitle("Navigation Title")
        }
    }

}



struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
