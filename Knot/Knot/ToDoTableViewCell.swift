//
//  ToDoTableViewCell.swift
//  Knot
//
//  Created by liubo on 2018/2/23.
//  Copyright © 2018年 liubo. All rights reserved.
//

import UIKit

protocol TodoCellDelegate {
    func didRequestDelete(_ cell:ToDoTableViewCell)
    func didRequestComplete(_ cell:ToDoTableViewCell)
    func didRequestShare(_ cell:ToDoTableViewCell)
}

class ToDoTableViewCell: UITableViewCell {

    var delegate:TodoCellDelegate?
    
    @IBOutlet weak var todoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func shareTodo(_ sender: UIButton) {
        if let delegateObject = self.delegate{
            delegateObject.didRequestShare(self)
        }
    }
    @IBAction func deleteTodo(_ sender: UIButton) {
        if let delegateObject = self.delegate{
            delegateObject.didRequestDelete(self)
        }
    }
    @IBAction func completeTodo(_ sender: UIButton) {
        if let delegateObject = self.delegate{
            delegateObject.didRequestComplete(self)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
