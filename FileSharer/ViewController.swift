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
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet var arrayController: NSArrayController!
    
    var filenames: Array<String>?
    dynamic var filelist : [FileObject] = []
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
        checkLoginButton()
    }
    
    func checkLoginButton() {
        if (DropboxClientsManager.authorizedClient != nil) {
            loginButton.isHidden = true
        }
    }
    
    func pressLoginButton() {
        DropboxClientsManager.authorizeFromController(sharedWorkspace: NSWorkspace.shared(),
                                                      controller: self,
                                                      openURL: { (url: URL) -> Void in
                                                        NSWorkspace.shared().open(url)
        })
    }
    
    func fetchFileList() {
        if let client = DropboxClientsManager.authorizedClient {
            print("dropbox client is auth.")
            
            // List contents of app folder
            _ = client.files.listFolder(path: "").response { response, error in
                if let result = response {
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
//                // List contents of app folder
//                _ = client.files.listFolder(path: "").response { response, error in
//                    if let result = response {
//                        print("Folder contents:")
//                        for entry in result.entries {
//                            print(entry.name)
//                            
//                            // Check that file is a photo (by file extension)
//                            if entry.name.hasSuffix(".jpg") || entry.name.hasSuffix(".png") {
//                                // Add photo!
//                                let index : Int = self.filelist.count + 1
//                                var file : FileObject = FileObject(index: index, name: entry.name)
//                                self.filelist.append(file)
//                            }
//                        }
//                        
//                    } else {
//                        print("Error: \(error!)")
//                    }
//                }
                
            }
            
        }
        
    }
    

}

