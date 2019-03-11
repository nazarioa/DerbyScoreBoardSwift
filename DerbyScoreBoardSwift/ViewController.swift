//
//  ViewController.swift
//  DerbyScoreBoardSwift
//
//  Created by Nazario Ayala on 3/2/19.
//  Copyright © 2019 Nazario Ayala. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var gameClockBtn: UIButton!
    @IBOutlet weak var jamClockBtn: UIButton!
    @IBOutlet weak var gameClockLbl: UILabel!
    @IBOutlet weak var jamClockLbl: UILabel!
    
    @IBOutlet weak var homeNameLbl: UILabel!
    @IBOutlet weak var homePlusBtn: UIButton!
    @IBOutlet weak var homeMinusBtn: UIButton!
    @IBOutlet weak var homeJamScoreLbl: UILabel!
    @IBOutlet weak var homeJamTotalLbl: UILabel!
    @IBOutlet weak var homeLeadBtn: UIButton!
    @IBOutlet weak var homeTimeOutBtn: UIButton!
    
    @IBOutlet weak var visitorNameLbl: UILabel!
    @IBOutlet weak var visitorPlusButton: UIButton!
    @IBOutlet weak var visitorMinusButton: UIButton!
    @IBOutlet weak var visitorJamScoreLbl: UILabel!
    @IBOutlet weak var visitorJamTotalLbl: UILabel!
    @IBOutlet weak var visitorLeadBtn: UIButton!
    @IBOutlet weak var visitorTimeOutBtn: UIButton!
    
    
    var jam: DerbyJam?
    var playerA: DerbyPlayer?
    var playerB: DerbyPlayer?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.playerA = DerbyPlayer(name: "MathKilla", number: "Emc2")
        self.playerB = DerbyPlayer(name: "JamTastik", number: "1")

        if self.playerA != nil && self.playerB != nil {
            self.jam = DerbyJam(self.playerA!, self.playerB!)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"background")!)
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func increaseJamScoreTouch(_ sender: UIButton) -> Void {
        let senderName = sender.restorationIdentifier;
        if senderName == "homePointIncrease" {
            self.jam?.addOneTo(TeamDesignation.Home)
        } else if senderName == "visitorPointIncrease" {
            self.jam?.addOneTo(TeamDesignation.Visitor)
        }
    }

    @IBAction func decreaseJamScoreTouch(_ sender: UIButton) -> Void {
        let senderName = sender.restorationIdentifier;
        if senderName == "homePointDecrease" {
            self.jam?.subtractOneFrom(TeamDesignation.Home)
        } else if senderName == "visitorPointDecrease" {
            self.jam?.subtractOneFrom(TeamDesignation.Visitor)
        }
    }
}
