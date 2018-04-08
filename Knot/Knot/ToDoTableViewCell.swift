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

    
    @IBOutlet weak var todoReminder: UILabel!
    @IBOutlet weak var todoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.contentView.backgroundColor = UIColor.darkGray
 
    }

}
