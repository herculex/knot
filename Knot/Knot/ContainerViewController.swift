//
//  ContainerViewController.swift
//  Knot
//
//  Created by liubo on 2018/2/25.
//  Copyright © 2018年 liubo. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var connectionButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addText: UITextField!
    
    @IBOutlet weak var addButtonTrail: NSLayoutConstraint!
    var todoTableViewController:ToDoTableViewController!
    
    var effectBlur:UIVisualEffect!
    
    @IBOutlet var visualEffectBlur: UIVisualEffectView!

    @IBAction func dismissPopup(_ sender: UIButton) {
        //
        
        todoTableViewController.addNewTodo(withTitle: addText.text!)
        addText.text = nil
        
        //animateOut
        UIView.animate(withDuration: 0.2, animations: {
            self.addItemView.transform = CGAffineTransform.init(scaleX: 1.4, y: 1.4)
            self.addItemView.alpha = 0
            self.visualEffectBlur.effect = nil
        }) { (sucess) in
            self.addItemView.removeFromSuperview()
            self.visualEffectBlur.removeFromSuperview()
        }
        //animateOut
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
        
        effectBlur = visualEffectBlur.effect
        visualEffectBlur.effect = nil
        addItemView.layer.cornerRadius = 10
        
        addButtonTrail.constant -= view.bounds.width
        
        addButton.layer.cornerRadius = addButton.frame.size.width / 2
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "todoVC" {
            todoTableViewController = (segue.destination as! UINavigationController).childViewControllers.first as! ToDoTableViewController
            todoTableViewController.connectionButtonReference = connectionButton 
        }
    }

    @IBOutlet var addItemView: UIView!
    @IBAction func addNewTodoItem(_ sender: UIButton) {
        
        //animateIn
        self.view.addSubview(visualEffectBlur)
        visualEffectBlur.frame = self.view.frame
        self.view.addSubview(addItemView)
        addItemView.center = self.view.center
        addItemView.transform = addItemView.transform.scaledBy(x: 1.3, y: 1.3)
//        addItemView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        
        UIView.animate(withDuration: 0.5) {
            self.addItemView.alpha = 1
            self.addItemView.transform = CGAffineTransform.identity
            self.visualEffectBlur.effect = self.effectBlur
        }
        //animateIn
        
//        todoTableViewController.addNewTodo()
    }
    @IBAction func triggerConnection(_ sender: UIButton) {
        todoTableViewController.showConnectivityAction()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
