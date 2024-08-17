//  https://www.createwithswift.com/searching-points-interest-mapkit-swiftui/
//

import SwiftUI
import MapKit

struct SelfContainedMapView: View {
    /// View properties
    let garage = CLLocationCoordinate2D(
        latitude: 40.83657722488077,
        longitude: 14.306896671048852
    )
    
    /// Search properties
    @State private var searchQuery: String = ""
    @State private var searchResults: [MKMapItem] = []
    
    /// Map properties
    @State private var position: MapCameraPosition = .automatic
    @State private var visibleRegion: MKCoordinateRegion?
    @State private var selectedResult: MKMapItem?
    
    var body: some View {
        
        NavigationStack {

            Map(position: $position, selection: $selectedResult) {
                /// Reference point
                Marker("Garage", coordinate: garage)
                
                /// Search results on the map
                ForEach(searchResults, id: \.self) { result in
                    Marker(item: result)
                }
            }
            
            /// Map modifiers
            .mapStyle(.hybrid(elevation: .realistic))
            .onMapCameraChange { context in
                self.visibleRegion = context.region
            }
            
            /// Search modifiers
            .searchable(text: $searchQuery, prompt: "Locations")
            .onSubmit(of: .search) {
                self.search(for: searchQuery)
            }
            
            /// Navigation modifiers
            .navigationTitle("Search")
        }
        
    }
    
    /// Search method
    private func search(for query: String) {
        
        let defaultRegion = MKCoordinateRegion(
            center: garage,
            span: MKCoordinateSpan(
                latitudeDelta: 0.0125,
                longitudeDelta: 0.0125
            )
        )
        
        let request = MKLocalSearch.Request()
        
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        request.region = visibleRegion ?? defaultRegion
        
        Task {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            searchResults = response?.mapItems ?? []
            position = .region(request.region)
        }
    }
}

#Preview {
    SelfContainedMapView()
}
