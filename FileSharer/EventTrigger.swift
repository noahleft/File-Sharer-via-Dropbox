//
//  EventTrigger.swift
//  FileSharer
//
//  Created by 林世豐 on 01/02/2017.
//  Copyright © 2017 林世豐. All rights reserved.
//

import Foundation


class EventTrigger: NSObject {
    
    var UI_modify = 0
    
    func triggerUI() {
        willChangeValue(forKey: "UI_modify")
        UI_modify += 1
        didChangeValue(forKey: "UI_modify")
    }
    
    
}

var eventManager : EventTrigger = EventTrigger()
