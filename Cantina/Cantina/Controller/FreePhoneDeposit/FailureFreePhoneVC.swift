//
//  FailureFreePhoneVC.swift
//  Cantina
//
//  Created by Mac on 20/09/18.
//  Copyright © 2018 AppToDate. All rights reserved.
//

import UIKit

class FailureFreePhoneVC: BaseViewController {

    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tryAgainClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
//        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
//        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true);
    }
    
    @IBAction func backToHomeClicked(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        
//        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
//        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
