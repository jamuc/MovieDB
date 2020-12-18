//
//  ContentView.swift
//  Shared
//
//  Created by Jason Franklin on 12.12.20.
//

import SwiftUI
import MovieKit

struct ContentView: View {
    var body: some View {
        TabView {
            ForEach(MovieEndpoint.allCases) { endpoint in
                Text(endpoint.description)
                    .tabItem {
                        Image(systemName: endpoint.symbol)
                        Text(endpoint.description)
                    }
            }
        }
        .font(.headline)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
