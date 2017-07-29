//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Tushar Katyal on 26/07/17.
//  Copyright © 2017 Tushar Katyal. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate ,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var pickerViewStore : UIPickerView!
    @IBOutlet weak var titleField : CustomTextField!
    @IBOutlet weak var priceField : CustomTextField!
    @IBOutlet weak var detailsField : CustomTextField!
    
    @IBOutlet weak var thumbImg: UIImageView!
    var stores = [Store]()
    var itemToEdit : Item?
    var imagePicker : UIImagePickerController!
    var type = [ItemType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title:"Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        
        pickerViewStore.dataSource = self
        pickerViewStore.delegate = self
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let store = Store(context: context)
        store.name = "Staples"
        let store2 = Store(context: context)
        store2.name = "Amazon"
        let store3 = Store(context: context)
        store3.name = "Costco"
        let store4 = Store(context: context)
        store4.name = "walmart"
        let store5 = Store(context: context)
        store5.name = "Flipkart"
        let store6 = Store(context: context)
        store6.name = "Best Buy"
        

        
        let type = ItemType(context: context)
        type.type = "Clothing"
        let type2 = ItemType(context: context)
        type2.type = "Electrical"
        let type3 = ItemType(context: context)
        type3.type = "Shoe"
        let type4 = ItemType(context: context)
        type4.type = "Bike"
        let type5 = ItemType(context: context)
        type5.type = "Car"
        
        ad.saveContext()
        
        getStores() // func to get data from store using fetch request 
        getItemType()
        if itemToEdit != nil {
            loadItemData()
        }
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {

        return stores.count
        }
        else {
            return type.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        if component == 0 {
        let storeName = stores[row]
        
        return storeName.name
        }
        else {
            let typeName = type[row]
            return typeName.type
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }

    func getStores(){
        
        let fetchRequestStore : NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            self.stores = try context.fetch(fetchRequestStore)
            self.pickerViewStore.reloadAllComponents()
        } catch let err as NSError{
            print(err)
        }
    }
    func getItemType(){
        
        let fetchRequestType : NSFetchRequest<ItemType> = ItemType.fetchRequest()
        do {
            self.type = try context.fetch(fetchRequestType)
        } catch let err as NSError {
            print(err)
        }
        
    }
    
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        
        var item : Item!
        let picture = Image(context: context)
        
        if itemToEdit == nil {
            item = Item(context: context)
        }
        else{
            item = itemToEdit
        }
        
        picture.image = thumbImg.image
        item.toimage = picture
        if let title = titleField.text {
            
            item.title = title
        }
        
        if let price = priceField.text{
            
            item.price = (price as NSString).doubleValue
        }
        if let details = detailsField.text {
            item.details = details
        }
        
        item.toitemtype = type[pickerViewStore.selectedRow(inComponent: 1)]
        
        item.tostore = stores[pickerViewStore.selectedRow(inComponent: 0)]
        ad.saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    func loadItemData(){
        
        if let item = itemToEdit {
            
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            thumbImg.image = item.toimage?.image as? UIImage
            
            
            if let types = item.toitemtype {
                
                var i = 0
                
                repeat {
                    let t = type[i]
                    if t.type == types.type {
                        pickerViewStore.selectRow(i, inComponent: 1, animated: false)
                    }
                    i += 1
                }while ( i < type.count )
            }
               
            
            if let store = item.tostore {
                
                var index = 0
                
                repeat {
                     let s = stores[index]
                    if s.name == store.name
                    {
                        pickerViewStore.selectRow(index, inComponent: 0, animated: false)
                        }
                    index += 1
                    
                }while (index < stores.count)
            }
        }
    }
    
    @IBAction func trashBtnPressed(_ sender: UIBarButtonItem) {
        
        if itemToEdit != nil {
            
            context.delete(itemToEdit!)
            
            ad.saveContext()
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func addIMG(_ sender: UIButton) {
        
       present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
        
            thumbImg.image = img
    }
    
     imagePicker.dismiss(animated: true, completion: nil)
    }
}
