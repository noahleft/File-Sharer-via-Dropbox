//
//  variableObject.swift
//  FileSharer
//
//  Created by 林世豐 on 29/01/2017.
//  Copyright © 2017 林世豐. All rights reserved.
//

import Foundation


class FileObject : NSObject {
    
    var fileName : String
    var filePath : String
    var id : Int
    var descri: String {
        return "\(id) "+fileName
    }
    
    init(index : Int, name : String, path : String) {
        id = index
        fileName = name
        filePath = path
        
        super.init()
    }
    
    
    
}
