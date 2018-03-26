//
//  ContainerViewController.swift
//  Knot
//
//  Created by liubo on 2018/2/25.
//  Copyright © 2018年 liubo. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController,UITextFieldDelegate,ToDoTableViewControllerDelegate {

    @IBOutlet weak var topContraint: NSLayoutConstraint!
    @IBOutlet weak var addItemPanelView: UIView!
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
    var effectBlurOfBlurAddView:UIVisualEffect!

    @IBOutlet weak var reminderButton: UIButton!
    @IBOutlet weak var reminderConstraint: NSLayoutConstraint!
    var sideViewIsShowing:Bool!
    var lastY:CGFloat!
    var minTop:CGFloat!
    var maxTop:CGFloat!
    let startOffset = CGFloat(integerLiteral: 60)
    
    @IBAction func swipeUp(_ sender: UIPanGestureRecognizer) {
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
                    self.blurAddView.alpha = 1
                    
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
                    self.blurAddView.alpha = 0
                    
                    self.view.layoutIfNeeded()
                }, completion: { (sucess) in
                    print("close up done.")
                    self.lastY = self.topContraint.constant
                })
            }
        }
        if sender.state == .began || sender.state == .changed {
            let y = sender.translation(in: self.addItemPanelView).y
            
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
                self.blurAddView.alpha = alpha
                
                self.view.layoutIfNeeded()
                
            }, completion: { (sucess) in
                print("swipe to up completed.")
            })
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
            self.addButtonTrail.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.addSubview(blurAddView)
        blurAddView.frame = view.frame
        blurAddView.alpha = 0
        
        topContraint.constant = view.frame.size.height - startOffset
        
        lastY = topContraint.constant
        minTop = CGFloat(integerLiteral: 50)
        maxTop = view.frame.size.height - startOffset
        
//        reminderConstraint.constant -= view.bounds.height
//        reminderView.alpha = 0
        
        effectBlurOfBlurAddView = blurAddView.effect
//        blurAddView.effect = nil
//        blurAddView.alpha = 0
        
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
            todoTableViewController.delegate = self
        }
    }

    @IBOutlet var reminderView: UIView!
    @IBAction func addNewTodoItem(_ sender: UIButton) {
//        addViewAnimateIn()
    }

    func saveTodoItem() {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CH")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        if var currentItem = selectedTodoItem,let currentIndex = selectedIndexPath{
            
            if addText.text!.count == 0 {
                todoTableViewController.deleteTodo(currentIndex)
            }else{
                print("editing \(currentItem.title)")
                currentItem.title = addText.text!
                
                if let date = formatter.date(from: reminderButton.currentTitle!){
                    currentItem.hasReminder = true
                    currentItem.remindAt = date
                }
                
                todoTableViewController.editTodo(currentItem, currentIndex)
            }
            
            selectedTodoItem = nil
            selectedIndexPath = nil
            
        }else{
            print("adding \(addText.text!)")
            if let date = formatter.date(from: reminderButton.currentTitle!){
                todoTableViewController.addNewTodoAt(withTitle: addText.text!, at: date)
            }else{
                todoTableViewController.addNewTodo(withTitle: addText.text!)
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("got return but done display")
        
        saveTodoItem()
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
    @IBAction func animateReminderView(_ sender: Any) {
        
        if reminderView.alpha == 0 {
            //animateIn
            animateReminderIn()
            //
 
            let formater = DateFormatter()
            formater.locale = Locale.init(identifier: "zh_CH")
            formater.dateFormat = "yyyy-MM-dd HH:mm"
            
            if let date = formater.date(from: reminderButton.currentTitle!){
                reminder.setDate(date, animated: true)
            }else{
                reminder.setDate(Date(), animated: true)
            }
        }else{
            //anmiateOut
            animateReminderOut()
        }
    }
    
    func animateReminderIn(){
        UIView.animate(withDuration: 0.3, animations: {
            self.reminderView.alpha = 1
//            self.reminderConstraint.constant += self.view.bounds.height
            self.view.layoutIfNeeded()
        })
    }
    func animateReminderOut(){
        UIView.animate(withDuration: 0.2, animations: {
            self.reminderView.alpha = 0
//            self.reminderConstraint.constant -= self.view.bounds.height
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func dismissAddItemView(_ sender: Any) {
        saveTodoItem()
        addViewAnimateOut()
    }
    
    

    @IBAction func confirmReminder(_ sender: UIButton) {
        let date = reminder.date
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        reminderButton.setTitle(formatter.string(from: date), for: UIControlState.normal)
        
        animateReminderOut()
    }
    
    @IBAction func removeReminder(_ sender: UIButton) {
        
        reminderButton.setTitle("闹钟", for: .normal)
        animateReminderOut()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - animate In & Out of Pop-up
    
    func addViewAnimateIn(){
//        self.view.addSubview(blurAddView)
//        blurAddView.frame = self.view.frame
        
//        addItemView.transform = addText.transform.scaledBy(x: 1.2, y: 1.2)

        UIView.animate(withDuration: 0.5, animations: {
            //            self.addItemView.alpha = 1
            //            self.addItemView.transform = CGAffineTransform.identity
            //            self.blurAddView.effect = self.effectBlurOfBlurAddView
            self.blurAddView.alpha = 1
            self.topContraint.constant = self.minTop
            self.view.layoutIfNeeded()
        }) { (sucess) in
            self.addText.becomeFirstResponder()
        }
        
    }
    func addViewAnimateOut(){
        addText.text = nil
        addText.resignFirstResponder()
        reminderButton.setTitle("闹钟", for: .normal)
        
        UIView.animate(withDuration: 0.2, animations: {
//            if self.reminderView.alpha == 1{
//                self.reminderView.alpha = 0
//                self.reminderConstraint.constant -= self.view.bounds.height
//            }
//            self.addItemView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
//            self.addItemView.alpha = 0
//            self.blurAddView.effect = nil
            self.blurAddView.alpha = 0
            self.topContraint.constant = self.maxTop
            self.view.layoutIfNeeded()
        }) { (sucess) in
//            self.blurAddView.removeFromSuperview()
            self.lastY = self.topContraint.constant
        }
    }
    
    // MARK: - ToDoTableViewControllerDelegate

    var selectedTodoItem:ToDoItem!
    var selectedIndexPath:IndexPath!
    func didRequestAddUI() {
        addViewAnimateIn()
    }
    
    func didRequestEditUI(_ todoItem: ToDoItem, _ indexPath:IndexPath) {
        addViewAnimateIn()
        addText.text = todoItem.title
        if todoItem.hasReminder {
            let formatter = DateFormatter()
            formatter.locale = Locale.init(identifier: "zh_CH")
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            reminderButton.setTitle(formatter.string(from: todoItem.remindAt), for: .normal)
        }
        selectedTodoItem = todoItem
        selectedIndexPath = indexPath
        
    }
    
}
