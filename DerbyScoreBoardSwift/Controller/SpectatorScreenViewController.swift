//
//  SpectatorScreenViewController.swift
//  DSBv2
//
//  Created by Nazario Ayala on 4/28/19.
//  Copyright © 2019 Nazario Ayala. All rights reserved.
//

import UIKit

class SpectatorScreenViewController: UIViewController {
    @IBOutlet weak var specHomeTeamJamScore: UILabel?
    @IBOutlet weak var specVistorTeamJamScore: UILabel?

    @IBOutlet weak var specHomeTeamTotalScore: UILabel?
    @IBOutlet weak var specVistorTeamTotalScore: UILabel?

    @IBOutlet weak var specHomeTeamJammerNameNumber: UILabel?
    @IBOutlet weak var specVistorTeamJammerNameNumber: UILabel?

    @IBOutlet weak var specHomeTeamName: UILabel?
    @IBOutlet weak var specVistorTeamName: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
