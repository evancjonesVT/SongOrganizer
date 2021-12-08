//
//  RecordingsList.swift
//  SongOrganizer
//
//  Created by Evan Jones on 11/18/21.
//  Copyright © 2021 Evan Jones. All rights reserved.
//

import SwiftUI

struct RecordingsList: View {
    // Subscribe to changes in UserData
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        NavigationView {
            List {
                if (userData.voiceMemosList.isEmpty) {
                    Text("Tap the Plus to Add a Recording")
                } else {
                    ForEach(userData.voiceMemosList) { aRecording in
                        NavigationLink(destination: RecordingsDetails(voiceMemo: aRecording)) {
                            RecordingsItem(voiceMemo: aRecording)
                        }
                    }
                    .onDelete(perform: delete)
                    .onMove(perform: move)
                }
                
            } // End of List
            .navigationBarTitle(Text("Voice Memos"), displayMode: .inline)
            
            // Place the Edit button on left and Add (+) button on right of the navigation bar
            .navigationBarItems(leading: EditButton(), trailing:
                                    NavigationLink(destination: RecordVoiceMemo()) {
                Image(systemName: "plus")
            })
            
        } // End of NavigationView
        // Use single column navigation view for iPhone and iPad
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    /*
     --------------------------------
     MARK: Delete Selected Voice Memo
     --------------------------------
     */
    func delete(at offsets: IndexSet) {
        /*
         'offsets.first' is an unsafe pointer to the index number of the array element
         to be deleted. It is nil if the array is empty. Process it as an optional.
         */
        if let index = offsets.first {
            
            let nameOfFileToDelete = userData.voiceMemosList[index].audioFullFilename
            let urlOfFileToDelete = documentDirectory.appendingPathComponent(nameOfFileToDelete)
            
            do {
                let fileManager = FileManager.default
                
                // Delete the selected voice memo audio file from the document directory
                try fileManager.removeItem(at: urlOfFileToDelete)
                
                // Remove the selected voice memo from the list
                userData.voiceMemosList.remove(at: index)
                
                // Set the global variable point to the changed list
                voiceMemoStructList = userData.voiceMemosList
                
                // Set global flag defined in VoiceMemosData
                dataChanged = true
                
            } catch {
                print("Unable to delete audio file in document directory!")
            }
        } else {
            print("Unable to delete selected voice memo!")
        }
    }
    
    /*
     ------------------------------
     MARK: Move Selected Voice Memo
     ------------------------------
     */
    func move(from source: IndexSet, to destination: Int) {
        
        userData.voiceMemosList.move(fromOffsets: source, toOffset: destination)
        
        // Set the global variable point to the changed list
        voiceMemoStructList = userData.voiceMemosList
        
        // Set global flag defined in VoiceMemosData
        dataChanged = true
    }
}

struct RecordingsList_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsList()
    }
}
