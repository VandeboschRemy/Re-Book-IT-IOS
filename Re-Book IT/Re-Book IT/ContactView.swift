//
//  ContactView.swift
//  Re-Book IT
//
//  Created by Remy vandebosch on 30/08/18.
//  Copyright © 2018 Remy vandebosch. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class ContactView: UIViewController{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var timetable: UILabel!
    @IBOutlet weak var timeTableHeader: UILabel!
    @IBOutlet weak var adressHeader: UILabel!
    @IBOutlet weak var adress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timetable.text = Constants.timeTableWait
        timeTableHeader.text = Constants.timeTableHeader
        adressHeader.text = Constants.addressHeader
        adress.text = Constants.address
        self.downloadOpeningHours()
        self.loadMap()
    }
    
    func loadMap(){
        // set location
        let location = CLLocation(latitude: 50.9255981, longitude: 5.3909875)
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        let pin : MKAnnotation = MapPin(coordinate: CLLocationCoordinate2D(latitude: 50.9255981, longitude: 5.3909875), title: Constants.markerTitle)
        mapView.addAnnotation(pin)
    }
    
    // Download the opening hours
    func downloadOpeningHours(){
        let queue = DispatchQueue.main
        
        queue.async(){
            // make a request to the webserver
            let request = NSMutableURLRequest()
            request.url = URL(string: "https://rebookit.be/contact")
            request.httpMethod = "GET"
            
            let session = URLSession(configuration: URLSessionConfiguration.default)

            let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in

                if(error == nil){
                    let hours = self.extractOpeningHours(text: String(data: data!, encoding: String.Encoding.utf8)!)
                    self.showOpening(hours: hours)
                }
                else{
                    print("error: \(error)")
                }
            })
            task.resume()
        }
    }
    
    func extractOpeningHours(text: String) -> String{

        let startIndex = indexOf(string: text, subString: "Openingsuren</h4>") + "Openingsuren</h4>                                     <p>".count
        let start = text.index(text.startIndex, offsetBy: startIndex)

        let endIndex = lastIndexOf(string: text, subString: "Gesloten") + "Gesloten".count
        let end = text.index(text.startIndex, offsetBy: endIndex)

        let range = start..<end
        
        if(startIndex == -1 || endIndex == -1){
            return "nil"
        }
        else{
            var output: String = ""
            for sub in text.substring(with: range).components(separatedBy: "<br>"){
                let subTrimmed = sub.trimmingCharacters(in: .whitespacesAndNewlines) + "\n"
                output += subTrimmed
            }
            return output
        }
    }
    
    //find start index of a substring in a string
    func indexOf(string: String, subString: String) -> Int{
        var index = 0
        
        // Loop through parent string looking for the first character of the substring
        for char in string{
            if (subString.first == char) {
                let startOfFoundCharacter = string.index(string.startIndex, offsetBy: index)
                let lengthOfFoundCharacter = string.index(string.startIndex, offsetBy: subString.count + index)
                let range = startOfFoundCharacter..<lengthOfFoundCharacter
                
                // Grab the substring from the parent string and compare it against substring
                // Essentially, looking for the needle in a haystack
                if string.substring(with: range) == subString {
                    return index
                    break
                }
                
            }
            index += 1
        }
        return -1
    }
    
    //find the start index of last time the substring appears in the main text
    func lastIndexOf(string: String, subString: String) -> Int{
        var index = 0
        var lastIndex = 0
        
        // Loop through parent string looking for the first character of the substring
        for char in string{
            if (subString.first == char) {
                let startOfFoundCharacter = string.index(string.startIndex, offsetBy: index)
                let lengthOfFoundCharacter = string.index(string.startIndex, offsetBy: subString.count + index)
                let range = startOfFoundCharacter..<lengthOfFoundCharacter
                
                // Grab the substring from the parent string and compare it against substring
                // Essentially, looking for the needle in a haystack
                if string.substring(with: range) == subString {
                    lastIndex = index
                }
                
            }
            index += 1
        }
        if(lastIndex != 0){
            return lastIndex
        }
        else{
            return -1
        }
    }
    
    func showOpening(hours: String){
        if(hours != "nil"){
            timetable.text = hours
        }
        else{
            print("error")
        }
    }
}


class MapPin : NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var myTitle: String
    
    init(coordinate: CLLocationCoordinate2D!, title: String!){
        self.coordinate = coordinate
        self.myTitle = title
    }
}
