//
//  POIItem.swift
//  GoogleMapClustering
//
//  Created by Mohannad Bakbouk on 9/22/20.
//  Copyright © 2020 Mohannad Bakbouk. All rights reserved.
//


import GoogleMaps
import GoogleMapsUtils


class POIItem: NSObject, GMUClusterItem {
    
    var position: CLLocationCoordinate2D
    
    var name: String!

    init(position: CLLocationCoordinate2D, name: String) {
        self.position = position
        self.name = name
    }

}


