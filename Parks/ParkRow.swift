//
//  ParkRow.swift
//  Parks
//
//  Created by Michael Dacanay on 3/23/24.
//

import SwiftUI

struct ParkRow: View {
    
    let park: Park
    
    var body: some View {
        // Park row
        Rectangle()
            .aspectRatio(4/3, contentMode: .fit) // <-- Dynamically size the rectangle with a 4/3 aspect ratio
            .overlay {
                // Get image url
                let image = park.images.first
                let urlString = image?.url
                let url = urlString.flatMap { string in
                    URL(string: string)
                }
                
                // Add AsyncImage
                AsyncImage(url: url) { image in
                    image // <-- The fetched image
                        .resizable() // <-- This allows the image to be resized
                        .aspectRatio(contentMode: .fill) // <-- Tells the image to size to fill the available space
                } placeholder: {
                    Color(.systemGray4) // <-- A gray color to use as a placeholder while the image is loading
                }
            }
            .overlay(alignment: .bottomLeading) { // <-- Add an overlay aligned to the bottom leading portion of the rectangle
                Text(park.name)
                    .font(.title)
                    .bold() // <-- Make the font bold
                    .foregroundStyle(.white) // <-- Change the text color to white to stand out against the black rectangle
                    .padding() // <-- Add some padding so the title is inset a bit from the edges
            }
            .cornerRadius(16) // <-- Set the corner radius for the rectangle
            .padding(.horizontal) // <-- Add padding for just the sides
    }
}

//#Preview {
//    ParkRow(park: park)
//}
