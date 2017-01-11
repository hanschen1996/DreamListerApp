//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Apple on 2017/1/10.
//  Copyright © 2017年 Hans. All rights reserved.
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.created = NSDate()
    }

}
