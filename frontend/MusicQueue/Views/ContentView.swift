//
//  ContentView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-05.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var contentViewModel = ContentViewModel()
    
    var body: some View {
        DashboardView()
        //        if contentViewModel.isAuthenticated {
//            DashboardView()
//        }
//        AuthorizationView()
    }
}

class ContentViewModel: ObservableObject {
    
    @Published var isAuthenticated = false
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
