//
//  ItemSearchViewCell.swift
//  Realm_Demo
//
//  Created by Sky on 12/1/19.
//  Copyright © 2019 Andy. All rights reserved.
//

import UIKit

@objc protocol ItemSearchViewCellDelegate: NSObjectProtocol {
    func itemSearchViewCell(cell: ItemSearchViewCell, didDeleteAt index: Int)
}
class ItemSearchViewCell: UITableViewCell {
    @IBOutlet weak var lbContent: UILabel!
    var index: Int!
    weak var delegate: ItemSearchViewCellDelegate?
    
    @IBAction func btnDeleteTapped(_ sender: Any) {
        delegate?.itemSearchViewCell(cell: self, didDeleteAt: index)
    }
}
