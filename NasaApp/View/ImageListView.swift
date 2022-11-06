//
//  ImageListView.swift
//  NasaApp
//
//  Created by Anju Malhotra on 11/6/22.
//

import SwiftUI

struct ImageListView: View {
    let imageList: [Items]
    var body: some View {
        List {
            ForEach(imageList, id: \.links.first?.href) { item in
                VStack(alignment: .leading, spacing: 16) {
                    if let link = item.links.first, let url = URL(string: link.href), let data = item.data.first, let title = data.title {
                        HStack {
                            Text("\(title)")
                                .padding()
                        }
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                HStack(alignment: .center) {
                                    ProgressView()
                                    Spacer()
                                }
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            case .failure(_):
                                HStack { // Wrapper Horizontal untuk icon photo
                                    Spacer()
                                    Image(systemName: "photo").imageScale(.large)
                                    Spacer()
                                }
                            }
                        }
                        Divider()
                            .padding(5)
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
        let item = Items(data: [imageData], links: [itemLink])
        ImageListView(imageList: [item])
    }
}
