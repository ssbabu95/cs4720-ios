//
//  MapViewController.swift
//  GroceryShopperHelper
//
//  Created by Sumeet on 11/1/15.
//  Copyright © 2015 Sumeet Babu. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var lat: Double!
    var lon: Double!

    @IBOutlet weak var mapView: MKMapView!
     var matchingItems: [MKMapItem] = [MKMapItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let initialLocation = CLLocation(latitude: lat, longitude: lon)
        centerMapOnLocation(initialLocation)
        performSearch()

    }
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    func performSearch() {
        
        matchingItems.removeAll()
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        annotation.title = "Current Location"
        self.mapView.addAnnotation(annotation)
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "Grocery"
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        
        search.startWithCompletionHandler({(response: MKLocalSearchResponse?, error: NSError?) in
            
            if error != nil {
                print("Error occured in search: \(error!.localizedDescription)")
            } else if response!.mapItems.count == 0 {
               print("No matches found")
            } else {
                print("Matches found")
                
                for item in response!.mapItems {
                    print("Name = \(item.name)")
                    print("Phone = \(item.phoneNumber)")
                    
                    self.matchingItems.append(item as MKMapItem)
                    print("Matching items = \(self.matchingItems.count)")
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    self.mapView.addAnnotation(annotation)
                }
            }
        })
    }
    


}
