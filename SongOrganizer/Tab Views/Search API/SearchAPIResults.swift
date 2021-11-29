//
//  SearchAPIResults.swift
//  SearchAPIResults
//
//  Created by Ethan Homoroc on 11/28/21.
//  Copyright © 2021 Evan Jones. All rights reserved.
//

import SwiftUI

struct SearchAPIResults: View {
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                Text(tasteFound.name)
            }
            
        }   // End of Form
            .navigationBarTitle(Text("Similar"), displayMode: .inline)
            .font(.system(size: 14))
        
    }   // End of body
    
}

struct SearchAPIResults_Previews: PreviewProvider {
    static var previews: some View {
        SearchAPIResults()
    }
}
