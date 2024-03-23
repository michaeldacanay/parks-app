//
//  ContentView.swift
//  Parks
//
//  Created by Michael Dacanay on 3/18/24.
//

import SwiftUI

struct ContentView: View {
    @State private var parks: [Park] = []
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(parks) { park in
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
        }
        .padding()
        .onAppear(perform: { // <-- Add onAppear modifier
            // Do something when the view appears
            print("On appear...")
            
            // Create a Task instance
            Task {
                await fetchParks()
            }
        })
    }
    
    private func fetchParks() async {
        // URL for the API endpoint
        // Pass in any state code you like for the stateCode parameter. For instance, stateCode=fl (Florida)
        let url = URL(string: "https://developer.nps.gov/api/v1/parks?stateCode=nc&api_key=Y8ID4AMkSgNbtJpScQqyvMvAOfQq2x3dnsGHkw9H")!
        // Wrap in do/catch since URLSession async can throw errors
        do {
    
            // Perform an asynchronous data request using URLSession
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Decode json data into ParksResponse type
            let parksResponse = try JSONDecoder().decode(ParksResponse.self, from: data)

            // Get the array of parks from the response
            let parks = parksResponse.data

            // Print the full name of each park in the array
            for park in parks {
                print(park.fullName)
            }
            
            // Set the parks state property
            self.parks = parks
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    ContentView()
}
