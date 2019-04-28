//
//  DerbyBout.swift
//  DSBv2
//
//  Created by Nazario Ayala on 4/27/19.
//  Copyright © 2019 Nazario Ayala. All rights reserved.
//

import Foundation

class DerbyBout {
    private var boutEventDate: Date?
    private var jamLog: Array<DerbyJam>?

    init() {
        self.boutEventDate = Date()
        self.jamLog = []
    }

    func addJam(_ jam: DerbyJam) -> Void {
        self.jamLog?.append(jam)
    }
}
