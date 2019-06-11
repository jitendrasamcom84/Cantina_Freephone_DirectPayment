//
//  FreePhoneUserReceiverListVC.swift
//  Cantina
//
//  Created by Mac on 24/09/18.
//  Copyright © 2018 AppToDate. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

@objc protocol UserListDelegate{
    func selectedUser(user:Receiver)
}

class FreePhoneUserReceiverListVC: BaseViewController, NVActivityIndicatorViewable {
    
    var userListArray = [Receiver]()
    
    var delegate :  UserListDelegate? = nil
    
    @IBOutlet var tblUserList: UITableView!
    
    
    //MARK: Initializer
    
    class func initViewController() -> FreePhoneUserReceiverListVC {
        let vc = FreePhoneUserReceiverListVC.init(nibName: "FreePhoneUserReceiverListVC", bundle: nil)
        return vc
    }

    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblUserList.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(AccountManager.instance().activeAccount != nil){
             self.userListArray.removeAll()
            userListArray = Receiver.getAll()
            loadUserListApi()
            tblUserList.reloadData()
        }else{
            Utils.showAlert(withMessage: "Unauthorized Request, Please sign in first.")
        }
    }
    
    //MARK: IB Actions
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickedAddNewRecipient(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: isFreePhoneNewUser)
        let controller = AddNewContactVC.initViewController()
        self.navigationController?.pushViewController(controller, animated: true)
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let vc = storyBoard.instantiateViewController(withIdentifier: "UserRegistrationVC") as! UserRegistrationVC
//        self.navigationController?.pushViewController(vc, animated: true)
    }
   
    //MARK: API Call
    
    func loadUserListApi() {
        startAnimating(loaderSize, message: tPleaseWait, type: NVActivityIndicatorType.ballRotate)
        Manager.sharedManager().getCantinaAndFreePhoneUserList { (result, errorMessage) -> (Void) in
            self.stopAnimating()
            if (errorMessage.count > 0) {
                Utils.showAlert(withMessage: errorMessage)
            }
            else{
                self.userListArray.removeAll()
                self.userListArray = Receiver.getAll()
                self.tblUserList.reloadData()
            }
        }
        
        
//        Manager.sharedManager().loadUserList { (result, errorMessage) -> (Void) in
//            self.stopAnimating()
//            if(errorMessage.count > 0){
//                Utils.showAlert(withMessage: errorMessage)
//            }else{
//                self.userListArray.removeAll()
//                self.userListArray = UserList.getAll()!
//                self.tblUserList.reloadData()
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: Tableview Delegate Methods

extension FreePhoneUserReceiverListVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tblUserList.dequeueReusableCell(withIdentifier: "FreePhoneUserReceiverListTableViewCell") as? FreePhoneUserReceiverListTableViewCell
        if cell == nil {
            var nib = Bundle.main.loadNibNamed("FreePhoneUserReceiverListTableViewCell", owner: self, options: nil)
            cell = nib?[0] as? FreePhoneUserReceiverListTableViewCell
            cell?.selectionStyle = .none
        }
        cell?.selectionStyle = .none
        
        let receiver: Receiver = userListArray[indexPath.row]
        cell?.setData(receiver: receiver)
        
        if receiver.receiver_id == nil {
            cell?.btnDepositCantina.isHidden = true
        }
        else{
            cell?.btnDepositCantina.isHidden = false
        }
        
        if receiver.main_free_user_id == nil {
            cell?.btnDepositFreephone.isHidden = true
        }
        else{
            cell?.btnDepositFreephone.isHidden = false
        }
        
        cell?.btnEdit.tag = indexPath.row
        cell?.btnEdit.addTarget(self, action: #selector(editClicked(btn:)), for: .touchUpInside)
        
        cell?.btnDepositCantina.tag = indexPath.row
        cell?.btnDepositCantina.addTarget(self, action: #selector(depositCantinaClicked(btn:)), for: .touchUpInside)
        
        cell?.btnDepositFreephone.tag = indexPath.row
        cell?.btnDepositFreephone.addTarget(self, action: #selector(depositFreephoneClicked(btn:)), for: .touchUpInside)
        
        return cell!
    }
    
    @objc func editClicked(btn:UIButton) {
        let selectedContact = userListArray[btn.tag]
        let controller = ContactDetailVC.initViewController(contact: selectedContact)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func depositCantinaClicked(btn:UIButton) {
        let selectedContact = userListArray[btn.tag]
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let controller : Payment1VC  = storyBoard.instantiateViewController(withIdentifier: "Payment1VC") as! Payment1VC
        controller.isFromReceiverPage = true
        controller.receiver = selectedContact
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func depositFreephoneClicked(btn:UIButton) {
        let selectedUser = userListArray[btn.tag]
        delegate?.selectedUser(user: selectedUser)
        UserDefaults.standard.set(false, forKey: isFreePhoneNewUser)
        self.navigationController?.popViewController(animated: true)
    }
    
}
