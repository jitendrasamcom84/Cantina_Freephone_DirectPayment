
import UIKit
import Foundation

//Server URL

//let kBaseUrl                              =   "http://dev.cantinadigital.co.il:8080/"

let kBaseUrl                                =   "http://cantinadigital.co.il:8080/" // client live server

//Account
let kLogin                              =   "auth/local"
let kRegister                           =   "api/users/register/local"
let kForgotPassword                     =   "api/users/passwordreset"

//Payment
let kAddPayment                         =   "api/payments/add_payment"
let kSendPaymentApi                     =  "api/payments/send_payment"
let kSendDebitApi                       =  "api/payments/send_debit"
let kGetPaymentHistory                  =  "api/query/execute/conditions/Payments"

let kGetPaymentHistoryNewAPI            =  "api/users/GetPaymentHistory"

//My Contacts
let kGetContactList                     =  "api/receivers/list"
let kAddContact                         =  "api/users/addreceviers"
//let kEditContact                        =  "api/query/Receivers"
let kEditContact                        =  "api/users/editrecevier"
let kDeleteContact                      =  "api/query/soft/Receivers/"
let kContactUs                          = "api/contactus"

// Debit
let kGetUserDebitList                   = "api/payments/directdebituserlist"
let kEditDebitList                      = "api/query/DirectDebit/"
let kAddDebitList                       = "api/query/DirectDebit/"
let kDeleteDebit                        = "api/query/soft/DirectDebit/"
let kPaymentUrl                         = "api/payments/"
let kAbout                              = "api/query/About/"
let kQA                                 = "api/query/QA/"
let kTerms                              = "api/query/Terms/"
let kTranzilaToken                      = "api/query/execute/conditions/TranzilaToken/"
let kGetCommission                      = "api/commission/getcommission"
let kSave_card                          = "api/payments/save_card"
let KGetCommissionCalculation           = "api/query/Commission_Calculation"
let kGetUpdateVersion                   = "api/notifications/get_version_code"

//MARK: FreePhone APIs
let kGetUserList                        = "api/freephone/userlist"
let kFreePhoneDeposit                   = "api/freephone/deposit"
let KRegisterFreePhoneUser              = "api/freephone/reg_freephone_user"
let KFreePhoneAddDeposit                = "api/freephone/add_deposit"
let KFreePhoneCheck_user                = "api/freephone/check_user"
let kCreateUser                         = "api/freephone/creat_user"
let kDeleteUser                         = "api/freephone/softdelete"
let kGetFreephoneCommission             = "api/commission/GetFreephoneCommission"
let kGetFreephoneCalcukateCommission    = "api/query/Freephone_Commission_Calculation"

let kGetCantinaANDFreephoneReceiverList = "api/receivers/GetCantinaANDFreephoneReceiverList"

let kGetAppStatus                       = "api/notifications/get_app_status"
