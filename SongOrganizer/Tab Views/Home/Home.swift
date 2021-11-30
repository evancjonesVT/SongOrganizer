//
//  Home.swift
//  SongOrganizer
//
//  Created by Evan Jones on 11/18/21.
//  Copyright © 2021 Evan Jones. All rights reserved.
//

import SwiftUI

// 30 total photos in slide show.
fileprivate let numberOfCaptions = 30
fileprivate let imageCaptions = ["Temp"]
fileprivate var counter = 1

struct Home: View {
    
    @State private var photoNumber = 1
    
    /*
     Create a timer publisher that fires 'every' 3 seconds and updates the view.
     It runs 'on' the '.main' runloop so that it can update the view.
     It runs 'in' the '.common' mode so that it can run alongside other
     common events such as when the ScrollView is being scrolled.
     */
    @State private var timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack{
            // Set the background color of the Home page.
            Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    
                    // Welcome title image centered at the top of the screen.
                    Image("Welcome")
                        .frame(width: 200, height: 20, alignment: .center)
                        .padding(.bottom, 30)
                        .padding(.top, 30)
                    
                    // Slideshow of the various music album images with caption.
                    Image("photo\(photoNumber)")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                        .padding(.horizontal, 10.0)
                        .clipShape(RoundedRectangle(cornerRadius: 20))

                    // Subscribe to the timer publisher
                    .onReceive(timer) { _ in
                        counter += 1
                        if counter > numberOfCaptions {
                            counter = 1
                        }
                        photoNumber = counter
                    }
                    
                    
                    // API credit section.
                    Text("Powered By")
                        .font(.system(size: 20, weight: .medium, design: .serif))
                        .italic()
                        .padding(.bottom, 30)
                    
                    // Show taste dive provider's website in default web browser.
                    Link(destination: URL(string: "https://tastedive.com/")!) {
                        HStack {
                            Image("TasteDiveImage")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                    }
                    .padding(.bottom, 20)
                    
                    // Show lyrics ovh website in default web browser.
                    Link(destination: URL(string: "https://lyricsovh.docs.apiary.io/#")!) {
                        HStack {
                            Image("LyricsImage")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                    }
                    .padding(.bottom, 20)
                    
                } // end of VStack.
            } // end of ScrollView.

        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
