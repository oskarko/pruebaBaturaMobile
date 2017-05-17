//
//  AboutMeViewController.swift
//  PokeB
//
//  Created by Oscar Rodriguez Garrucho on 11/5/17.
//  Copyright © 2017 Oscar Rodriguez Garrucho. All rights reserved.
//

import UIKit
import MapKit

class AboutMeViewController: UIViewController {

    @IBOutlet weak var myPhoto: UIImageView!
    @IBOutlet weak var myName: UILabel!
    @IBOutlet weak var myEmail: UILabel!
    @IBOutlet weak var myNumber: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myName.text = "Óscar"
        myEmail.text = "oskarko1981"
        myNumber.text = "+34 666 66 66 66"
        // Do any additional setup after loading the view.
        // set initial location in madrid
        let initialLocation = CLLocation(latitude: 40.4167018, longitude: -3.703778800000009)
        centerMapOnLocation(location: initialLocation)
        
        // show pin on map
        let artwork = Artwork(title: "I'm here!",
                              locationName: "Madrid",
                              discipline: "Madrid",
                              coordinate: CLLocationCoordinate2D(latitude: 40.4167018, longitude: -3.703778800000009))
        
        map.addAnnotation(artwork)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // center in map
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
