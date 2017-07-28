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
    @IBOutlet weak var pickerViewtype: UIPickerView!
    @IBOutlet weak var titleField : CustomTextField!
    @IBOutlet weak var priceField : CustomTextField!
    @IBOutlet weak var detailsField : CustomTextField!
    
    @IBOutlet weak var thumbImg: UIImageView!
    var stores = [Store]()
    var itemToEdit : Item?
    var imagePicker : UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title:"Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        
        pickerViewStore.dataSource = self
        pickerViewStore.delegate = self
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
//        let store = Store(context: context)
//        store.name = "Staples"
//        let store2 = Store(context: context)
//        store2.name = "Amazon"
//        let store3 = Store(context: context)
//        store3.name = "Costco"
//        let store4 = Store(context: context)
//        store4.name = "walmart"
//        let store5 = Store(context: context)
//        store5.name = "Flipkart"
//        let store6 = Store(context: context)
//        store6.name = "Best Buy"
//        
//        ad.saveContext()
        getStores() // func to get data from store using fetch request 
        
        if itemToEdit != nil {
            loadItemData()
        }
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let storeName = stores[row]
        
        return storeName.name
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }

    func getStores(){
        
        let fetchRequest : NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            self.stores = try context.fetch(fetchRequest)
            self.pickerViewStore.reloadAllComponents()
        } catch let err as NSError{
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
