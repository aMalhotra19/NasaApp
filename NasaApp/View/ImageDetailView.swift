//
//  ImageDetailView.swift
//  NasaApp
//
//  Created by Anju Malhotra on 11/6/22.
//

import SwiftUI

struct ImageDetailView: View {
    
    let item: Item
    var body: some View {
        VStack(alignment: .leading) {
            let data = item.data.first
            
            if let urlString = item.id, let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 230)
                        .clipped()
                        .padding(.top, 0)
                } placeholder: {
                    Color.gray
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
