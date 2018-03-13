//
//  ContainerViewController.swift
//  Knot
//
//  Created by liubo on 2018/2/25.
//  Copyright © 2018年 liubo. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var blurAddView: UIVisualEffectView!
    @IBOutlet var edgePanGesture: UIScreenEdgePanGestureRecognizer!
    @IBOutlet weak var blurSideView: UIVisualEffectView!
    @IBOutlet weak var sideViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var connectionButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addText: UITextField!
    
    @IBOutlet weak var addItemView: UIView!
    @IBOutlet weak var reminder: UIDatePicker!
    @IBOutlet weak var addButtonTrail: NSLayoutConstraint!
    var todoTableViewController:ToDoTableViewController!
    var effectBlurOfBlurReminderView:UIVisualEffect!
    var effectBlurOfBlurAddView:UIVisualEffect!
    
    @IBOutlet var blurReminderView: UIVisualEffectView!

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
        
        effectBlurOfBlurReminderView = blurReminderView.effect
        blurReminderView.effect = nil
        
        effectBlurOfBlurAddView = blurAddView.effect
        blurAddView.effect = nil
               
        addText.returnKeyType = .done
        addText.delegate = self
        
        addItemView.layer.cornerRadius = 10
        addItemView.layer.shadowOffset = CGSize(width: 3, height: 0)
        addItemView.layer.shadowColor = UIColor.black.cgColor
        addItemView.layer.shadowOpacity = 0.8
        
        addButtonTrail.constant -= view.bounds.width
        
        blurSideView.layer.cornerRadius = 15
        sideView.layer.shadowOffset = CGSize(width: 3, height: 0)
        sideView.layer.shadowColor = UIColor.black.cgColor
        sideView.layer.shadowOpacity = 0.8
        
        sideViewConstraint.constant -= sideView.bounds.size.width
        sideViewIsShowing = false
      
        reminderView.layer.cornerRadius = 15
        reminderView.layer.shadowOffset = CGSize(width: 3, height: 0)
        reminderView.layer.shadowColor = UIColor.black.cgColor
        reminderView.layer.shadowOpacity = 0.8

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "todoVC" {
            todoTableViewController = (segue.destination as! UINavigationController).childViewControllers.first as! ToDoTableViewController
            todoTableViewController.connectionButtonReference = connectionButton 
        }
    }

    @IBOutlet var reminderView: UIView!
    @IBAction func addNewTodoItem(_ sender: UIButton) {
        addViewAnimateIn()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("got return but done display")
//        print("select reminder:\(reminder.date)")
//        todoTableViewController.addNewTodoAt(withTitle: addText.text!, at: reminder.date)
        
        todoTableViewController.addNewTodo(withTitle: addText.text!)
        addViewAnimateOut()
        
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
    
    @IBAction func dismissAddItemView(_ sender: Any) {
        addViewAnimateOut()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - animate In & Out of Pop-up
    
    func addViewAnimateIn(){
        self.view.addSubview(blurAddView)
        blurAddView.frame = self.view.frame
        
        addText.transform = addText.transform.scaledBy(x: 1.2, y: 1.2)

        UIView.animate(withDuration: 0.5) {
            self.addText.alpha = 1
            self.addText.transform = CGAffineTransform.identity
            self.blurAddView.effect = self.effectBlurOfBlurAddView
        }
        addText.becomeFirstResponder()
    }
    func addViewAnimateOut(){
        addText.text = nil
        addText.resignFirstResponder()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.addText.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.addText.alpha = 0
            self.blurAddView.effect = nil
        }) { (sucess) in
            self.blurAddView.removeFromSuperview()
        }
    }
    
    func animateIn() {
        self.view.addSubview(blurReminderView)
        blurReminderView.frame = self.view.frame
        
        reminderView.transform = reminderView.transform.scaledBy(x: 1.2, y: 1.2)
        
        UIView.animate(withDuration: 0.5) {
            self.reminderView.alpha = 1
            self.reminderView.transform = CGAffineTransform.identity
            self.blurReminderView.effect = self.effectBlurOfBlurReminderView
        }
        reminder.date = Date()
    }
    
    func animateOut() {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.reminderView.transform = CGAffineTransform.init(scaleX: 1.4, y: 1.4)
            self.reminderView.alpha = 0
            self.blurReminderView.effect = nil
        }) { (sucess) in
            self.blurReminderView.removeFromSuperview()
        }
    }
    
}
