//
//  ShareViewController.swift
//  FileSharer
//
//  Created by 林世豐 on 31/01/2017.
//  Copyright © 2017 林世豐. All rights reserved.
//

import Foundation
import Cocoa
import SwiftyDropbox

class ShareViewController: NSViewController {
    
    var file : FileObject? = nil
    var shareLink : String = ""
    @IBOutlet weak var shareLinkTextField: NSTextField!
    @IBOutlet weak var imageView: NSImageView!
    
    @IBAction func pressCloseButton(_ sender: Any) {
        dismiss(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createShareLink()
        
    }
    
    func createShareLink() {
        if let selectedFile : FileObject = file {
            //
            print("select \(selectedFile.fileName) to share")
            
            if let client = DropboxClientsManager.authorizedClient {
                print("dropbox client is auth.")
                
                _ = client.sharing.createSharedLinkWithSettings(path: selectedFile.filePath).response { response, error in
                    if let result = response {
                        print("get share link")
                        print("id: \(result.id) \t name: \(result.name)")
                        print("url: \(result.url)")
                        self.shareLink = result.url
                        self.shareLinkTextField.stringValue = result.url
                        self.generateQRCode()
                    } else {
                        print("Error: \(error!)")
                        self.getShareLink()
                    }
                }
            }
            
        }
    }
    
    func getShareLink() {
        if let selectedFile : FileObject = file {
            //
            print("select \(selectedFile.fileName) to share")
            
            if let client = DropboxClientsManager.authorizedClient {
                print("dropbox client is auth.")
                
                _ = client.sharing.listSharedLinks(path: selectedFile.filePath, cursor: nil, directOnly: nil).response { response, error in
                    if let meta = response {
                        print("get share link")
                        let result = meta.links[0]
                        print("id: \(result.id) \t name: \(result.name)")
                        print("url: \(result.url)")
                        self.shareLink = result.url
                        self.shareLinkTextField.stringValue = result.url
                        self.generateQRCode()
                    } else {
                        print("Error: \(error!)")
                    }
                }
            }
            
        }
    }
    
    func generateQRCode() {
        let QRCodeLink = shareLink.replacingOccurrences(of: "www", with: "dl")
        
        print(QRCodeLink)
        
        if let cifilter : CIFilter = CIFilter(name: "CIQRCodeGenerator") {
            let data = QRCodeLink.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
            cifilter.setValue(data, forKey: "inputMessage")
            cifilter.setValue("Q", forKey: "inputCorrectionLevel")
            if let ciimage : CIImage = cifilter.outputImage {

                let rep = NSCIImageRep(ciImage: ciimage)
                let img = NSImage()
                img.addRepresentation(rep)
                
                let scaleImg = NSImage(size: NSSize(width: 200, height: 200))
                scaleImg.lockFocus()
                NSGraphicsContext.current()?.imageInterpolation = NSImageInterpolation.none
                img.draw(in: NSRect(x: 0, y: 0, width: 200, height: 200))
                scaleImg.unlockFocus()
                imageView.image = scaleImg
            }
        }
    }
    
}
