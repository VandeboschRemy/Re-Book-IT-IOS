//
//  DetailViewController.swift
//  Re-Book IT
//
//  Created by Remy vandebosch on 11/07/18.
//  Copyright © 2018 Remy vandebosch. All rights reserved.
//

import UIKit
import SQLite

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var edition: UILabel!
    @IBOutlet weak var isbn: UILabel!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var quality: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var courses: UILabel!
    @IBOutlet weak var universities: UILabel!
    
    var detailItem: Row?
    
    func configureView() {
        // Update the user interface for the detail item.
        if (detailItem != nil){
            image.image = UIImage(named: "default_image")
            mainTitle.text = detailItem?[Constants.title]
            //set title of view to title of the book
            self.navigationItem.title = detailItem?[Constants.title]
            if(detailItem?[Constants.subTitle] == ""){
                subTitle.text = Constants.noSubTitle
            }
            else{
                subTitle.text = detailItem?[Constants.subTitle]
            }
            price.text = "\(String(format:"%.2f", (detailItem?[Constants.price])!))€"
            edition.text = detailItem?[Constants.edition]
            isbn.text = "ISBN: \(detailItem?[Constants.isbn] ?? "0")"
            count.text = "count: \(detailItem?[Constants.count] ?? "0")"
            quality.text = "quality: \(detailItem?[Constants.quality] ?? "0")%"
            if(detailItem?[Constants.authors] == "[]"){
                author.text = Constants.noAuthor
            }
            else{
                author.text = "authors: \n\(detailItem?[Constants.authors] ?? Constants.noAuthor)"
                author.text = author.text?.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
            }
            if(detailItem?[Constants.courses] == "[]"){
                courses.text = Constants.noCourses
            }
            else{
                courses.text = "courses: \n\(detailItem?[Constants.courses] ?? Constants.noCourses)"
                courses.text = courses.text?.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
            }
            if(detailItem?[Constants.institutions] == "[]"){
                universities.text = Constants.noUniversities
            }
            else{
                universities.text = "universities: \n\(detailItem?[Constants.institutions] ?? Constants.noUniversities)"
                universities.text = universities.text?.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
            }
            let url = "https://rebookit.be/\(detailItem?[Constants.imageUrl] ?? "")"
            getImage(url: url)
        }
    }

    @IBAction func buttonClick(_ sender: Any) {
        let url = URL(string: "https://rebookit.be/login")
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.share, style: .plain, target: self, action: #selector(shareButtonPressed))
        configureView()
    }
    
    //Download the image pf the book in async
    func getImage(url: String){
        
        let queue = DispatchQueue.main
        
        queue.async(){
            // make a request to the webserver
            let request = NSMutableURLRequest()
            request.url = URL(string: url)
            request.httpMethod = "GET"
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
                if(error == nil){
                    //convert data to image
                    self.image.image = UIImage(data: data!)
                }
                else{
                    print(error ?? "")
                }
            })
            task.resume()
        }
    }
    
    //executed when the share button id pressed
    @objc func shareButtonPressed(){
        let text:String = """
        \(Constants.shareBegin)\n
        \(mainTitle.text!)\n
        \(author.text!)\n
        \(isbn.text!)\n
        \(quality.text!)\n
        \(Constants.shareEnd)
        """
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        self.present(activityViewController, animated: true, completion: nil)
    }
}

