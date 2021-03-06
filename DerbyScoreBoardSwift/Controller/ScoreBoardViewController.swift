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
    @IBOutlet weak var numberOfJamsLbl: UILabel?
    @IBOutlet weak var externalScreensBtn: UIButton?

    @IBOutlet weak var gameClockBtn: UIButton!
    @IBOutlet weak var jamClockBtn: UIButton!

    @IBOutlet weak var gameClockLbl: UILabel?
    @IBOutlet weak var jamClockLbl: UILabel?
    @IBOutlet weak var periodClockLbl: UILabel?

    @IBOutlet weak var homeNameLbl: UILabel!
    @IBOutlet weak var homePlusBtn: UIButton!
    @IBOutlet weak var homeMinusBtn: UIButton!
    @IBOutlet weak var homeJamScoreLbl: UILabel?
    @IBOutlet weak var homeTotalScoreLbl: UILabel?
    @IBOutlet weak var homeLeadBtn: UIButton!
    @IBOutlet weak var homeTimeOutBtn: UIButton!
    
    @IBOutlet weak var visitorNameLbl: UILabel!
    @IBOutlet weak var visitorPlusButton: UIButton!
    @IBOutlet weak var visitorMinusButton: UIButton!
    @IBOutlet weak var visitorJamScoreLbl: UILabel?
    @IBOutlet weak var visitorTotalScoreLbl: UILabel?
    @IBOutlet weak var visitorLeadBtn: UIButton!
    @IBOutlet weak var visitorTimeOutBtn: UIButton!

    private var theGame: DerbyBout?
    private var currentJam: DerbyJam?

    private var extScreen: UIScreen?
    private var spectatorWindow: UIWindow?
    private var spectatorViewController: SpectatorScreenViewController?

    var boutClockTimer: GameTimer?
    var jamClockTimer: GameTimer?
    var periodClockTimer: GameTimer?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        primeClocks()

        if self.theGame == nil {
            self.theGame = DerbyBout()
        }

        if self.currentJam == nil {
            self.currentJam = DerbyJam(DerbyPlayer(name: "MathKilla", number: "Emc2")!, DerbyPlayer(name: "JamTastik", number: "1")!)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        primeClockDisplays()
        self.resetJamScoreLbls()
        self.homeTotalScoreLbl?.text = "0"
        self.visitorTotalScoreLbl?.text = "0"
        jamClockBtn.addTarget(self, action: #selector(jamClockBtnDoubleTouch(_:event:)), for: UIControl.Event.touchDownRepeat)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"background")!)
        self.updateJammerScoreLbl(TeamDesignation.Home)
        self.updateJammerScoreLbl(TeamDesignation.Visitor)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillDisappear(_ animated: Bool) {}

    @IBAction func increaseJamScoreTouch(_ sender: UIButton) -> Void {
        if !(self.jamClockTimer?.isRunning())! {
            return;
        }

        let senderName = sender.restorationIdentifier;
        if senderName == "homePointIncrease" {
            self.currentJam?.addOneTo(TeamDesignation.Home)
            self.updateJammerScoreLbl(TeamDesignation.Home)
        } else if senderName == "visitorPointIncrease" {
            self.currentJam?.addOneTo(TeamDesignation.Visitor)
            self.updateJammerScoreLbl(TeamDesignation.Visitor)
        }
    }

    @IBAction func decreaseJamScoreTouch(_ sender: UIButton) -> Void {
        if !(self.jamClockTimer?.isRunning())! {
            return;
        }

        let senderName = sender.restorationIdentifier;
        if senderName == "homePointDecrease" {
            self.currentJam?.subtractOneFrom(TeamDesignation.Home)
            self.updateJammerScoreLbl(TeamDesignation.Home)
        } else if senderName == "visitorPointDecrease" {
            self.currentJam?.subtractOneFrom(TeamDesignation.Visitor)
            self.updateJammerScoreLbl(TeamDesignation.Visitor)
        }
    }

    func updateJammerScoreLbl(_ team: TeamDesignation) -> Void {
        if team == TeamDesignation.Home {
            self.homeJamScoreLbl?.text = "\(self.currentJam?.homeJamScore ?? 0)";
        } else if team == TeamDesignation.Visitor {
            self.visitorJamScoreLbl?.text = "\(self.currentJam?.visitorJamScore ?? 0)";
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
                self.endJam()
            } else {
                self.startJam()
            }
        }
    }

    @IBAction func connectExternalScreen() -> Void {
        let availableScreens = UIScreen.screens
        if availableScreens.count > 1 {
            self.setupSpectatorScreen(availableScreens)
        } else {
            print("No external displays")
        }
    }

    func clockReachedZero(_ clockType: ClockType) {
        if clockType == ClockType.Bout {
            print("Bout clock got to zero")
        } else if clockType == ClockType.Jam {
            print("Jam clock got to zero")
            self.periodClockTimer?.resetClock()
            self.periodClockTimer?.startClock()
        } else if clockType == ClockType.Period {
            print("Period clock got to zero")
            self.endJam()
            self.startJam()
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
        } else if clock == ClockType.Period {
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
            self.boutClockTimer = GameTimer.init(ClockType.Bout, ClockStartTimes.Bout.rawValue, self)
            self.jamClockTimer = GameTimer.init(ClockType.Jam, ClockStartTimes.Jam.rawValue, self)
            self.periodClockTimer = GameTimer.init(ClockType.Period, ClockStartTimes.Period.rawValue, self)
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

    private func startJam() -> Void {
        self.periodClockTimer?.stopClock()
        self.periodClockTimer?.resetClock()
        self.jamClockTimer?.resetClock()
        self.jamClockTimer?.startClock()
        if !(self.boutClockTimer?.isRunning())! {
            self.boutClockTimer?.startClock()
        }
        self.numberOfJamsLbl?.text = "\(self.theGame?.numberOfJams() ?? 0)"
    }

    private func endJam() -> Void {
        self.resetJamScoreLbls(0, 0)
        self.theGame?.addJam(self.currentJam!)
        self.currentJam = DerbyJam(DerbyPlayer(name: "MathKilla", number: "Emc2")!, DerbyPlayer(name: "JamTastik", number: "1")!)
        self.homeTotalScoreLbl?.text = "\(self.theGame?.calculateTotalScore(TeamDesignation.Home) ?? 0)"
        self.visitorTotalScoreLbl?.text = "\(self.theGame?.calculateTotalScore(TeamDesignation.Visitor) ?? 0)"
    }

    private func resetJamScoreLbls(_ home: Int = 0, _ visitor: Int = 0) -> Void  {
        self.homeJamScoreLbl?.text = "\(home)"
        self.visitorJamScoreLbl?.text = "\(visitor)"
    }

    private func setupSpectatorScreen(_ screens: Array<UIScreen>) -> Void  {
        self.extScreen = screens[1]
        if self.extScreen == nil {
            print("No external screens connected")
            return
        }

        print("Setting up external screen")
        let bounds = self.extScreen?.bounds
        self.spectatorWindow = UIWindow.init(frame: bounds!)
        self.spectatorWindow?.screen = self.extScreen!

        self.spectatorViewController = SpectatorScreenViewController()
        self.spectatorWindow?.rootViewController = self.spectatorViewController
        self.spectatorWindow?.rootViewController?.view.bounds = bounds!
        self.spectatorWindow?.isHidden = false
    }
}
