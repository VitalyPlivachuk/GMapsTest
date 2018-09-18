//
//  VPColorCollectionViewCell.swift
//  HIG-test
//
//  Created by Vitaly Plivachuk on 9/18/18.
//  Copyright © 2018 Vitaly Plivachuk. All rights reserved.
//

import UIKit

class VPColorCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var colorView: UIView!
    
    var color:UIColor?{
        didSet{
            colorView.backgroundColor = color
        }
    }
    
    override var isSelected: Bool{
        didSet{
            if isSelected{
                colorView.layer.borderColor = UIColor.gray.cgColor
                colorView.layer.borderWidth = 3
            } else {
                colorView.layer.borderWidth = 0
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        colorView.layer.cornerRadius = 3
    }

}
