//
//  ViewController.swift
//  DreamLister
//
//  Created by Tushar Katyal on 23/07/17.
//  Copyright © 2017 Tushar Katyal. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController , UITableViewDataSource,UITableViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var controller : NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
      //  generateTestData() func to insert some test data into datatable item
        attemptFetch() // func to fetch data from table
        
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        configureCell(cell: cell, indexpath: indexPath as NSIndexPath)
        return cell
    }
   
    
    func configureCell(cell : ItemCell, indexpath : NSIndexPath){
        let item = controller.object(at: indexpath as IndexPath)
        cell.configureCell(item: item)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let objs = controller.fetchedObjects , objs.count > 0
        {
            let item = objs[indexPath.row]
            
            performSegue(withIdentifier: "ItemDetailsVc", sender: item)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ItemDetailsVc" {
            
            if let destination = segue.destination as? ItemDetailsVC {
                
                if let item = sender as? Item {
                    
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = controller.sections {
            
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        else{
        return 0
        }
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections
        {
            return sections.count
        }
        else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 149.5
    }
    
    func attemptFetch(){
        
        let fetchRequest : NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key:"creatodon", ascending: false)
        let priceSort =  NSSortDescriptor(key: "price", ascending: true)
        let titleSort =  NSSortDescriptor(key: "title", ascending: true)
        
        if segment.selectedSegmentIndex == 0 {
            fetchRequest.sortDescriptors = [dateSort]
        }
        else if segment.selectedSegmentIndex == 1 {
                fetchRequest.sortDescriptors = [priceSort]
            }
        else if segment.selectedSegmentIndex == 2 {
                fetchRequest.sortDescriptors = [titleSort]
        }

        controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        do {
            try controller.performFetch()
            
        }
        catch let err as NSError {
            print("\(err)")
        }
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        attemptFetch()
        tableView.reloadData()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
            
        case.insert :
            if let indexpath = newIndexPath {
                tableView.insertRows(at: [indexpath], with: .fade)
            }
        break
        case.delete :
            if let indexpath = indexPath {
                tableView.deleteRows(at: [indexpath], with: .fade)
            }
            break
        case.update :
            if let indexpath = indexPath {
                let cell = tableView.cellForRow(at: indexpath) as! ItemCell
                configureCell(cell: cell, indexpath: indexpath as NSIndexPath)
            }
            break
           
        case.move :
            if let indexpath = indexPath {
                tableView.deleteRows(at: [indexpath], with: .fade)
                if let indexpath = newIndexPath {
                    tableView.insertRows(at: [indexpath], with: .fade)
                }
            }
            
        }
    }
    
    
}

func generateTestData(){
    
    let item = Item(context: context)
    item.title = "New MacBook Pro"
    item.price = 1800
    item.details = "i can't wait till september"
    
    let item2 = Item(context: context)
    item2.title = "JBl 100csi"
    item2.price = 15
    item2.details = "need them for songs and it's great"
    
    let item3 = Item(context: context)
    item3.title = "Audi A8"
    item3.price = 180000
    item3.details = "ione day i'll have this thing "
    
    let item4 = Item(context: context)
    item4.title = "iphone 8"
    item4.price = 300
    item4.details = "it's going to be a great smartphone"
    
    ad.saveContext()
}

