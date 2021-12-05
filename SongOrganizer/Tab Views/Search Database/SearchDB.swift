//
//  SearchDB.swift
//  SongOrganizer
//
//  Created by Evan Jones on 11/18/21.
//  Copyright © 2021 Evan Jones. All rights reserved.
//

import SwiftUI

struct SearchDB: View {
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
            NavigationView {
                List {
                    HStack {
                        Spacer()
                        Image(systemName: "music.note.list")
                            .foregroundColor(.blue)
                            .imageScale(.large)
                            .font(Font.title.weight(.regular))
                            .frame(width: 60)
                        Spacer()
                    }
                    NavigationLink(destination: SearchSong()) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.blue)
                                .imageScale(.large)
                                .font(Font.title.weight(.regular))
                                .frame(width: 60)
                            Text("Search Songs by Name or Release Year")
                        }
                    }
                    NavigationLink(destination: SearchAlbum()) {
                        HStack {
                            Image(systemName: "text.magnifyingglass")
                                .foregroundColor(.blue)
                                .imageScale(.large)
                                .font(Font.title.weight(.regular))
                                .frame(width: 60)
                            Text("Search Songs by Album")
                        }
                    }
                    NavigationLink(destination: SearchArtist()) {
                        HStack {
                            Image(systemName: "rectangle.and.text.magnifyingglass")
                                .foregroundColor(.blue)
                                .imageScale(.large)
                                .font(Font.title.weight(.regular))
                                .frame(width: 60)
                            Text("Search Songs by Artist")
                        }
                    }
                }
                .font(.system(size: 16, weight: .regular))
                .navigationBarTitle(Text("Search Database"), displayMode: .inline)
                .padding()
                
                // Remove the List separator lines only for this view
                .onAppear { UITableView.appearance().separatorStyle = .none }
                
                // Undo the List separator lines removal for other views
                .onDisappear { UITableView.appearance().separatorStyle = .singleLine }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct SearchDB_Previews: PreviewProvider {
    static var previews: some View {
        SearchDB()
    }
}
