//
//  AppTitleText.swift
//  entelechy
//
//  Created by Angel Prieto on 4/6/26.
//

import SwiftUI

struct AppTitleText: View {
    
    let display: Bool
    
    init(display: Bool = true) {
        self.display = display
    }

    var body: some View {
        
        Text("entelechy")
            .font(.system(.largeTitle, design: .serif))
            .fontWeight(.semibold)
            .padding(.top, AppLayout.titleTopPadding)
            .opacity(display ? 1 : 0)
        
    }
    
}
