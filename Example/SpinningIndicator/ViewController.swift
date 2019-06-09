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
    
    let indicator = SpinningIndicator(frame: UIScreen.main.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupView()
    }
    
    private func setupView() {
        view.addSubview(indicator)
        view.sendSubview(toBack: indicator)
        indicator.addCircle(lineColor: UIColor(red: 255/255, green: 91/255, blue: 25/255, alpha: 1), lineWidth: 2, radius: 16, angle: 0)
        indicator.addCircle(lineColor: UIColor.orange, lineWidth: 2, radius: 19, angle: CGFloat.pi)
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
