//
//  ViewController.swift
//  SpinningIndicator
//
//  Created by Toshihiro Yamazaki on 04/26/2019.
//  Copyright (c) 2019 Toshihiro Yamazaki. All rights reserved.
//

import UIKit
import SpinningIndicator

class ViewController: UIViewController {
    
    let indicator = SpinningIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupView()
    }
    
    private func setupView() {
        indicator.alpha = 0
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        indicator.widthAnchor.constraint(equalToConstant: 24).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 24).isActive = true
        indicator.endAnimating()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.indicator.alpha = 1
        }
    }
    
    @IBAction func showIndicator() {
        indicator.beginAnimating()
    }
    
    @IBAction func hideIndicator() {
        indicator.endAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

