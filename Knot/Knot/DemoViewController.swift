//
//  DemoViewController.swift
//  Knot
//
//  Created by liubo on 2018/3/19.
//  Copyright © 2018年 liubo. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController {

    @IBOutlet weak var reminder: UIDatePicker!
    @IBOutlet weak var textfiled: UITextField!
    @IBOutlet weak var addItemPanel: UIView!
    @IBOutlet weak var topContraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func swipeUp(_ sender: UIPanGestureRecognizer) {
        print("swipeUp")
    }
    @IBAction func tapClose(_ sender: UITapGestureRecognizer) {
        print("tap press")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
