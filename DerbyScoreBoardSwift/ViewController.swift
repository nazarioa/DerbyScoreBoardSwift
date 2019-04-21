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

    var gameClockTimer: Timer?
    var jamClockTimer: Timer?

    var jamTimeLeft = 60

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.playerA = DerbyPlayer(name: "MathKilla", number: "Emc2")
        self.playerB = DerbyPlayer(name: "JamTastik", number: "1")
        jamTimeLeft = 60

        if self.playerA != nil && self.playerB != nil {
            self.jam = DerbyJam(self.playerA!, self.playerB!)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"background")!)
        self.updateJammerScoreLbl(TeamDesignation.Home)
        self.updateJammerScoreLbl(TeamDesignation.Visitor)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillDisappear(_ animated: Bool) {
        jamClockTimer?.invalidate()
    }

    @IBAction func increaseJamScoreTouch(_ sender: UIButton) -> Void {
        let senderName = sender.restorationIdentifier;
        if senderName == "homePointIncrease" {
            self.jam?.addOneTo(TeamDesignation.Home)
            self.updateJammerScoreLbl(TeamDesignation.Home)
        } else if senderName == "visitorPointIncrease" {
            self.jam?.addOneTo(TeamDesignation.Visitor)
            self.updateJammerScoreLbl(TeamDesignation.Visitor)
        }
    }

    @IBAction func decreaseJamScoreTouch(_ sender: UIButton) -> Void {
        let senderName = sender.restorationIdentifier;
        if senderName == "homePointDecrease" {
            self.jam?.subtractOneFrom(TeamDesignation.Home)
            self.updateJammerScoreLbl(TeamDesignation.Home)
        } else if senderName == "visitorPointDecrease" {
            self.jam?.subtractOneFrom(TeamDesignation.Visitor)
            self.updateJammerScoreLbl(TeamDesignation.Visitor)
        }
    }

    func updateJammerScoreLbl(_ team: TeamDesignation) -> Void {
        if team == TeamDesignation.Home {
            self.homeJamScoreLbl.text = "\(self.jam?.homeJamScore ?? 0)";
        } else if team == TeamDesignation.Visitor {
            self.visitorJamScoreLbl.text = "\(self.jam?.visitorJamScore ?? 0)";
        }
    }

    @IBAction func gameClockBtn(_ sender: UIButton) {
        if gameClockTimer?.isValid ?? false {
            gameClockTimer?.invalidate()
        } else {
            gameClockTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(gameClockFire), userInfo: nil, repeats: true)
        }
    }

    @IBAction func jamClockBtn(_ sender: UIButton) {
        if jamClockTimer?.isValid ?? false {
            jamClockTimer?.invalidate()
        } else {
            jamClockTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(jamClockFire), userInfo: nil, repeats: true)
        }
    }

    @objc func gameClockFire() -> Void {
        print("Fire game clock!")
    }

    @objc func jamClockFire() -> Void {
        jamTimeLeft = jamTimeLeft - 1
        jamClockLbl.text = formatTime(jamTimeLeft)
    }

    func formatTime(_ timeSeconds: Int) -> String {
        let hours = Int(timeSeconds) / 3600
        let minutes = Int(timeSeconds) / 60 % 60
        let seconds = Int(timeSeconds) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
}
