//
//  ImageListView.swift
//  NasaApp
//
//  Created by Anju Malhotra on 11/6/22.
//

import SwiftUI

struct ImageListView: View {
    @ObservedObject var viewModel: SearchViewModel
    @State private var selectedItem: Item?
    var body: some View {
        List {
            ForEach(viewModel.collection, id: \.id) { item in
                NavigationLink {
                    ImageDetailView(item: item)
                } label: {
                    ImageRowView(item: item)
                        .task {
                            if viewModel.reachedEnd(of: item) && !viewModel.isFetching {
                                await viewModel.fetchNextSetOfData()
                            }
                        }
                }
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}

struct ImageListView_Previews: PreviewProvider {
    static var previews: some View {
        let imageData = ImageData(title: "Earth", dataDescription: "Dummmy Data", dateCreated: Date())
        let itemLink = ItemLink(href: "https://images-assets.nasa.gov/image/PIA16573/PIA16573~thumb.jpg")
        let item = Item(data: [imageData], links: [itemLink])
        ImageListView(viewModel: SearchViewModel())
    }
}
