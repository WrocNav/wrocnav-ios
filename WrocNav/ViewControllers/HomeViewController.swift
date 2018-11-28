//
//  ViewController.swift
//  WrocNav
//
//  Created by Kacper Raczy on 21.11.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit
import SideMenu

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indentifier = segue.identifier else {
            return
        }
        

    }

}
