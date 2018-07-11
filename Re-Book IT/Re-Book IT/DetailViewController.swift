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

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = "change me"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    var detailItem: Row? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

