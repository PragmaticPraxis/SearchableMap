//
//  SearchView.swift
//  SearchableMap
//
//  Created by Gordon Price on 17.08.2024.
//

import MapKit
import SwiftUI

struct SearchView: View {
    @State private var searchString: String = ""
    @FocusState private var searchFieldFocus: Bool
    @Binding var searchResults: [MKMapItem]
    var visibleRegion: MKCoordinateRegion
    
    var body: some View {
        VStack {
            HStack {
                TextField("search...", text: $searchString)
                    .textFieldStyle(.roundedBorder)
                    .focused($searchFieldFocus)
                    .overlay(alignment: .trailing) {
                        if searchFieldFocus {
                            Button {
                                searchString = ""
                                searchFieldFocus = false
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.red)
                            }
                            .offset(x: -5)
                        }
                    }
                    .onSubmit {
                        Task {
                            searchResults = await MKMapItem.search(for: searchString, in: visibleRegion)
                        }
                    }
            }
            .padding()
        }
    }
}
