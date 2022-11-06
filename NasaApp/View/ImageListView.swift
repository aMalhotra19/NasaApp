//
//  ImageListView.swift
//  NasaApp
//
//  Created by Anju Malhotra on 11/6/22.
//

import SwiftUI

struct ImageListView: View {
    let imageList: [Item]
    @State private var selectedItem: Item?
    var body: some View {
        List {
            ForEach(imageList, id: \.links.first?.href) { item in
                ImageRowView(item: item)
                    .onTapGesture {
                        selectedItem = item
                    }
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        
        .fullScreenCover(item: $selectedItem) { details in
            ImageDetailView(item: details)
        }
    }
}

struct ImageListView_Previews: PreviewProvider {
    static var previews: some View {
        let imageData = ImageData(title: "Earth", dataDescription: "Dummmy Data", dateCreated: Date())
        let itemLink = ItemLink(href: "https://images-assets.nasa.gov/image/PIA16573/PIA16573~thumb.jpg")
        let item = Item(data: [imageData], links: [itemLink])
        ImageListView(imageList: [item])
    }
}
