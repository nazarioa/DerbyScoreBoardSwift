//
//  ViewController.swift
//  DerbyScoreBoardSwift
//
//  Created by Nazario Ayala on 3/2/19.
//  Copyright © 2019 Nazario Ayala. All rights reserved.
//

import UIKit

enum ClockStartTimes : Int {
    case Bout = 1800
    case Jam = 120
    case Period = 20
}

class ViewController: UIViewController, GameTimerDelegate {
    @IBOutlet weak var gameClockBtn: UIButton!
    @IBOutlet weak var jamClockBtn: UIButton!

    @IBOutlet weak var gameClockLbl: UILabel?
    @IBOutlet weak var jamClockLbl: UILabel?
    @IBOutlet weak var periodClockLbl: UILabel?

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

    var boutClockTimer: GameTimer?
    var jamClockTimer: GameTimer?
    var periodClockTimer: GameTimer?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        primeClocks()
        self.playerA = DerbyPlayer(name: "MathKilla", number: "Emc2")
        self.playerB = DerbyPlayer(name: "JamTastik", number: "1")

        if self.playerA != nil && self.playerB != nil {
            self.jam = DerbyJam(self.playerA!, self.playerB!)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        primeClockDisplays()
        jamClockBtn.addTarget(self, action: #selector(jamClockBtnDoubleTouch(_:event:)), for: UIControl.Event.touchDownRepeat)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"background")!)
        self.updateJammerScoreLbl(TeamDesignation.Home)
        self.updateJammerScoreLbl(TeamDesignation.Visitor)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillDisappear(_ animated: Bool) {}

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
        if self.boutClockTimer?.isRunning() ?? false {
            self.boutClockTimer?.pauseClock()
            self.jamClockTimer?.stopClock()
            self.periodClockTimer?.stopClock()
        } else {
            self.boutClockTimer?.startClock()
        }
    }

    @IBAction func jamClockBtnDoubleTouch(_ sender: UIButton, event: UIEvent) {
        let touch: UITouch = event.allTouches!.first!
        if (touch.tapCount == 2) {
            if self.jamClockTimer?.isRunning() ?? false {
                self.jamClockTimer?.stopClock()
                self.periodClockTimer?.startClock()
            } else {
                self.jamClockTimer?.startClock()
                self.periodClockTimer?.stopClock()
            }
        }
    }

    func clockReachedZero(_ clockName: String) {
        if clockName == "bout" {
            print("Bout clock got to zero")
        } else if clockName == "jam" {
            print("Jam clock got to zero")
        } else if clockName == "period" {
            print("Period clock got to zero")
        }
    }

    func timeHasChangedFor(_ clock: ClockType, time timeInSeconds: Int) {
        if clock == ClockType.Bout {
            self.gameClockLbl?.text = String(format: "%02d:%02d:%02d",
                                            GameTimer.getHoursFromTimeIn(timeInSeconds),
                                            GameTimer.getMinutesFromTimeIn(timeInSeconds),
                                            GameTimer.getSecondsFromTimeIn(timeInSeconds)
            )
        } else if clock == ClockType.Jam {
            self.jamClockLbl?.text = String(format: "%02d:%02d",
                                           GameTimer.getMinutesFromTimeIn(timeInSeconds),
                                           GameTimer.getSecondsFromTimeIn(timeInSeconds)
            )
        } else if clockName == "period" {
            if timeInSeconds < 10 {
                self.periodClockLbl?.textColor = UIColor.red
            } else {
                self.periodClockLbl?.textColor = UIColor.black
            }
            self.periodClockLbl?.text = String(format: "%02d", timeInSeconds)
        }
    }

    private func primeClocks() -> Void {
        if self.boutClockTimer == nil {
            self.boutClockTimer = GameTimer.init("bout", ClockStartTimes.Bout.rawValue, self)
            self.jamClockTimer = GameTimer.init("jam", ClockStartTimes.Jam.rawValue, self)
            self.periodClockTimer = GameTimer.init("period", ClockStartTimes.Period.rawValue, self)
        } else {
            self.boutClockTimer?.pauseClock()
            self.boutClockTimer?.resetClock()

            self.jamClockTimer?.pauseClock()
            self.jamClockTimer?.resetClock()

            self.periodClockTimer?.pauseClock()
            self.periodClockTimer?.resetClock()
        }
    }

    private func primeClockDisplays() -> Void {
        let boutDuration = self.boutClockTimer?.timerDuration() ?? 0
        self.gameClockLbl?.text = String(format: "%02d:%02d:%02d",
                                        GameTimer.getHoursFromTimeIn(boutDuration),
                                        GameTimer.getMinutesFromTimeIn(boutDuration),
                                        GameTimer.getSecondsFromTimeIn(boutDuration)
        )

        let jamDuration = self.jamClockTimer?.timerDuration() ?? 0
        self.jamClockLbl?.text = String(format: "%02d:%02d",
                                       GameTimer.getMinutesFromTimeIn(jamDuration),
                                       GameTimer.getSecondsFromTimeIn(jamDuration)
        )

        self.periodClockLbl?.text = String(format: "%02d", self.periodClockTimer?.timerDuration() ?? 0)
    }
}
