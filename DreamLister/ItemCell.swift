//
//  ItemCell.swift
//  DreamLister
//
//  Created by Tushar Katyal on 26/07/17.
//  Copyright © 2017 Tushar Katyal. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
       
    func configureCell(item:Item){
        
        title.text = item.title
        price.text = "$\(item.price)"
        details.text = item.details
        thumb.image = item.toimage?.image as? UIImage
        typeLbl.text = item.toitemtype?.type
        
    }
    
}
