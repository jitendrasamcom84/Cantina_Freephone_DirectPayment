//
//  FreePhoneUserReceiverListTableViewCell.swift
//  Cantina
//
//  Created by Mac on 24/09/18.
//  Copyright © 2018 AppToDate. All rights reserved.
//

import UIKit

class FreePhoneUserReceiverListTableViewCell: UITableViewCell {
    
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet weak var lblCantinaAccountNumber: UILabel!
    @IBOutlet var lblUserId: UILabel!
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDepositCantina: UIButton!
    @IBOutlet weak var btnDepositFreephone: UIButton!
    
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func setData(userList: Receiver)  {
//        let f_name  = userList.free_receiver_fname ?? ""
//        let l_name  = userList.free_receiver_lname ?? ""
//        lblUserName.text = f_name + " " + l_name
//
//      //  lblCantinaAccountNumber.text = "מס’ חשבוןמס’ חשבון קנטינה: \(userList.user_id ?? "")"
//
//        lblCantinaAccountNumber.text = "מס’ חשבוןמס’ חשבון קנטינה: "
//
//        lblUserId.text = "מס׳ משתמש פריפון:  \(userList.free_user_id ?? "")"
//    }

    
    func setData(receiver:Receiver) {
        lblUserName.text = receiver.receiver_name
        lblCantinaAccountNumber.text = "מס’ חשבון קנטינה: \(receiver.receiver_id ?? "")"
        lblUserId.text = "מס׳ משתמש פריפון: \(receiver.free_user_id ?? "")"
    }
}
