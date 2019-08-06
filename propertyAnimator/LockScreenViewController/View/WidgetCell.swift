//
//  WidgetCell.swift
//  UIViewPropertyAnimator
//
//  Created by donggua on 2019/8/2.
//  Copyright © 2019年 wky. All rights reserved.
//

import UIKit

class WidgetCell: UITableViewCell {

    @IBOutlet weak var widgetView: WidgetView!
    var owner: WidgetsOwnerProtocol? {
        didSet {
            if let owner = owner {
                widgetView.owner = owner
            }
        }
    }
    
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.clear
        widgetView.layer.masksToBounds = true
        widgetView.layer.cornerRadius = 12
//        widgetView.backgroundColor = UIColor.red
    }
}
