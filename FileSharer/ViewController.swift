//
//  ViewController.swift
//  FileSharer
//
//  Created by 林世豐 on 23/01/2017.
//  Copyright © 2017 林世豐. All rights reserved.
//

import Cocoa
import SwiftyDropbox


class ViewController: NSViewController {

    @IBOutlet weak var loginButton: NSButton!
    @IBOutlet weak var logoutButton: NSButton!
    @IBOutlet weak var fetchButton: NSButton!
    @IBOutlet weak var accountLabel: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet var arrayController: NSArrayController!
    
    var filenames: Array<String>?
    dynamic var filelist : [FileObject] = []
    dynamic var userAccount : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        checkUI()
    }

    func checkUI() {
        
        if UserDefaults.standard.bool(forKey: "login") {
            loginButton.isHidden = true
            logoutButton.isHidden = false
            accountLabel.isHidden = false
            fetchButton.isHidden = false
        }
        else {
            loginButton.isHidden = false
            logoutButton.isHidden = true
            accountLabel.isHidden = true
            fetchButton.isHidden = true
        }
        
        if let keyAccount = UserDefaults.standard.string(forKey: "account") {
            userAccount = keyAccount
        }
    }
    
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func pressLogin(_ sender: Any) {
        pressLoginButton()
    }
    
    @IBAction func pressFetch(_ sender: Any) {
        fetchFileList()
        checkUI()
    }
    
    @IBAction func pressLogout(_ sender: Any) {
        logoutAccount()
    }
    
    func pressLoginButton() {
        DropboxClientsManager.authorizeFromController(sharedWorkspace: NSWorkspace.shared(),
                                                      controller: self,
                                                      openURL: { (url: URL) -> Void in
                                                        NSWorkspace.shared().open(url)
        })
    }
    
    func logoutAccount() {
        DropboxClientsManager.resetClients()
        UserDefaults.standard.set(false, forKey: "login")
    }
    
    func getCurrentAccount() {
        if let client = DropboxClientsManager.authorizedClient {
            _ = client.users.getCurrentAccount().response { response, error in
                if let result = response {
                    print(result.accountId)
                }
                else {
                    print("request account id fail")
                }
            }
            
        }
    }
    
    func fetchFileList() {
        if let client = DropboxClientsManager.authorizedClient {
            print("dropbox client is auth.")
            
            // List contents of app folder
            _ = client.files.listFolder(path: "").response { response, error in
                if let result = response {
                    self.filelist = []
                    print("Folder contents:")
                    for entry in result.entries {
                        print(entry.name)
                        
                        // Check that file is a photo (by file extension)
                        if entry.name.hasSuffix(".jpg") || entry.name.hasSuffix(".png") {
                            // Add photo!
                            let index : Int = self.filelist.count + 1
                            let file : FileObject = FileObject(index: index, name: entry.name, path: entry.pathLower!)
                            self.filelist.append(file)
                        }
                    }
                    
                } else {
                    print("Error: \(error!)")
                }
            }
            
        }
        else {
            print("dropbox client is not ready.")
        }
    }
    
    @IBAction func pressShareButton(_ sender: Any) {
        
        if let selectedFile : FileObject = arrayController.selectedObjects.first as! FileObject? {
            //
            print("select \(selectedFile.fileName) to share")
            
            if let client = DropboxClientsManager.authorizedClient {
                print("dropbox client is auth.")
                
                _ = client.sharing.createSharedLinkWithSettings(path: selectedFile.filePath).response { response, error in
                    if let result = response {
                        print("get share link")
                        print("id: \(result.id) \t name: \(result.name)")
                        print("url: \(result.url)")
                        
                    } else {
                        print("Error: \(error!)")
                    }
                }
            }
            
        }
        
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == "share" {
            let nextVC = segue.destinationController as! ShareViewController
            nextVC.file = filelist[tableView.selectedRow]
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if tableView.selectedRow < 0 {
            return false
        }
        return true
        
    }

}

