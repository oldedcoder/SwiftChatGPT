//
//  ContentView.swift
//  Chatgpt
//
//  Created by qinwenzhou on 2023/2/17.
//

import SwiftUI

struct ContentView: View {
    var manager = SessionManager()
    
    var body: some View {
        NavigationSplitView {
            SessionView(manager: manager)
        } detail: {
            ChatView(manager: manager)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
