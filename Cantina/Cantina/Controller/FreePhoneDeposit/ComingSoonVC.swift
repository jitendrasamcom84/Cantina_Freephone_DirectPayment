//
//  ComingSoonVC.swift
//  Cantina
//
//  Created by Divyesh Khatri on 08/10/18.
//  Copyright © 2018 AppToDate. All rights reserved.
//

import UIKit

class ComingSoonVC: BaseViewController {
    
    //MARK: Initializer
    
    class func initViewController() -> ComingSoonVC {
        let vc = ComingSoonVC.init(nibName: "ComingSoonVC", bundle: nil)
        return vc
    }

    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: IB Actions
    
    @IBAction func backToHomeClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
