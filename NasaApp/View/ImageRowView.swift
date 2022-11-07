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
    
    @ViewBuilder
    var avatar: some View {
        if let link = item.links.first, !link.href.isEmpty {
            AsyncImage(url: .init(string: link.href)) { phase in
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
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 130)
                        .clipped()
                case .failure(_):
                    HStack { // Wrapper Horizontal failure icon photo
                        Spacer()
                        Image(systemName: "exclamationmark.triangle").imageScale(.large)
                        Spacer()
                    }
                default:
                    EmptyView()
                }
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let data = item.data.first, let title = data.title {
                HStack {
                    Text("\(title)")
                        .font(.title)
                        .lineLimit(2)
                        .padding(.leading, 8)
                }
                avatar
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
