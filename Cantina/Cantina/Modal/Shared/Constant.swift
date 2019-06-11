
import UIKit
import Foundation

typealias ItemLoadedBlock = (_ result: Any, _ error : String) -> (Void)
typealias ItemSavedBlock = (_ result: Any,  _ error : String) -> (Void)
typealias CellActionBlock = (_ anyObject: Any) -> (Void)
typealias CallBackCompletion = (_ object: Any) -> (Void)

@available(iOS 10.0, *)
let loaderSize = CGSize(width: 30, height: 30)
let appDelegateShared = UIApplication.shared.delegate as? AppDelegate

let kHideBlurredEffectView                    = "kHideBlurredEffectView"
let kFCMToken                                 = "kFCMToken"
let kSideMenuSelectedIndex                    = "kSideMenuSelectedIndex"
let SideMenuHomeVC                            = "SideMenuHomeVC"
let SideMenuAboutVC                           = "SideMenuAboutVC"
let SideMenuTermsOfUseVC                      = "SideMenuTermsOfUseVC"
let SideMenuQandAVC                           = "SideMenuQandAVC"
let SideMenuContactUsVC                       = "SideMenuContactUsVC"
let SideMenuSignOut                           = "SideMenuSignOut"
let KReloadTable                              = "ReloadTable"
let kLoginStatus                              = "kLoginStatus"
let kCountryCode                              = ""
let kLoginAutheticationHeader                 = "LoginAutheticationHeader"
let kPaymentType                              = "PaymentType"
let kLoadConatcts                             = "LoadConatcts"
let kLoadDebitListNotification                = "kLoadDebitListNotification"
let kOpenLoginPage                            = "kOpenLoginPage"
let kLogout                                   = "kLogout"

//Free Phone Notification Keys
let KUserSelected                             = "kUserSelected"

let kCheckUserExists                          = "CheckUserExists"
let kCheckUserExistsWithObject                = "CheckUserExistsWithObject"

//Free Phone User Default
let isFreePhoneNewUser = "isFreePhoneNewUser"
let isUserSelected = "isUserSelected"


