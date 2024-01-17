//
//  GGMapsViewController.swift
//  Newsapp
//
//  Created by LinhMAC on 16/09/2023.
//

import UIKit
import GoogleMaps

class GGMapsViewController: UIViewController {

    @IBOutlet weak var googleMapView: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        googleMapView.settings.myLocationButton = true
        googleMapView.isMyLocationEnabled = true
//        googleMapView.camera = ggCamera

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
