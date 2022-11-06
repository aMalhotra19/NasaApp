//
//  ImageRowView.swift
//  NasaApp
//
//  Created by Anju Malhotra on 11/6/22.
//

import SwiftUI

struct ImageRowView: View {
    let item: Item
    var itemImage: Image?
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let link = item.links.first, let url = URL(string: link.href), let data = item.data.first, let title = data.title {
                HStack {
                    Text("\(title)")
                        .font(.title)
                        .lineLimit(2)
                        .padding(.leading, 8)
                }
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        HStack(alignment: .center) { // Wrapper Horizontal progress icon photo
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    case .success(let image):
                        // Success scenario
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    case .failure(_):
                        HStack { // Wrapper Horizontal failure icon photo
                            Spacer()
                            Image(systemName: "exclamationmark.triangle").imageScale(.large)
                            Spacer()
                        }
                    }
                }
                .frame(minHeight: 100, maxHeight: 300)
                .background(Color.gray.opacity(0.3))
                .clipped()
                Divider()
                    .padding(5)
            }
        }
    }
}

struct ImageRowView_Previews: PreviewProvider {
    static var previews: some View {
        let imageData = ImageData(title: "Earth", dataDescription: "Dummmy Data", dateCreated: Date())
        let itemLink = ItemLink(href: "https://images-assets.nasa.gov/image/PIA16573/PIA16573~thumb.jpg")
        let item = Item(data: [imageData], links: [itemLink])
        ImageRowView(item: item)
    }
}
