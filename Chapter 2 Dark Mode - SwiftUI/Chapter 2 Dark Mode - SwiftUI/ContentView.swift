//
//  ContentView.swift
//  Chapter 2 Dark Mode - SwiftUI
//
//  Created by Chris Barker on 25/04/2020.
//  Copyright © 2020 Packt. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var appearance
    var body: some View {
        NavigationView {
            Text(appearance == .dark ? "Dark Appearance" : "Light Appearance")
        }
    }
    
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//            .environment(\.colorScheme, .dark)
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().environment(\.colorScheme, .light)
            ContentView().environment(\.colorScheme, .dark)
        }
    }
}
