//
//  SearchSong.swift
//  SongOrganizer
//
//  Created by Evan Jones on 12/5/21.
//  Copyright © 2021 Evan Jones. All rights reserved.
//

import SwiftUI
import CoreData

// Global Variables
var searchCategory = ""
var searchQuery = ""

struct SearchSong: View {
    
    let searchCategoriesList = ["Song Title", "Release Year"]
    
    @State private var selectedSearchCategoryIndex = 0
    @State private var searchFieldValue = ""
    @State private var searchQueryEntered = ""
    
    var body: some View {
        Form {
            Section(header: Text("Select a Search Category").padding(.top, 50)) {
                
                Picker("", selection: $selectedSearchCategoryIndex) {
                    ForEach(0 ..< searchCategoriesList.count, id: \.self) {
                        Text(searchCategoriesList[$0])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(minWidth: 300, maxWidth: 500, alignment: .leading)
            }
            Section(header: Text("Search Query under Selected Category")) {
                HStack {
                    TextField("Enter Search Query", text: $searchFieldValue,
                              onCommit: {
                                // Record entered value after Return key is pressed
                                searchQueryEntered = searchFieldValue
                    }
                    )
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    
                    // Button to clear the text field
                    Button(action: {
                        searchFieldValue = ""
                        searchQueryEntered = ""
                    }) {
                        Image(systemName: "clear")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                    }
                }   // End of HStack
                    .padding(.horizontal)
            }
            if !searchQueryEntered.isEmpty {
                Section(header: Text("Show Search Results")) {
                    NavigationLink(destination: showSearchResults()) {
                        HStack {
                            Image(systemName: "list.bullet")
                            Text("Show Found Songs")
                                .font(.headline)
                        }
                    }
                }
            }
            
        }   // End of Form
            .navigationBarTitle(Text("Search Songs"), displayMode: .inline)
    }
    
    func showSearchResults() -> some View {
        
        let queryTrimmed = searchQueryEntered.trimmingCharacters(in: .whitespacesAndNewlines)
        if (queryTrimmed.isEmpty) {
            return AnyView(missingSearchQueryMessage)
        }
        searchCategory = searchCategoriesList[selectedSearchCategoryIndex]
        searchQuery = searchFieldValue
        
        return AnyView(SearchSongsResultsList())
    }
    
    var missingSearchQueryMessage: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .imageScale(.large)
                .font(Font.title.weight(.medium))
                .foregroundColor(.red)
                .padding()
            Text("Search Query Missing!\nPlease enter a search query to be able to search the database!")                .fixedSize(horizontal: false, vertical: true)   // Allow lines to wrap around
                .multilineTextAlignment(.center)
                .padding()
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(Color(red: 1.0, green: 1.0, blue: 240/255))     // Ivory color
    }
    
}

struct SearchSong_Previews: PreviewProvider {
    static var previews: some View {
        SearchSong()
    }
}
