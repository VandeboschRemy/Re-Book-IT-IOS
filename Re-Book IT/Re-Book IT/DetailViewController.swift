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
    
    var detailItem: Row?
    
    func configureView() {
        // Update the user interface for the detail item.
        if (detailItem != nil){
            image.image = UIImage(named: "default_image")
            mainTitle.text = detailItem?[Constants.title]
            if(detailItem?[Constants.subTitle] == ""){
                subTitle.text = Constants.noSubTitle
            }
            else{
                subTitle.text = detailItem?[Constants.subTitle]
            }
            price.text = "\(String(format:"%.2f", (detailItem?[Constants.price])!))€"
            edition.text = detailItem?[Constants.edition]
        }
    }

    @IBAction func buttonClick(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

}

