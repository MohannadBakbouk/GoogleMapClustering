//
//  ViewController.swift
//  GoogleMapClustering
//
//  Created by Mohannad Bakbouk on 9/21/20.
//  Copyright © 2020 Mohannad Bakbouk. All rights reserved.
//

import UIKit
import GoogleMaps
import GoogleMapsUtils

class HomeController: UIViewController {
    
    
    @IBOutlet weak var mapView: GMSMapView!
       
   // Lati longi for USA
    let latitude:Float = 39.784058
   
    let longitude:Float = -86.261106
   
    var clusterManager : GMUClusterManager!
   
    var renderer : GMUDefaultClusterRenderer!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupMap()
        
        initClusterManager()
        
        loadCompanies()
    }
    
    
    
    //MARK:- Custom Functions
     
     private func setupMap(){
         let camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude), zoom: 5) //16.0
         mapView.camera = camera
         
     }

     func loadCompanies(){
         
         ApiService.shared.fetchCompanies { (res) in
             
             if res?.status == "success" ,  let companies = res?.locationData {
                 
                 DispatchQueue.main.async {
                     
                      self.renderMarkers(locations: companies)
                 }
             }
             else {
                 print("show message there is en error")
             }
             
         }
         
         
     }
     
     func renderMarkers(locations : [Company]){
         
         mapView.clear()
         
         for location in locations {

             let marker = GMSMarker()
             let lat = (location.latitude as NSString).doubleValue
             let long = (location.longitude as NSString).doubleValue
             let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
             marker.position = coordinate
             marker.title = "\(location.id)"
             marker.snippet = "\(location.name)"
             let item = POIItem(position: marker.position, name: location.name)
             marker.userData = item
             clusterManager.add(item)
        }
          clusterManager.cluster()
     }
     
     func initClusterManager(){
         
         let iconGenerator = GMUDefaultClusterIconGenerator()
         let algorithm = GMUGridBasedClusterAlgorithm()
         renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
         clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
         clusterManager.setDelegate(self as GMUClusterManagerDelegate, mapDelegate: self)
         renderer.delegate = self
         
     }
     


}

// MARK:- Extensions
extension HomeController: GMSMapViewDelegate ,   GMUClusterManagerDelegate    {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let location: CLLocation = CLLocation(latitude: position.target.latitude, longitude: position.target.longitude)
        print(location.coordinate.latitude)
        print(location.coordinate.longitude)
        
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        
        mapView.selectedMarker = marker
        
        return true
    }
    

    
    func clusterManager(_ clusterManager: GMUClusterManager, didTap clusterItem: GMUClusterItem) -> Bool {
        print("didTap clusterItem")

        return false
    }

    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
       
        let newCamera = GMSCameraPosition.camera(withTarget: cluster.position, zoom: mapView.camera.zoom + 1)
        
        let update = GMSCameraUpdate.setCamera(newCamera)
        
        mapView.moveCamera(update)
        
        return false
     }
}


extension HomeController : GMUClusterRendererDelegate {
    
    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
        
        if let  data =  marker.userData   as? POIItem {
            
            marker.title = data.name
            
            //marker.snippet = "mohannad"
            
            //marker.icon =  UIImage(named: "center_point")!
        }
    }
}


