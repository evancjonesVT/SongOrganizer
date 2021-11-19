//
//  ContentView.swift
//  SongOrganizer
//
//  Created by Evan Jones on 11/15/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        TabView {
            Home()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            FavoritesList()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Favorites")
                }
            RecordingsList()
                .tabItem {
                    Image(systemName: "mic.fill")
                    Text("Recordings")
                }
            SearchDB()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search DB")
                }
            SearchAPI()
                .tabItem {
                    Image(systemName: "magnifyingglass.circle")
                    Text("Search API")
                }
        }   // End of TabView
            .font(.headline)
            .imageScale(.medium)
            .font(Font.title.weight(.regular))
    }
}
