//
//  Company.swift
//  GoogleMapClustering
//
//  Created by Mohannad Bakbouk on 9/22/20.
//  Copyright © 2020 Mohannad Bakbouk. All rights reserved.
//

import Foundation



struct Company : Codable {
    
    var addressOne : String
    var addressTwo : String
    var category : String
    var companyType : String
    var country : String
    var id : String
    var image : String
    var latitude : String
    var longitude : String
    var name : String
    var newJoined : Bool
    var state : String
    var userLocation : String
}



struct ComanpiesRes : Codable {
    
    var error : Bool
    var status : String
    var locationData : [Company]?
    
}

