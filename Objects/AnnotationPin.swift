//
//  AnnotationPin.swift
//  YogaFit
//
//  Created by EUGENE on 08.06.2018.
//  Copyright © 2018 Eugene Zloba. All rights reserved.
//
import MapKit
import AddressBook

class AnnotationPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    //var idOwner: String?
    
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
      //  self.idOwner = idOwner
        super.init()
    }
    
    
    func mapItem() -> MKMapItem
    {
        let addressDictionary = [String(kABPersonAddressStreetKey) : subtitle]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        let mapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = "\(title) \(subtitle)"
        
        return mapItem
    }
    
}
