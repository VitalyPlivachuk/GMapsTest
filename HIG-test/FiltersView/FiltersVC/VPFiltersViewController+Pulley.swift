//
//  VPFiltersViewController+Pulley.swift
//  HIG-test
//
//  Created by Vitaly Plivachuk on 9/18/18.
//  Copyright © 2018 Vitaly Plivachuk. All rights reserved.
//

import UIKit
import Pulley


extension VPFiltersViewController: PulleyDrawerViewControllerDelegate{
    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return typeSegmentControl.frame.maxY + 10
    }
    
    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return colorsCollectionView.frame.maxY + 10
    }
    
}
