//
//  RecordingsList.swift
//  SongOrganizer
//
//  Created by Evan Jones on 11/18/21.
//  Copyright © 2021 Evan Jones. All rights reserved.
//

import SwiftUI

struct RecordingsList: View {
    @State private var voiceMemoTitle = ""
    @State private var showMissingInputDataAlert = false
    var body: some View {
        Form {
            VStack {
                Section(header: Text("Location Recorded")) {
                    HStack {
                        TextField("Enter location of recording", text: $voiceMemoTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .autocapitalization(.words)
                        Button(action: {
                            voiceMemoTitle = ""
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                        .alert(isPresented: $showMissingInputDataAlert, content: { missingInputDataAlert })
                        /*
                         ----------------------------------------------------------------
                         Modifying the same view with more than one .alert does not work!
                         You should modify a different view for each .alert to work.
                         Therefore, showMissingInputDataAlert is attached to the Button
                         above and showVoiceMemoAddedAlert is attached to the Form below.
                         ----------------------------------------------------------------
                         */
                        
                    }   // End of HStack
                    
                }
                Image(systemName: "mic")
                    .imageScale(.large)
                    .font(Font.title.weight(.medium))
                    .foregroundColor(.blue)
                    .padding()
            }
            
            
        }   // End of Form
            .font(.system(size: 14))
            .navigationBarTitle(Text("Record Song"), displayMode: .inline)
        
    }
    var missingInputDataAlert: Alert {
        Alert(title: Text("Missing Title and / or Recording!"),
              message: Text("Please enter a title and record your new voice memo!"),
              dismissButton: .default(Text("OK")) )
        /*
        Tapping OK resets @State var showMissingInputDataAlert to false.
        */
    }
}

struct RecordingsList_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsList()
    }
}
