//
//  String+Extensions.swift
//  SearchableMap
//
//  Created by Gordon Price on 17.08.2024.
//

import MapKit

extension MKMapItem {
    static func search(for query: String, in region: MKCoordinateRegion) async -> [MKMapItem] {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        request.region = region
        
        let search = MKLocalSearch(request: request)
        let response = try? await search.start()
        let searchResults = response?.mapItems ?? []
        
        return searchResults
    }
}
