//
//  SideMenuViwController.swift
//  KVRootBaseSideMenu-Swift
//
//  Created by Keshav on 7/3/16.
//  Copyright © 2016 Keshav. All rights reserved.
//

public extension KVSideMenu
{
    // Here define the roots identifier of side menus that must be connected from KVRootBaseSideMenuViewController
    // In Storyboard using KVCustomSegue
    
    //   static public let leftSideViewController   =  "LeftSideViewController"
    static public let rightSideViewController    =  "SideMenuVC"
    
    struct RootsIdentifiers{
        static public let homeVC  =  "HomeVC"
        static public let HomeVC_iPad1x  =  "HomeVC_iPad1x"
        static public let aboutVC     =  "AboutVC"
        static public let termsOfUseVC    =  "TermsOfUseVC"
        static public let qandAVC     =  "QandAVC"
        static public let contactUsVC    =  "ContactUsVC"
    }
    
}


class SideMenuViewController: KVRootBaseSideMenuViewController
{
    var strType = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure The SideMenu
        
        //  leftSideMenuViewController  =  self.storyboard?.instantiateViewController(withIdentifier:KVSideMenu.leftSideViewController)
        rightSideMenuViewController =  self.storyboard?.instantiateViewController(withIdentifier: KVSideMenu.rightSideViewController)
        
        // Set default root
        if(strType == "Home"){
            if UIDevice.isIpadDevice{
                self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.HomeVC_iPad1x)
            }else{
                self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.homeVC)
            }
            
            
        }else if(strType == "Terms"){
            self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.termsOfUseVC)
        }else if(strType == "About"){
            self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.aboutVC)
        }else if(strType == "QuestionAns"){
            self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.qandAVC)
        }else if(strType == "ContactView"){
            self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.contactUsVC)
        }
        
        
        // Set freshRoot value to true/false according to your roots managment polity. By Default value is false.
        // If freshRoot value is ture then we will always create a new instance of every root viewcontroller.
        // If freshRoot value is ture then we will reuse already created root viewcontroller if exist otherwise create it.
        
        // self.freshRoot = true
        
        self.menuContainerView?.delegate = self
        
    }
    
    
}



extension SideMenuViewController: KVRootBaseSideMenuDelegate
{
    func willOpenSideMenuView(_ sideMenuView: KVMenuContainerView, state: KVSideMenu.SideMenuState) {
        print(#function)
    }
    
    func didOpenSideMenuView(_ sideMenuView: KVMenuContainerView, state: KVSideMenu.SideMenuState){
        print(#function)
    }
    
    func willCloseSideMenuView(_ sideMenuView: KVMenuContainerView, state: KVSideMenu.SideMenuState){
        print(#function)
    }
    
    func didCloseSideMenuView(_ sideMenuView: KVMenuContainerView, state: KVSideMenu.SideMenuState){
        print(#function)
    }
}



