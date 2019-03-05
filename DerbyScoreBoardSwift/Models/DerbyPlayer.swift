//
//  DerbyPlayer.swift
//  DSBv2
//
//  Created by Nazario Ayala on 3/4/19.
//  Copyright © 2019 Nazario Ayala. All rights reserved.
//

import UIKit

class DerbyPlayer {
    var name: String;
    var number: String;
    
    init?(name: String, number: String) {
        if name.isEmpty || number.isEmpty {
            return nil;
        }
        
        self.name = name;
        self.number = number;
    }
}
