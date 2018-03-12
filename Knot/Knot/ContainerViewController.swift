//
//  ContainerViewController.swift
//  Knot
//
//  Created by liubo on 2018/2/25.
//  Copyright © 2018年 liubo. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var addTextView: UIView!
    @IBOutlet var edgePanGesture: UIScreenEdgePanGestureRecognizer!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var sideViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var connectionButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addText: UITextField!
    
    @IBOutlet weak var reminder: UIDatePicker!
    @IBOutlet weak var addButtonTrail: NSLayoutConstraint!
    var todoTableViewController:ToDoTableViewController!
    var effectBlur:UIVisualEffect!
    
    @IBOutlet var visualEffectBlur: UIVisualEffectView!

    var sideViewIsShowing:Bool!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
            self.addButtonTrail.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        effectBlur = visualEffectBlur.effect
        visualEffectBlur.effect = nil
        addItemView.layer.cornerRadius = 10
        
        addButtonTrail.constant -= view.bounds.width
                
        addText.returnKeyType = .done
        addText.delegate = self
        
        blurView.layer.cornerRadius = 15
        sideView.layer.shadowOffset = CGSize(width: 3, height: 0)
        sideView.layer.shadowColor = UIColor.black.cgColor
        sideView.layer.shadowOpacity = 0.8
        
        sideViewConstraint.constant -= sideView.bounds.size.width
        sideViewIsShowing = false
        
        addTextView.layer.cornerRadius = 15
        addTextView.layer.shadowOffset = CGSize(width: 3, height: 0)
        addTextView.layer.shadowColor = UIColor.black.cgColor
        addTextView.layer.shadowOpacity = 0.8
        
        
        addItemView.layer.cornerRadius = 15
        addItemView.layer.shadowOffset = CGSize(width: 3, height: 0)
        addItemView.layer.shadowColor = UIColor.black.cgColor
        addItemView.layer.shadowOpacity = 0.8

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "todoVC" {
            todoTableViewController = (segue.destination as! UINavigationController).childViewControllers.first as! ToDoTableViewController
            todoTableViewController.connectionButtonReference = connectionButton 
        }
    }

    @IBOutlet var addItemView: UIView!
    @IBAction func addNewTodoItem(_ sender: UIButton) {
        animateIn()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("got return but done display")
        print("select reminder:\(reminder.date)")
        todoTableViewController.addNewTodoAt(withTitle: addText.text!, at: reminder.date)
        animateOut()
        
        return true
    }
    
    @IBAction func triggerConnection(_ sender: UIButton) {
        todoTableViewController.showConnectivityAction()
    }
    

    @IBAction func swipeSideView(_ sender: UIScreenEdgePanGestureRecognizer) {
        
        print("swiping detected.\(sender.translation(in: self.view).x)")
        
        if sideViewIsShowing { return }
        
        if sender.state == .began || sender.state == .changed{
            let tranX = sender.translation(in: self.view).x
            
            if sideViewConstraint.constant < 40 {
                UIView.animate(withDuration: 0.2, animations: {
                    
                    self.sideViewConstraint.constant = tranX - self.sideView.bounds.size.width
                    self.view.layoutIfNeeded()
                    
                    print("swipe side constraint \(self.sideViewConstraint.constant)")
                })
            }
            
        }else if sender.state == .ended{
            if sideViewConstraint.constant < -(sideView.bounds.width/2) {
                UIView.animate(withDuration: 0.2, animations: {
                    
                    self.sideViewConstraint.constant = -self.sideView.bounds.width
                    self.view.layoutIfNeeded()
                    
                    print("ended side constraint \(self.sideViewConstraint.constant)")
                }, completion: { (sucess) in
                    self.sideViewIsShowing = false
                })
            }else{
                UIView.animate(withDuration: 0.3, animations: {
                    self.sideViewConstraint.constant = 20
                    self.view.layoutIfNeeded()
                    
                    print("ended side constraint \(self.sideViewConstraint.constant)")
                }, completion: { (sucess) in
                    self.sideViewIsShowing = true
                })
            }
        }
    }
    @IBAction func dissmisSideView(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            
            self.sideViewConstraint.constant = -self.sideView.bounds.size.width
            self.view.layoutIfNeeded()            
        },completion: { (sucess) in
            self.sideViewIsShowing = false
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - animate In & Out of Pop-up
    
    func animateIn() {
        self.view.addSubview(visualEffectBlur)
        visualEffectBlur.frame = self.view.frame
        
//        self.view.addSubview(addItemView)
//        addItemView.center = self.view.center
        addItemView.transform = addItemView.transform.scaledBy(x: 1.3, y: 1.3)
        //        addItemView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        
        UIView.animate(withDuration: 0.5) {
            self.addItemView.alpha = 1
            self.addItemView.transform = CGAffineTransform.identity
            self.visualEffectBlur.effect = self.effectBlur
        }
        addText.becomeFirstResponder()
    }
    
    func animateOut() {
        addText.text = nil
        addText.resignFirstResponder()
        
        //animateOut
        UIView.animate(withDuration: 0.2, animations: {
            self.addItemView.transform = CGAffineTransform.init(scaleX: 1.4, y: 1.4)
            self.addItemView.alpha = 0
            self.visualEffectBlur.effect = nil
        }) { (sucess) in
//            self.addItemView.removeFromSuperview()
            self.visualEffectBlur.removeFromSuperview()
        }
        
    }
    
}
