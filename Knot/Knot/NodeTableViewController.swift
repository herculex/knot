//
//  NodeTableViewController.swift
//  Knot
//
//  Created by liubo on 2018/1/31.
//  Copyright © 2018年 liubo. All rights reserved.
//

import UIKit
import CoreData

class NodeTableViewController: UITableViewController {
    @IBAction func openEditingMode(_ sender: UIBarButtonItem) {
        setEditing(!tableView.isEditing, animated: true)
    }

    @IBAction func addSomeNodes(_ sender: UIBarButtonItem) {

        if let context = container?.viewContext{
            let node  = Node(context:context)
            node.what = "demo at \(Date())"
            node.cost = 9
            node.created = Date()
            do  {
                try context.save()
            }catch let err{
                print(err)
            }
            updateUI()
            print("handle add")
        }
    }
    @IBAction func refresh(_ sender: UIRefreshControl) {
        updateUI()
        refreshControl?.endRefreshing()
    }
    var container:NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer{
        didSet{
            updateUI()
        }
    }
    
    
    var fetchedResultsController:NSFetchedResultsController<Node>?
    
    func updateUI()
    {
        if let context = container?.viewContext{
            let request:NSFetchRequest<Node> = NSFetchRequest(entityName: "Node")
            let sortByCreated = NSSortDescriptor(key: "created", ascending: false)
            let sortByDone  = NSSortDescriptor(key: "isDone", ascending: false)
            request.sortDescriptors = [sortByDone,sortByCreated]
            let predicate = NSPredicate(format: "any father = nil")
            request.predicate = predicate
            fetchedResultsController = NSFetchedResultsController<Node>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil)
            
            
            fetchedResultsController?.delegate = self //很重要，fetchResultsController的delegate是self.
            try? fetchedResultsController?.performFetch()
            tableView.reloadData()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUI()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        print("viewDidLoad go")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedResultsController?.sections,sections.count>0{
            return sections[section].name
        }else{
            return nil
        }
    }
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return fetchedResultsController?.sectionIndexTitles
    }
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return (fetchedResultsController?.section(forSectionIndexTitle: title, at: index)) ?? 0
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController?.sections,sections.count>0{
            return sections[section].numberOfObjects
        }else{
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "node table cell",for:indexPath)
        
        if let node = fetchedResultsController?.object(at: indexPath){
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = node.what
            cell.detailTextLabel?.text = "\(String(describing: node.created!)),\(node.isDone)"
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if(indexPath.row%2 == 0){
            return true}
        else {return false}
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("moving,\(sourceIndexPath.row) to \(destinationIndexPath.row)")
    }
//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let deletion = UITableViewRowAction(style: .destructive, title: "delete") { (action, indexPath) in
//            print("this's delete")
//        }
//        let insert = UITableViewRowAction(style: .normal, title: "insert") { (action, indexPath) in
//            print("this's insert")
//        }
//        let edit = UITableViewRowAction(style: .normal, title: "edit") { (action, indexPath) in
//            print("this's edit")
//        }
//        let reminder = UITableViewRowAction(style: .normal, title: "reminder") { (action, indexPath) in
//            print("this's reminder")
//        }
//        return [deletion,insert,edit,reminder]
//    }
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if(indexPath.row%2 == 0)
        {
            return UITableViewCellEditingStyle.delete
        }
        else{
            return UITableViewCellEditingStyle.insert
        }
    }
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "are u sure?"
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.delete){
            if let context = self.container?.viewContext{
                if let node = self.fetchedResultsController?.object(at: indexPath){
                    try? context.delete(node)
                    try? context.save()
                    print("delete & save from commit")
                }
            }
        }
        if(editingStyle == .insert){
            print("insert..from editingStyle")

        }
    }
    
    /*
     // MARK: - Navigation
          */
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        print("\(String(describing: segue.identifier))")
        if(segue.identifier! == "segueDetail"){
            if let selectedRow = tableView.indexPath(for: sender as! UITableViewCell){
                print("row at:\(selectedRow)")
                if let selectedNode = fetchedResultsController?.object(at: selectedRow){
                    print("found node at:\(selectedRow)")
                    let detailView = segue.destination as! DetailTableViewController
                    detailView.loadedNode = selectedNode
                }
            }
        }
     }

    
}
