//
//  SearchAPI.swift
//  SongOrganizer
//
//  Created by Evan Jones on 11/18/21.
//  Copyright © 2021 Evan Jones. All rights reserved.
//
import SwiftUI

struct SearchAPI: View {
    
    @State private var searchFieldValue = ""
    @State private var showMissingInputDataAlert = false
    @State private var searchCompleted = false
    @State private var showProgressView = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
            Form {
                Section(header: Text("Enter Artist name to search for similar artists")) {
                    HStack {
                        TextField("Enter an Artist Name", text: $searchFieldValue)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.default)
                            .autocapitalization(.words)
                            .disableAutocorrection(true)
                        
                        // Button to clear the text field
                        Button(action: {
                            searchFieldValue = ""
                            showMissingInputDataAlert = false
                            searchCompleted = false
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }   // End of HStack
                        .frame(minWidth: 300, maxWidth: 500)
                        .alert(isPresented: $showMissingInputDataAlert, content: { missingInputDataAlert })
                    
                }   // End of Section
                
                Section(header: Text("Search Similar Artists")) {
                    HStack {
                        Button(action: {
                            if inputDataValidated() {
                                
                                showProgressView = true
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    /*
                                     Execute the following code after 0.1 second of delay
                                     so that they are not executed during the view update.
                                     */
                                    searchApi()
                                    showProgressView = false
                                    searchCompleted = true
                                }
                            } else {
                                showMissingInputDataAlert = true
                            }
                        }) {
                            Text(searchCompleted ? "Search Completed" : "Search")
                        }
                        .frame(width: 240, height: 36, alignment: .center)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(Color.black, lineWidth: 1)
                        )
                    }   // End of HStack
                }
                
                if searchCompleted {
                    Section(header: Text("Similar Artists Found")) {
                        NavigationLink(destination: showSearchResults) {
                            HStack {
                                Image(systemName: "list.bullet")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                    .foregroundColor(.blue)
                                Text("Show Artist Details")
                                    .font(.system(size: 16))
                            }
                        }
                        .frame(minWidth: 300, maxWidth: 500)
                    }
                }
                
            }   // End of Form
                .navigationBarTitle(Text("Search for Similar Artists"), displayMode: .inline)
                .onAppear() {
                    searchCompleted = false
                }
                
            }   // End of ZStack
            
        }   // End of NavigationView
        // Use single column navigation view for iPhone and iPad
        .navigationViewStyle(StackNavigationViewStyle())
        
    }   // End of body
    
    /*
    ------------------
    MARK: Search API
    ------------------
    */
    func searchApi() {
        // Remove spaces, if any, at the beginning and at the end of the entered search query string
        let songNameTrimmed = searchFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // public function getApiDataByNationalParkName is given in SearchByNameApiData.swift
        getApiDataByArtistName(artistName: songNameTrimmed)
    }
    
    /*
    ---------------------------
    MARK: Show Search Results
    ---------------------------
    */
    var showSearchResults: some View {
        
        // Global variable nationalParkFound is given in SearchByNameApiData.swift
        if tasteFound.name.isEmpty {
            return AnyView(notFoundMessage)
        }
        
        return AnyView(SearchAPIResults())
    }
    
    /*
    ------------------------------
    MARK: Song Not Found Message
    ------------------------------
    */
    var notFoundMessage: some View {
        
        ZStack {    // Color Background to Ivory color
            Color(red: 1.0, green: 1.0, blue: 240/255).edgesIgnoringSafeArea(.all)
            
            VStack {
                Image(systemName: "exclamationmark.triangle")
                    .imageScale(.large)
                    .font(Font.title.weight(.medium))
                    .foregroundColor(.red)
                    .padding()
                Text("No Artist Found!\n\nThe API did not return an artist under the entered name \(searchFieldValue). Please make sure that you enter a valid artist name as required by the API.")
                    .fixedSize(horizontal: false, vertical: true)   // Allow lines to wrap around
                    .multilineTextAlignment(.center)
                    .padding()
            } // End of VStack
        
        } // End of ZStack
    }
    
    /*
     --------------------------------
     MARK: Missing Input Data Alert
     --------------------------------
     */
    var missingInputDataAlert: Alert {
        Alert(title: Text("The Search Field is Empty!"),
              message: Text("Please enter an artist name to search for!"),
              dismissButton: .default(Text("OK")))
        /*
         Tapping OK resets @State var showMissingInputDataAlert to false.
         */
    }
    
    /*
     -----------------------------
     MARK: Input Data Validation
     -----------------------------
     */
    func inputDataValidated() -> Bool {
        
        // Remove spaces, if any, at the beginning and at the end of the entered search query string
        let queryTrimmed = searchFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if queryTrimmed.isEmpty {
            return false
        }
        return true
    }
    
}
