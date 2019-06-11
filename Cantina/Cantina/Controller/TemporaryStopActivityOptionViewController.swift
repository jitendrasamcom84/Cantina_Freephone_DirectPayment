//
//  TemporaryStopActivityOptionViewController.swift
//  Cantina
//
//  Created by Divyesh Khatri on 15/11/18.
//  Copyright © 2018 AppToDate. All rights reserved.
//

import UIKit

class TemporaryStopActivityOptionViewController: UIViewController {

    @IBOutlet var lblAlertMessage: UILabel!
    
    var alertMessage = String()
    
    //MARK: Initializer
    
    class func initViewController() -> TemporaryStopActivityOptionViewController {
        let vc = TemporaryStopActivityOptionViewController.init(nibName: "TemporaryStopActivityOptionViewController", bundle: nil)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblAlertMessage.text = alertMessage
    }

}
