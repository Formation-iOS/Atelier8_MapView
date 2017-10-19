//
//  ViewController.swift
//  Atelier8_MapView
//
//  Created by CedricSoubrie on 18/10/2017.
//  Copyright © 2017 CedricSoubrie. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var unzoomButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    lazy var initialRegion : MKCoordinateRegion = {
        var mapRegion = MKCoordinateRegion()
        mapRegion.center.latitude = 0
        mapRegion.center.longitude = 0
        mapRegion.span.latitudeDelta = 160
        mapRegion.span.longitudeDelta = 180
        return mapRegion
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initMapPoint()
        self.zoomToInitialRegion(animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func initMapPoint () {
        for point in FunMapPoint.allMapPoints {
            let annotation = FunAnnotation(mapPoint: point)
            mapView.addAnnotation(annotation)
        }
    }
    
    private func zoomToInitialRegion (animated: Bool = true) {
        mapView.setRegion(self.initialRegion, animated: animated)
    }
    
    @IBAction func unzoomClicked(_ sender: Any) {
        self.zoomToInitialRegion()
    }
    private func zoom(on annotation: FunAnnotation) {
        var mapRegion = MKCoordinateRegion()
        mapRegion.center = annotation.coordinate
        mapRegion.span.latitudeDelta = annotation.zoom
        mapRegion.span.longitudeDelta = annotation.zoom
        mapView.setRegion(mapRegion, animated: true)
    }
}

extension ViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? FunAnnotation else {
            return nil
        }
        let annotationIdentifier = "FunAnnotation"
        // Reuse a previous annotation view if possible
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier:annotationIdentifier ) {
            annotationView.annotation = annotation
            return annotationView
        }
        // Create a new annotation view if necessary
        else {
            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView.canShowCallout = true
            let zoomButton = UIButton(type: .custom)
            let zoomIcon = #imageLiteral(resourceName: "Zoom")
            zoomButton.setImage(zoomIcon, for: .normal)
            zoomButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            annotationView.rightCalloutAccessoryView = zoomButton
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? FunAnnotation {
            self.mapView.deselectAnnotation(annotation, animated: true)
            self.zoom(on:annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print ("Zoom is \(mapView.region.span)")
        let isZoomed = mapView.region.span.latitudeDelta < self.initialRegion.span.latitudeDelta
        UIView.animate(withDuration: 0.4) {
            self.unzoomButton.isHidden = !isZoomed
        }
    }
}

