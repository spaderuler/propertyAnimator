//
//  SettingsViewController.swift
//  UIViewPropertyAnimator
//
//  Created by donggua on 2019/8/2.
//  Copyright © 2019年 wky. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var effectview: UIVisualEffectView!
    
    var items: [String] = ["Add Weather", "Add Stocks", "Add raywenderlich.com", "Cancel"]
    var didDismiss: (() -> Void)?
    
    override func viewDidLoad() {
        tableview.layer.masksToBounds = true
        tableview.layer.cornerRadius = 14
        effectview.layer.masksToBounds = true
        effectview.layer.cornerRadius = 14
    }
    
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true, completion: didDismiss)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.textColor = UIColor.white.withAlphaComponent(0.9)
        return cell
    }
    
}
