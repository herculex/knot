//
//  ToDoItem.swift
//  Knot
//
//  Created by liubo on 2018/2/20.
//  Copyright © 2018年 liubo. All rights reserved.
//

import Foundation

struct ToDoItem : Codable {
    
    var title:String
    var completed:Bool
    var createdAt:Date
    var itemIdentifier:UUID
    var completedAt:Date
    
//    init(title:String,completed:Bool,createdAt:Date,itemIdentifier:UUID) {
//        self.title = title
//        self.completed = completed
//        self.createdAt = createdAt
//        self.itemIdentifier = uuid
//    }
    func saveItem() {
        DataManager.save(self, with: itemIdentifier.uuidString)
    }
    func deleteItem()
    {
        DataManager.delete(itemIdentifier.uuidString)
    }
    
    mutating func maskAsCompleted(){
        self.completed = true
        self.completedAt = Date()
        
        DataManager.save(self, with: itemIdentifier.uuidString)
    }
}
