//
//  DerbyJame.swift
//  DSBv2
//
//  Created by Nazario Ayala on 3/4/19.
//  Copyright © 2019 Nazario Ayala. All rights reserved.
//

import UIKit

class DerbyJam {
    var homeJamScore: Int = 0;
    var visitorJamScore: Int = 0;
    
    var homeJammer: DerbyPlayer;
    var visitorJammer: DerbyPlayer;
    
    var leadJammerStatus: TeamDesignation;

    init(_ homeJammer: DerbyPlayer, _ visitorJammer: DerbyPlayer) {
        self.homeJamScore = 0;
        self.visitorJamScore = 0;
        self.homeJammer = homeJammer;
        self.visitorJammer = visitorJammer;
        self.leadJammerStatus = TeamDesignation.None;
    }
    
    func addOneTo(_ team: TeamDesignation) -> Void {
        if team == TeamDesignation.Home {
            self.homeJamScore += 1;
        } else if team == TeamDesignation.Visitor {
            self.visitorJamScore += 1;
        }
    }
    
    func subtractOneFrom(_ team: TeamDesignation) -> Void {
        if team == TeamDesignation.Home {
            if self.homeJamScore > 0 { self.homeJamScore -= 1; }
        } else if team == TeamDesignation.Visitor {
            if self.visitorJamScore > 0 { self.visitorJamScore -= 1; }
        }
    }
    
    func setJammer(player jammer: DerbyPlayer, for team: TeamDesignation) -> Void {
        if team == TeamDesignation.Home {
            self.homeJammer = jammer;
        } else if team == TeamDesignation.Visitor {
            self.visitorJammer = jammer;
        }
    }

    func setLeadJammer(is team: TeamDesignation) -> Void {
        self.leadJammerStatus = team;
    }
}
