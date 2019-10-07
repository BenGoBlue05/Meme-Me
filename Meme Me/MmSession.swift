//
//  MmSession.swift
//  Meme Me
//
//  Created by Ben Lewis on 10/6/19.
//  Copyright © 2019 Ben Lewis. All rights reserved.
//

import Foundation

class MmSession {
    
    var memes = [Meme]()
    
    static let sharedInstance: MmSession = {
        let instance = MmSession()
        return instance
    }()
}
