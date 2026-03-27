//
//  PageTitleText.swift
//  entelechy
//
//  Created by Angel Prieto on 3/26/26.
//

import SwiftUI

struct PageTitleText: View {
    
    let title: String

    var body: some View {
        
        Text(title)
            .font(.title.weight(.thin))
        
    }
    
}
