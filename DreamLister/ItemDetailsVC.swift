//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Apple on 2017/1/10.
//  Copyright © 2017年 Hans. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var priceTextView: UITextView!
    @IBOutlet weak var detailsTextView: UITextView!
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var typePicker: UIPickerView!

    @IBOutlet weak var thumbImage: UIImageView!
    
    var titlePlaceHolder = "Enter a Title..."
    var pricePlaceHolder = "Enter the Price..."
    var detailsPlaceHolder = "Enter a Description..."
    
    var imagePicker: UIImagePickerController!
    var stores = [Store]()
    var itemTypes = [ItemType]()
    var itemToEdit: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topItem = self.navigationController?.navigationBar.topItem { // back button won't have a title
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        titleTextView.delegate = self
        priceTextView.delegate = self
        detailsTextView.delegate = self
        
        storePicker.delegate = self
        storePicker.dataSource = self
        typePicker.delegate = self
        typePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        getStores()
        getItemTypes()
        
        if (stores.count == 0 || itemTypes.count == 0) {
            generateStores()
            generateTypes()
        }
        
        if (itemToEdit != nil) {
            loadItemData()
        }
    }
    
    // added some placeholder features
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.textColor = UIColor.black
        if textView == titleTextView {
            if (titleTextView.text == titlePlaceHolder) {
                titleTextView.text = ""
            }
        } else if textView == priceTextView {
            if (priceTextView.text == pricePlaceHolder) {
                priceTextView.text = ""
            }
        } else {
            if (detailsTextView.text == detailsPlaceHolder) {
                detailsTextView.text = ""
            }
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == titleTextView {
            if (titleTextView.text == "") {
                titleTextView.text = titlePlaceHolder
                titleTextView.textColor = UIColor.lightGray
            }

        } else if textView == priceTextView {
            if (priceTextView.text == "") {
                priceTextView.text = pricePlaceHolder
                priceTextView.textColor = UIColor.lightGray
            }
            
        } else {
            if (detailsTextView.text == "") {
                detailsTextView.text = detailsPlaceHolder
                detailsTextView.textColor = UIColor.lightGray
            }
        }
    }
    
    // center the texts in textViews
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if titleTextView.text != titlePlaceHolder {
            titleTextView.textColor = UIColor.black
        }
        
        if priceTextView.text != pricePlaceHolder {
            priceTextView.textColor = UIColor.black
        }
        
        if detailsTextView.text != detailsPlaceHolder {
            detailsTextView.textColor = UIColor.black
        }
        
        titleTextView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        priceTextView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        detailsTextView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        titleTextView.removeObserver(self, forKeyPath: "contentSize")
        priceTextView.removeObserver(self, forKeyPath: "contentSize")
        detailsTextView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let textView = object as! UITextView
        var topCorrect = (textView.bounds.size.height - textView.contentSize.height * textView.zoomScale) / 2
        topCorrect = topCorrect < 0.0 ? 0.0 : topCorrect
        textView.contentInset.top = topCorrect
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == storePicker) {
            let store = stores[row]
            return store.name
        } else {
            let itemType = itemTypes[row]
            return itemType.type
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == storePicker) {
            return stores.count
        } else {
            return itemTypes.count
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // update
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        var item: Item!
        
        item = itemToEdit != nil ? itemToEdit : Item(context: context)
        
        let picture = Image(context: context)
        picture.image = thumbImage.image
        
        item.toImage = picture
        
        if (titleTextView.text != titlePlaceHolder) {
            item.title = titleTextView.text
        } else {
            item.title = ""
        }
        
        if (priceTextView.text != pricePlaceHolder) {
            item.price = (priceTextView.text as NSString).doubleValue
        } else {
            item.price = 0
        }
        
        if (detailsTextView.text != detailsPlaceHolder) {
            item.details = detailsTextView.text
        } else {
            item.details = ""
        }
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        item.toItemType = itemTypes[typePicker.selectedRow(inComponent: 0)]
        ad.saveContext()
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    // pressed the delete button
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    // load item data passed from the item selected at main view
    func loadItemData() {
        if let item = itemToEdit {
            titleTextView.text = item.title
            priceTextView.text = "\(item.price)"
            detailsTextView.text = item.details
            
            thumbImage.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore {
                for i in 0..<stores.count {
                    if stores[i].name == store.name {
                        storePicker.selectRow(i, inComponent: 0, animated: false)
                        break
                    }
                }
            }
            
            if let itemType = item.toItemType {
                for i in 0..<itemTypes.count {
                    if itemTypes[i].type == itemType.type {
                        typePicker.selectRow(i, inComponent: 0, animated: false)
                    }
                }
            }
        }
    }
    
    // add image, display an image picker selecting image from camera roll
    @IBAction func addImage(_ sender: UIButton) {
        // present the image
        present(imagePicker, animated: true, completion: nil)
    }
    
    // assign the picked image to the thumbImage
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumbImage.image = img
        }
        
        // go back to the previous view
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    // get stores data saved in core data
    func getStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {
            // handle errors
        }
    }
    
    // get item types saved in core data
    func getItemTypes() {
        let fetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        
        do {
            self.itemTypes = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {
            // handle errors
        }
    }
    
    // generate some test data: stores
    func generateStores() {
        let store1 = Store(context: context)
        store1.name = "Amazon"
        stores.append(store1)
        
        let store2 = Store(context: context)
        store2.name = "Ebay"
        stores.append(store2)
        
        let store3 = Store(context: context)
        store3.name = "Target"
        stores.append(store3)
        
        let store4 = Store(context: context)
        store4.name = "Tesla Dealership"
        stores.append(store4)
        
        let store5 = Store(context: context)
        store5.name = "Fries Electronics"
        stores.append(store5)
        
        let store6 = Store(context: context)
        store6.name = "Taobao"
        stores.append(store6)
        
        ad.saveContext()
        
    }
    
    // generate some test data: types
    func generateTypes() {
        let type1 = ItemType(context: context)
        type1.type = "Electronics"
        itemTypes.append(type1)
        
        let type2 = ItemType(context: context)
        type2.type = "Clothing"
        itemTypes.append(type2)
        
        let type3 = ItemType(context: context)
        type3.type = "Toys"
        itemTypes.append(type3)
        
        let type4 = ItemType(context: context)
        type4.type = "Bathing"
        itemTypes.append(type4)
        
        let type5 = ItemType(context: context)
        type5.type = "Bedding"
        itemTypes.append(type5)
        
        let type6 = ItemType(context: context)
        type6.type = "Miscellaneous"
        itemTypes.append(type6)
        
        ad.saveContext()
    }

}
