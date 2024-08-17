//
//  MapView.swift
//  SearchableMap
//
//  Created by Gordon Price on 15.08.2024.
//

import MapKit
import SwiftUI

struct MapView: View {
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var searchResults: [MKMapItem] = []
    @State private var visibleRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 48.85678,
            longitude: 2.35107
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.15,
            longitudeDelta: 0.15
        )
    )
    
    var body: some View {
        Map(position: $cameraPosition) {
            ForEach(searchResults, id: \.self) { result in
                Marker(item: result)
            }
        }
        .safeAreaInset(edge: .bottom) {
            SearchView(searchResults: $searchResults, visibleRegion: visibleRegion)
        }
        .onAppear {
            cameraPosition = .region(visibleRegion)
        }
        .onMapCameraChange(frequency: .onEnd) { context in
            visibleRegion = context.region
        }
    }
}




#Preview {
    MapView()
}
