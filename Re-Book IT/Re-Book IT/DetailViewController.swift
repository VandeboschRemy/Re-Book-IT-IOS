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
    
    var detailItem: Row?
    
    func configureView() {
        // Update the user interface for the detail item.
        if (detailItem != nil){
            mainTitle.text = detailItem?[Constants.title]
            subTitle.text = detailItem?[Constants.subTitle]
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

}

