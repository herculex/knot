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
    var effection:UIVisualEffect!
    
    @IBOutlet weak var effectView: UIVisualEffectView!
    var lastY:CGFloat!
    var minTop:CGFloat!
    var maxTop:CGFloat!
    let startOffset = CGFloat(integerLiteral: 60)
    override func viewDidLoad() {
        super.viewDidLoad()

        effection = effectView.effect
//        effectView.effect = nil
        effectView.alpha = 0
        
        topContraint.constant = view.frame.size.height - startOffset
        lastY = topContraint.constant
        minTop = CGFloat(integerLiteral: 50)
        maxTop = view.frame.size.height - startOffset
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
            
            if lastY == maxTop || lastY == minTop {
                return
            }
            
            if lastY < maxTop - 200{
                //show all
                UIView.animate(withDuration: 0.2, animations: {
                    self.topContraint.constant = self.minTop
                    
//                    self.effectView.effect = self.effection
                    self.effectView.alpha = 1
                    
                    self.view.layoutIfNeeded()
                    
                }, completion: { (sucess) in
                    print("show all done.")
                    self.lastY = self.topContraint.constant
                })
            }else {
                //close up
                UIView.animate(withDuration: 0.2, animations: {
                    self.topContraint.constant = self.maxTop
                    
//                    self.effectView.effect = nil
                    self.effectView.alpha = 0
                    
                    self.view.layoutIfNeeded()
                }, completion: { (sucess) in
                    print("close up done.")
                    self.lastY = self.topContraint.constant
                })
            }
        }
        if sender.state == .began || sender.state == .changed {
            let y = sender.translation(in: self.addItemPanel).y
            
            print("y in addItempanel=\(y)")
            
            if y >= 0 && lastY == maxTop {
                return
            }else if y <= 0 && lastY == minTop {
                return
            }
            
            var dy = lastY + y
            var alpha = 1 - (dy / maxTop)
            print("alpha:\(alpha)")
            
            if dy <= minTop{
                dy = minTop
                alpha = 1
            }else if dy > maxTop {
                dy = maxTop
                alpha = 0
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                self.topContraint.constant = dy
//                self.effectView.effect = self.effection
                self.effectView.alpha = alpha
                
                self.view.layoutIfNeeded()
                
            }, completion: { (sucess) in
                print("swipe to up completed.")
            })
            
        }
    }
    @IBAction func tapClose(_ sender: UITapGestureRecognizer) {
        print("tap press")
        if lastY < maxTop {
            UIView.animate(withDuration: 0.2, animations: {
                self.topContraint.constant = self.maxTop
                
//                self.effectView.effect = nil
                self.effectView.alpha = 0
                
                self.view.layoutIfNeeded()
            }, completion: { (sucess) in
                print("close up done.")
                self.lastY = self.topContraint.constant
            })
        }else{
            print("already closed")
        }
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
