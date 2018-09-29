//
//  InformationViewController.swift
//  Re-Book IT
//
//  Created by Remy vandebosch on 4/09/18.
//  Copyright © 2018 Remy vandebosch. All rights reserved.
//

import Foundation
import UIKit

class InformationViewController: UIViewController{
    

    @IBOutlet weak var priceInfoHeader: UILabel!
    @IBOutlet weak var infoPriceAndQuality: UILabel!
    @IBOutlet weak var greenInfo: UILabel!
    @IBOutlet weak var redInfo: UILabel!
    @IBOutlet weak var greyInfo: UILabel!
    @IBOutlet weak var yellowInfo: UILabel!
    @IBOutlet weak var warrantyHeader: UILabel!
    @IBOutlet weak var warrantyInfo: UILabel!
    @IBOutlet weak var authorInfo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        priceInfoHeader.text = Constants.priceInfoHeader
        infoPriceAndQuality.text = Constants.priceInfo
        greenInfo.text = Constants.greenInfo
        redInfo.text = Constants.redInfo
        greyInfo.text = Constants.greyInfo
        yellowInfo.text = Constants.yellowInfo
        warrantyHeader.text = Constants.warrantyHeader
        warrantyInfo.text = Constants.warrantyInfo
        authorInfo.text = Constants.authorInfo
    }
}
