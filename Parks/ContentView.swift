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
                    Text(park.name)
                        .font(.title)
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
