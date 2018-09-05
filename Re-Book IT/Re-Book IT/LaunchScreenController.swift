//
//  LaunchScreenController.swift
//  Re-Book IT
//
//  Created by Remy vandebosch on 5/09/18.
//  Copyright © 2018 Remy vandebosch. All rights reserved.
//

import Foundation
import UIKit

class LaunchScreenController: UIViewController{
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1), execute: {
            self.nameLabel.text = "Re"
        })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(1500), execute: {
            self.nameLabel.text = "Re-Book"
        })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2), execute: {
            self.nameLabel.text = "Re-Book-IT"
        })
    }
}
