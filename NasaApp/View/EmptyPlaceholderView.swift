//
//  EmptyPlaceholderView.swift
//  NasaApp
//
//  Created by Anju Malhotra on 11/6/22.
//

import SwiftUI

/// Implements empty placeholder
/// param: text to display on UI
/// param: image to display image based on the response
struct EmptyPlaceholderView: View {
    
    let text: String
    let image: Image
    
    var body: some View {

        VStack(spacing: 8) {
            Spacer()
            if let image = self.image {
                image
                    .imageScale(.large)
                    .font(.system(size: 52))
            }
            Text(text)
            Spacer()
        }
    }
}

struct EmptyPlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyPlaceholderView(text: "Search", image: Image(systemName: "magnifyingglass"))
    }
}
