//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Christopher Whidden on 5/17/15.
//  Copyright (c) 2015 SelfEdge Software. All rights reserved.
//

import Foundation

class RecordedAudio {
    var filePathURL: NSURL
    var title: String
    
    init(URL: NSURL, title: String) {
        filePathURL = URL
        self.title = title
    }
}