//
//  ApiService.swift
//  GoogleMapClustering
//
//  Created by Mohannad Bakbouk on 9/22/20.
//  Copyright © 2020 Mohannad Bakbouk. All rights reserved.
//


import UIKit

class ApiService: NSObject {
    
    
     static let shared = ApiService()
    
    
     func fetchCompanies( completion :  @escaping (ComanpiesRes?)->()){
        
        let url = URL(string:"\(Constants.identifiers.apiUrl)")!
        
        let params = "searchText=&apiKey=501edc9e".data(using: .utf8)
              
        var request = URLRequest(url: url)
      
        request.httpMethod = "POST"
        
        request.httpBody = params
     
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
       
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
                  
              let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                  
                  guard let data = data , error == nil else {
                      print("error while fetching companies \(error)")
                      completion(nil)
                      return
                  }
                  
                let result = try? JSONDecoder().decode(ComanpiesRes.self, from: data)
                         
                completion(result)
                
   }
        
        task.resume()
    }

}

