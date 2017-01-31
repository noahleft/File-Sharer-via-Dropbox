//
//  AppDelegate.swift
//  FileSharer
//
//  Created by 林世豐 on 23/01/2017.
//  Copyright © 2017 林世豐. All rights reserved.
//

import Cocoa
import SwiftyDropbox

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        DropboxClientsManager.setupWithAppKeyDesktop("9aji0wsn1xpj392")
        
        NSAppleEventManager.shared().setEventHandler(self,
                                                     andSelector: #selector(handleGetURLEvent),
                                                     forEventClass: AEEventClass(kInternetEventClass),
                                                     andEventID: AEEventID(kAEGetURL))
    }
    
    func handleGetURLEvent(_ event: NSAppleEventDescriptor?, replyEvent: NSAppleEventDescriptor?) {
        if let aeEventDescriptor = event?.paramDescriptor(forKeyword: AEKeyword(keyDirectObject)) {
            if let urlStr = aeEventDescriptor.stringValue {
                let url = URL(string: urlStr)!
                if let authResult = DropboxClientsManager.handleRedirectURL(url) {
                    switch authResult {
                    case .success:
                        print("Success! User is logged into Dropbox.")
                        self.saveAccountName()
                    case .cancel:
                        print("Authorization flow was manually canceled by user!")
                    case .error(_, let description):
                        print("Error: \(description)")
                    }
                }
            }
        }
    }
    
    func saveAccountName() {
        if let client = DropboxClientsManager.authorizedClient {
            _ = client.users.getCurrentAccount().response { response, error in
                if let result = response {
                    print(result.accountId)
                    UserDefaults.standard.set(result.email , forKey: "account")
                    UserDefaults.standard.set(true, forKey: "login")
                }
                else {
                    print("request account id fail")
                }
            }
            
        }
    }

}

