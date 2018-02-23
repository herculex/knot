//
//  ToDoTableViewController.swift
//  Knot
//
//  Created by liubo on 2018/2/23.
//  Copyright © 2018年 liubo. All rights reserved.
//

import UIKit

class ToDoTableViewController: UITableViewController,TodoCellDelegate {
    func didRequestDelete(_ cell: ToDoTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell){
            todoItems[indexPath.row].deleteItem()
            todoItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func didRequestComplete(_ cell: ToDoTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell){
            var todoitem = todoItems[indexPath.row]
            todoitem.maskAsCompleted()
            cell.todoLabel.attributedText = strikeThroughText(todoitem.title)
            
        }
    }
    func strikeThroughText(_ text:String)->NSAttributedString{
        let attrString:NSMutableAttributedString = NSMutableAttributedString(string: text)
        attrString.addAttribute(.strikethroughStyle, value: 1, range: NSMakeRange(0, attrString.length))
        
        return attrString
    }
    

    var todoItems:[ToDoItem]!
    
    func loadData() {
        todoItems = [ToDoItem]()
        todoItems = DataManager.loadAll(ToDoItem.self).sorted(by: {$0.createdAt < $1.createdAt})
    }
    
    @IBAction func addNewTodo(_ sender: UIBarButtonItem) {
        let addAlert = UIAlertController(title: "New Todo", message: "Enter a title", preferredStyle: .alert)
        
        addAlert.addTextField { (textfiled) in
            textfiled.placeholder = "Todo Item Title"
        }
        
        addAlert.addAction(UIAlertAction(title: "Create", style: .default, handler: { (action) in
            guard let title = addAlert.textFields?.first?.text else { return }
            
            let newTodo = ToDoItem(title: title, completed: false, createdAt: Date(), itemIdentifier: UUID(), wasted: false)
            newTodo.saveItem()
            
            self.todoItems.append(newTodo)
            
            let indexPath = IndexPath(row: self.tableView.numberOfRows(inSection: 0), section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }))
        
        addAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(addAlert, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! ToDoTableViewCell
        
        cell.delegate = self
        
        let todoItem = todoItems[indexPath.row]
        cell.todoLabel.text = todoItem.title

        if todoItem.completed{
            cell.todoLabel.attributedText = strikeThroughText(todoItem.title)
        }

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
