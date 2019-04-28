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

    func calculateTotalScore(_ team: TeamDesignation) -> Int? {
        if team == TeamDesignation.Home {
            return self.jamLog?.reduce(0, {total, jam in total + jam.homeJamScore}) ?? 0
        } else if team == TeamDesignation.Visitor {
            return self.jamLog?.reduce(0, {total, jam in total + jam.visitorJamScore}) ?? 0
        }
        return nil
    }

    func numberOfJams() -> Int {
        return self.jamLog?.count ?? 0
    }
}
