//
//  ToDoTableViewController.swift
//  Knot
//
//  Created by liubo on 2018/2/23.
//  Copyright © 2018年 liubo. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ToDoTableViewController: UITableViewController,MCSessionDelegate,MCBrowserViewControllerDelegate {

    var peerID:MCPeerID!
    var mcSession:MCSession!
    var mcAdvertiserAssistant:MCAdvertiserAssistant!

    @IBOutlet var progressBar: UIProgressView!
    var progress:Float{
        if todoItems.count > 0 {
            return Float(todoItems.filter({$0.completed}).count) / Float(todoItems.count)
        }else{
            return 0
        }
    }
    var connectionButtonReference:UIButton!
    
    var todoItems:[ToDoItem]!{
        didSet{
            progressBar.setProgress(progress, animated: true)
            print("todoItems did set values \(todoItems.count)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableCellAnimation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConnectivity()
        loadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadData() {
        todoItems = [ToDoItem]()
        todoItems = DataManager.loadAll(ToDoItem.self).sorted(by: {$0.createdAt > $1.createdAt})
    }
    
    func setupConnectivity(){
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
    }
    
    func showConnectivityAction() {
        let actionSheet = UIAlertController(title: "ToDo Exchange", message: "Do you want to Host or Join a session", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Host Session", style: .default, handler: { (action) in
            self.mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "ba-td", discoveryInfo: nil, session: self.mcSession)
            self.mcAdvertiserAssistant.start()
        }))
        actionSheet.addAction(UIAlertAction(title: "Join Session", style: .default, handler: { (action) in
            let mcBrowser = MCBrowserViewController(serviceType: "ba-td", session: self.mcSession)
            mcBrowser.delegate = self
            self.present(mcBrowser, animated: true, completion: nil)
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func addNewTodo() {
        let addAlert = UIAlertController(title: "New Todo", message: "Enter a title", preferredStyle: .alert)
        
        addAlert.addTextField { (textfiled) in
            textfiled.placeholder = "Todo Item Title"
        }
        
        addAlert.addAction(UIAlertAction(title: "Create", style: .default, handler: { (action) in
            guard let title = addAlert.textFields?.first?.text,title.count > 0 else { return }
            
            let newTodo = ToDoItem(title: title, completed: false, createdAt: Date(), itemIdentifier: UUID(), wasted: false)
            newTodo.saveItem()
            
//            self.todoItems.insert(newTodo)
            self.todoItems.insert(newTodo, at: 0)
            
            self.tableView.beginUpdates()
//            let indexPath = IndexPath(row: self.tableView.numberOfRows(inSection: 0), section: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
        }))
        
        addAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(addAlert, animated: true, completion: nil)
    }

    //MARK: - Table Cells Animation
    func tableCellAnimation()  {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        
        let tableHeight = tableView.bounds.size.height
        
        for cell in cells{
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        var delayCount = 0
        for cell in cells{
            UIView.animate(withDuration: 1.7, delay: Double(delayCount) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCount += 1;
            cell.layer.layoutIfNeeded()
        }
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

        
        let todoItem = todoItems[indexPath.row]
        cell.todoLabel.text = todoItem.title

        if todoItem.completed{
            cell.todoLabel.attributedText = strikeThroughText(todoItem.title)
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let shareAction = UITableViewRowAction(style: .normal, title: "Share") { (action
            , indexPath) in
            let todoItem = self.todoItems[indexPath.row]
            self.sendTodo(todoItem)
        }
        shareAction.backgroundColor = UIColor(named: "mainYellowColor")
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (action
            , indexPath) in
            self.todoItems[indexPath.row].deleteItem()
            self.todoItems.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        deleteAction.backgroundColor = UIColor(named: "mainBlueColor")
        
        return [deleteAction,shareAction]
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        completeTodoItem(indexPath)
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
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
            DispatchQueue.main.async {
                self.connectionButtonReference.setTitle("Connected", for: .normal)
            }
            
        case .connecting:
            print("Connecting: \(peerID.displayName)")
            DispatchQueue.main.sync {
                self.connectionButtonReference.setTitle("Connecting", for: .normal)
            }
            
        case .notConnected:
            print("Not Connected: \(peerID.displayName)")
            DispatchQueue.main.sync {
                self.connectionButtonReference.setTitle("Offline", for: .normal)
            }
            
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            let todoItem = try JSONDecoder().decode(ToDoItem.self, from: data)
//            DataManager.save(todoItem, with: todoItem.itemIdentifier.uuidString)
            todoItem.saveItem()
            
            DispatchQueue.main.async {
                self.loadData()
                self.tableView.reloadData()
            }
        } catch  {
            fatalError("Unable to process the received data")
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func sendTodo(_ todoItem:ToDoItem) {
        if mcSession.connectedPeers.count>0{
            if let todoData = DataManager.load(todoItem.itemIdentifier.uuidString){
                do{
                    try mcSession.send(todoData, toPeers: mcSession.connectedPeers, with: .reliable)
                }catch{
                    fatalError("Could not send todo item")
                }
            }
        }else{
            showConnectivityAction()
        }
    }
    func strikeThroughText(_ text:String)->NSAttributedString{
        let attrString:NSMutableAttributedString = NSMutableAttributedString(string: text)
        attrString.addAttribute(.strikethroughStyle, value: 1, range: NSMakeRange(0, attrString.length))
        
        return attrString
    }
    func completeTodoItem(_ indexPath: IndexPath) {
        var todoItem = todoItems[indexPath.row]
        todoItem.maskAsCompleted()
        todoItems[indexPath.row] = todoItem
        
        if let cell = tableView.cellForRow(at: indexPath) as? ToDoTableViewCell{
            cell.todoLabel.attributedText = strikeThroughText(todoItem.title)
            
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = cell.transform.scaledBy(x: 1.5, y: 1.5)
                
            },completion:{ (sucess) in
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    cell.transform = CGAffineTransform.identity
                }, completion: nil)
            })
        }
    }

}
