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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"background")!)
        // Do any additional setup after loading the view, typically from a nib.
    }


}

