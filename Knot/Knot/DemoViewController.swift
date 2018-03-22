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
    var lastY:CGFloat!
    override func viewDidLoad() {
        super.viewDidLoad()

        topContraint.constant = view.frame.size.height - 100
        lastY = topContraint.constant
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func swipeUp(_ sender: UIPanGestureRecognizer) {
        //        print("swipeUp,in Y axis")
        if sender.state == .ended || sender.state == .cancelled{
            lastY = self.topContraint.constant
        }
        if sender.state == .began || sender.state == .changed {
            let y = sender.translation(in: self.addItemPanel).y
            
            print("y in addItempanel=\(y)")
            
            var dy = lastY + y
            if dy <= 50{
                dy = 50
            }else if dy > view.frame.size.height - 100 {
                dy = view.frame.size.height - 100
            }
            UIView.animate(withDuration: 0.2, animations: {
                self.topContraint.constant = dy
                self.view.layoutIfNeeded()
                
            }, completion: { (sucess) in
                print("swipe to up completed.")
            })
            
        }
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
