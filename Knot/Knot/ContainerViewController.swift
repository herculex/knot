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
    
    @IBOutlet weak var addButtonTrail: NSLayoutConstraint!
    var todoTableViewController:ToDoTableViewController!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
            self.addButtonTrail.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addButtonTrail.constant -= view.bounds.width
        
        addButton.layer.cornerRadius = addButton.frame.size.width / 2
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "todoVC" {
            todoTableViewController = (segue.destination as! UINavigationController).childViewControllers.first as! ToDoTableViewController
            todoTableViewController.connectionButtonReference = connectionButton 
        }
    }

    @IBAction func addNewTodoItem(_ sender: UIButton) {
        todoTableViewController.addNewTodo()
    }
    @IBAction func triggerConnection(_ sender: UIButton) {
        todoTableViewController.showConnectivityAction()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
