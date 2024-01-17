//
//  CategoryCollectionViewCell.swift
//  Newsapp
//
//  Created by LinhMAC on 03/09/2023.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak private var categoryLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryLb.text = nil
    }
    
    func bindData(category title: String?) {
        categoryLb.text = title
    }
}
