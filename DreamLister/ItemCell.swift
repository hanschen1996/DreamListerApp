//
//  ItemCell.swift
//  DreamLister
//
//  Created by Apple on 2017/1/10.
//  Copyright © 2017年 Hans. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var store: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var details: UILabel!
    
    // prototype cell displaying at main view
    func configureCell(item: Item) {
        title.text = item.title
        price.text = "Price: $\(item.price)"
        
        if let storeName = item.toStore?.name {
            store.text = "Store: \(storeName)"
        } else {
            store.text = "Store: "
        }
        
        if let itemType = item.toItemType?.type {
            type.text = "Type: \(itemType)"
        } else {
            type.text = "Type: "
        }
        
        if let itemDetails = item.details {
            details.text = "Descriptions: \(itemDetails)"
        } else {
            details.text = "Descriptions: "
        }
        
        thumb.image = item.toImage?.image as? UIImage
    }
}
