//
//  ImageDetailView.swift
//  NasaApp
//
//  Created by Anju Malhotra on 11/6/22.
//

import SwiftUI

/// Implements ImageDetailView
/// Displays title in navigation bar
/// Displays Image, description and date created in body
struct ImageDetailView: View {
    
    let item: Item
    var body: some View {
        VStack(alignment: .leading) {
            let data = item.data.first
            
            if let urlString = item.id, let url = URL(string: urlString) {
                CacheAsyncImage(url: url) { phase in
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
            if let description = data?.dataDescription {
                Text(description)
                    .padding(.vertical, 10)
            }
            if let dateCreated = data?.dateCreated {
                Text("\(dateCreated)")
            }
            Spacer()
        }
        .padding(.all, 10.0)
        .navigationTitle(item.data.first?.title ?? "")
    }
}

struct ImageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let imageData = ImageData(title: "Earth", dataDescription: "Dummmy Data", dateCreated: Date())
        let itemLink = ItemLink(href: "https://freepngimg.com/thumb/cartoon/3-2-cartoon-free-png-image-thumb.png")
        let item = Item(data: [imageData], links: [itemLink])
        ImageDetailView(item: item)
    }
}
