//
//  SearchResultItem.swift
//  SearchResultItem
//
//  Created by Ethan Homoroc on 11/29/21.
//  Copyright © 2021 Evan Jones. All rights reserved.
//

import SwiftUI

struct SearchResultItem: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(tasteFound.name)
            Text(tasteFound.type)
        }
        .font(.system(size: 14))
    }
}
