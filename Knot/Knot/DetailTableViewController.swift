//
//  ViewController.swift
//  Knot
//
//  Created by liubo on 2018/1/22.
//  Copyright © 2018年 liubo. All rights reserved.
//

import UIKit
import CoreData

class DetailTableViewController: UITableViewController {
    
    var loadedNode:Node?

    @IBOutlet weak var isDoneSwitch: UISwitch!
    @IBOutlet weak var onTopSwitch: UISwitch!
    
    @IBAction func barSave(_ sender: UIBarButtonItem) {
        doSave()
    }
    @IBOutlet weak var textWhat: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(doSave))
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.title = "New/Editing"
        updateUI()
    }
    
    func updateUI() -> () {
        textWhat.text = loadedNode?.what ?? ""
        isDoneSwitch.isOn = loadedNode?.isDone ?? false
        onTopSwitch.isOn = loadedNode?.onTop ?? false
        
        tableView.sectionHeaderHeight = 50
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func doSave() {
        print("press save.")
        let what = textWhat.text
        let cost = 0
        let created = Date()
        let isDone = isDoneSwitch.isOn
        let onTop = onTopSwitch.isOn
        textWhat.resignFirstResponder()
        
        container?.performBackgroundTask({ (context) in
            
            if self.loadedNode == nil{
                let node = Node(context: context)
                node.what = what
                node.cost = cost as? NSDecimalNumber
                node.created = created
                node.isDone = isDone
                node.onTop = onTop
                try?context.save()
            }else{
                self.loadedNode?.what = what
                self.loadedNode?.isDone = isDone
                self.loadedNode?.onTop = onTop
                try? self.loadedNode?.managedObjectContext?.save()
            }
            
            
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        })
        
    }
    
    func printDatabaseStatistics(){
        
        if let context = container?.viewContext{
            context.perform {
                if let count = try? context.fetch(Node.fetchRequest()).count {
                    print("\(count) nodes")
                }
            }
        }
    }
    
    var container:NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
}

