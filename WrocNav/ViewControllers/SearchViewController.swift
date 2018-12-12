//
//  SearchViewController.swift
//  WrocNav
//
//  Created by Kacper Raczy on 12.12.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var sourceTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: UI setup
    
    func setUpNavigationBar() {
        guard let navBar = self.navigationController?.navigationBar else {
            return
        }
        
        navBar.setBackgroundImage(nil, for: .default)
        navBar.backgroundColor = UIColor.white
        navBar.tintColor = UIColor.black
        navBar.shadowImage = UIImage()
    }

    @IBAction func swapEndpoints(_ sender: Any) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
