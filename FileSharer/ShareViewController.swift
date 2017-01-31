//
//  ShareViewController.swift
//  FileSharer
//
//  Created by 林世豐 on 31/01/2017.
//  Copyright © 2017 林世豐. All rights reserved.
//

import Foundation
import Cocoa

class ShareViewController: NSViewController {
    
    var file : FileObject? = nil
    
    @IBAction func pressCloseButton(_ sender: Any) {
        dismiss(self)
    }
    
    override func viewDidLoad() {
        print(file?.descri)
    }
    
    
}
