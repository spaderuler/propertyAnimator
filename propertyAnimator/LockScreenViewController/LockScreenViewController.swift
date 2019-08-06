//
//  LockScreenViewController.swift
//  UIViewPropertyAnimator
//
//  Created by donggua on 2019/8/2.
//  Copyright © 2019年 wky. All rights reserved.
//

import UIKit

class LockScreenViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    var startFrame: CGRect?
    var preview: UIView?
    var previewAnimator: UIViewPropertyAnimator?
    let previewEffectView = IconEffectView(blur: .extraLight)
    let blurView = UIVisualEffectView(effect: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.bringSubviewToFront(searchBar)
        blurView.isUserInteractionEnabled = false
        view.insertSubview(blurView, belowSubview: searchBar)
        
        tableview.estimatedRowHeight = 160
        tableview.rowHeight = UITableView.automaticDimension
        tableview.tableFooterView = UIView.init(frame: CGRect.zero)
        previewEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didmissMenu)))
    }
    
    override func viewWillLayoutSubviews() {
        blurView.frame = view.bounds
    }
    
    @objc func didmissMenu() {
        let resetAnimator = AnimatorFactory.reset(frame: startFrame!, effectView: previewEffectView, blurView: blurView)
        resetAnimator.addCompletion { (_) in
            self.preview?.removeFromSuperview()
            self.previewEffectView.removeFromSuperview()
            self.blurView.isUserInteractionEnabled = false
        }
        resetAnimator.startAnimation()
    }
    
}


extension LockScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 160
    }
}

extension LockScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "footerCell") as! FooterCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "widgetCell") as! WidgetCell
            cell.owner = self
            return cell
        }
    }
}

// WidgetsOwnerProtocol
extension LockScreenViewController: WidgetsOwnerProtocol {
    func startPreview(for forView: UIView) {
        preview?.removeFromSuperview()
        preview = forView.snapshotView(afterScreenUpdates: false)
        view.insertSubview(preview!, aboveSubview: blurView)
        
        preview?.frame = forView.convert(forView.bounds, to: view)
        startFrame = preview?.frame
        addEffectView(below: preview!)
        previewAnimator = AnimatorFactory.grow(effectView: previewEffectView, blurView: blurView)
    }
    
    func addEffectView(below forView: UIView) {
        previewEffectView.removeFromSuperview()
        previewEffectView.frame = forView.frame
        forView.superview?.insertSubview(previewEffectView, belowSubview: forView)
    }
    
    func updatePreview(percent: CGFloat) {
        previewAnimator?.fractionComplete = max(0.01, min(0.99, percent))
    }
    
    func finishPreview() {
        
        previewAnimator?.stopAnimation(true)
        previewAnimator?.finishAnimation(at: .end)
        previewAnimator = nil

        AnimatorFactory.complete(view: previewEffectView).startAnimation()
        blurView.effect = UIBlurEffect(style: .dark)
        blurView.isUserInteractionEnabled = true
        blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didmissMenu)))
    }
    
    func cancelPreview() {
        if let animator = previewAnimator {
            animator.isReversed = true
            animator.startAnimation()
            animator.addCompletion { (position) in
                switch position{
                case .start:
                    self.preview?.removeFromSuperview()
                    self.previewEffectView.removeFromSuperview()
                default: break
                }
            }
        }
    }

}
