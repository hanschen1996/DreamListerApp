//
//  ItemType+CoreDataProperties.swift
//  DreamLister
//
//  Created by Apple on 2017/1/10.
//  Copyright © 2017年 Hans. All rights reserved.
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType");
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
