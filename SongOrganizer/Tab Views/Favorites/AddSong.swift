//
//  AddSong.swift
//  SongOrganizer
//
//  Created by Evan Jones on 11/28/21.
//  Copyright © 2021 Evan Jones. All rights reserved.
//

import SwiftUI
import CoreData

struct AddSong: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var showSongAddedAlert = false
    @State private var showInputDataMissingAlert = false
    
    // Song entity
    @State private var songTitle = ""
    @State private var releaseYear = 0
    @State private var length = ""
    @State private var youTubeLink = ""
    @State private var appleLink = ""
    @State private var spotifyLink = ""
    
    // Album entity
    @State private var albumName = ""
    
    // Artist entity
    @State private var artistName = ""
    
    // Photo Entity
    @State private var showImagePicker = false
    @State private var photoImageData: Data? = nil
    @State private var photoTakeOrPickIndex = 1     // Pick from Photo Library
    
    var photoTakeOrPickChoices = ["Camera", "Photo Library"]
    
    let yearFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSize = 3
        return numberFormatter
    }()
    
    var body: some View {
        
        Form {
            Group {
                Section(header: Text("Song Title")){
                    HStack {
                        TextField("Enter song title", text: $songTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .frame(minWidth: 260, maxWidth: 500, alignment: .leading)
                        Button(action: {
                            songTitle = ""
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }
                }
                Section(header: Text("Artist Name")){
                    HStack {
                        TextField("Enter artist name", text: $artistName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .frame(minWidth: 260, maxWidth: 500, alignment: .leading)
                        Button(action: {
                            artistName = ""
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }
                }
                Section(header: Text("Album Name")){
                    HStack {
                        TextField("Enter album name", text: $albumName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .frame(minWidth: 260, maxWidth: 500, alignment: .leading)
                        Button(action: {
                            albumName = ""
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }
                }
                Section(header: Text("Add Album Photo")){
                    VStack {
                        Picker("Take or Pick Photo", selection: $photoTakeOrPickIndex) {
                            ForEach(0 ..< photoTakeOrPickChoices.count, id: \.self) {
                                Text(photoTakeOrPickChoices[$0])
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        
                        Button(action: {
                            showImagePicker = true
                        }) {
                            Text("Get Photo")
                                .padding()
                        }
                    }   // End of VStack
                }
                Section(header: Text("Album Photo")){
                    photoImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100.0, height: 100.0)
                }
            }
            Group {
                Section(header: Text("Release Year")){
                    HStack {
                        TextField("Enter release year", value: $releaseYear, formatter: yearFormatter)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .frame(minWidth: 260, maxWidth: 500, alignment: .leading)
                        Button(action: {
                            releaseYear = 0
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }
                }
                Section(header: Text("Song Length")){
                    HStack {
                        TextField("Enter song length", text: $length)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .frame(minWidth: 260, maxWidth: 500, alignment: .leading)
                        Button(action: {
                            length = ""
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }
                }
                Section(header: Text("YouTube Link")){
                    HStack {
                        TextField("Enter YouTube Link", text: $youTubeLink)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .frame(minWidth: 260, maxWidth: 500, alignment: .leading)
                        Button(action: {
                            youTubeLink = ""
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }
                }
                Section(header: Text("Apple Music Link")){
                    HStack {
                        TextField("Enter Apple Music Link", text: $appleLink)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .frame(minWidth: 260, maxWidth: 500, alignment: .leading)
                        Button(action: {
                            appleLink = ""
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }
                }
                Section(header: Text("Spotify Link")){
                    HStack {
                        TextField("Enter Spotify Link", text: $spotifyLink)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .frame(minWidth: 260, maxWidth: 500, alignment: .leading)
                        Button(action: {
                            spotifyLink = ""
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }
                }
            }
            .alert(isPresented: $showSongAddedAlert, content: { songAddedAlert })
        } // End form
        .alert(isPresented: $showInputDataMissingAlert, content: { inputDataMissingAlert })
        .navigationBarTitle(Text("Add Song"), displayMode: .inline)
        .navigationBarItems(trailing:
                                Button(action: {
            if inputDataValidated() {
                saveNewSong()
                showSongAddedAlert = true
            } else {
                showInputDataMissingAlert = true
            }
        }) {
            Text("Save")
        })
        
        .sheet(isPresented: $showImagePicker) {
            /*
             🔴 We pass $showImagePicker and $photoImageData with $ sign into PhotoCaptureView
             so that PhotoCaptureView can change them. The @Binding keywork in PhotoCaptureView
             indicates that the input parameter is passed by reference and is changeable (mutable).
             */
            PhotoCaptureView(showImagePicker: $showImagePicker,
                             photoImageData: $photoImageData,
                             cameraOrLibrary: photoTakeOrPickChoices[photoTakeOrPickIndex])
        }
    } // end body
    
    var photoImage: Image {
        
        if let imageData = photoImageData {
            // The public function is given in UtilityFunctions.swift
            let imageView = getImageFromBinaryData(binaryData: imageData, defaultFilename: "AlbumCoverDefaultImage")
            return imageView
        } else {
            return Image("AlbumCoverDefaultImage")
        }
    }
    
    /*
     -----------------------
     MARK: Song Added Alert
     -----------------------
     */
    var songAddedAlert: Alert {
        Alert(title: Text("Song Added!"),
              message: Text("New song is added to your Favorites List!"),
              dismissButton: .default(Text("OK")) {
            // Dismiss this View and go back
            presentationMode.wrappedValue.dismiss()
        })
    }
    
    /*
     --------------------------------
     MARK: Input Data Missing Alert
     --------------------------------
     */
    var inputDataMissingAlert: Alert {
        Alert(title: Text("Missing Input Data!"),
              message: Text("Required Data: Song title, album name, artist Name"),
              dismissButton: .default(Text("OK")) )
    }
    
    /*
     -----------------------------
     MARK: Input Data Validation
     -----------------------------
     */
    func inputDataValidated() -> Bool {
        
        if songTitle.isEmpty || albumName.isEmpty || artistName.isEmpty {
            return false
        }
        
        return true
    }
    
    /*
     --------------------
     MARK: Save New Song
     --------------------
     */
    func saveNewSong() {
        
        /*
         ======================================================
         Create an instance of the Song Entity and dress it up
         ======================================================
         */
        
        // ❎ Create a new Song entity in CoreData managedObjectContext
        let newSong = Song(context: managedObjectContext)
        
        // ❎ Dress up the new Song entity
        newSong.songTitle = songTitle
        newSong.releaseYear = NSNumber(value: releaseYear)
        newSong.length = length
        newSong.appleLink = appleLink
        newSong.spotifyLink = spotifyLink
        newSong.youtube = youTubeLink
        
        /*
         ======================================================
         Create an instance of the Photo Entity and dress it up
         ======================================================
         */
        
        // ❎ Create a new Photo entity in CoreData managedObjectContext
        let newPhoto = Photo(context: managedObjectContext)
        
        // ❎ Dress up the new Photo entity
        if let imageData = photoImageData {
            newPhoto.photo = imageData
        } else {
            // Obtain the album cover default image from Assets.xcassets as UIImage
            let photoUIImage = UIImage(named: "AlbumCoverDefaultImage")
            
            // Convert photoUIImage to data of type Data (Binary Data) in JPEG format with 100% quality
            let photoData = photoUIImage?.jpegData(compressionQuality: 1.0)
            
            // Assign photoData to Core Data entity attribute of type Data (Binary Data)
            newPhoto.photo = photoData!
        }
        
        /*
         ===========================
         MARK: - ❎ Album Entity
         ===========================
         */
        // ❎ Define the fetch request
        let fetchRequest = NSFetchRequest<Album>(entityName: "Album")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "albumName", ascending: true)]
        
        fetchRequest.predicate = NSPredicate(format: "albumName ==[c] %@", albumName)
        
        var results = [Album]()
        var anAlbum = Album()
        
        do {
            // ❎ Execute the fetch request
            results = try managedObjectContext.fetch(fetchRequest)
            
            if results.isEmpty {
                anAlbum = Album(context: managedObjectContext)
                
                // Dress it up by specifying its attributes
                anAlbum.albumName = albumName
            } else {
                anAlbum = results[0]
            }
        } catch {
            print("Album entity fetch failed!")
        }
        
        // Establish One-to-Many Relationship
        newSong.album = anAlbum
        anAlbum.song!.adding(newSong)
        
        // Establish One-to-one relationship
        anAlbum.photo = newPhoto
        newPhoto.album = anAlbum
        
        
        /*
         ===========================
         MARK: - ❎ Artist Entity
         ===========================
         */
        // ❎ Define the fetch request
        let fetchRequestArtist = NSFetchRequest<Artist>(entityName: "Artist")
        fetchRequestArtist.sortDescriptors = [NSSortDescriptor(key: "artistName", ascending: true)]
        
        fetchRequestArtist.predicate = NSPredicate(format: "artistName ==[c] %@", artistName)
        
        var resultsArtist = [Artist]()
        var anArtist = Artist()
        
        do {
            // ❎ Execute the fetch request
            resultsArtist = try managedObjectContext.fetch(fetchRequestArtist)
            
            if resultsArtist.isEmpty {
                anArtist = Artist(context: managedObjectContext)
                
                // Dress it up by specifying its attributes
                anArtist.artistName = artistName
            } else {
                anArtist = resultsArtist[0]
            }
        } catch {
            print("Artist entity fetch failed!")
        }

        // One to many
        anAlbum.artist = anArtist
        anArtist.album!.adding(anAlbum)
        
        /*
         ===========================================
         MARK: ❎ Save Changes to Core Data Database
         ===========================================
         */
        
        do {
            try managedObjectContext.save()
        } catch {
            return
        }
        
    }   // End of function
}

struct AddSong_Previews: PreviewProvider {
    static var previews: some View {
        AddSong()
    }
}
