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
    var settingVC: SettingsViewController!
    var startFrame: CGRect?
    var preview: UIView?
    var previewAnimator: UIViewPropertyAnimator?
    
    let previewEffectView = IconEffectView(blur: .extraLight)
    let blurView = UIVisualEffectView(effect: nil)
    let presentTransition = PresentTransition()
    
    var isDrapping = false
    var isPresentingSettings = false
    var touchsStartPointY: CGFloat?

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
    
    func toggleBlur(_ blurred: Bool) {
        UIViewPropertyAnimator(duration: 0.55,
                               controlPoint1: CGPoint(x: 0.57, y: -0.4),
                               controlPoint2: CGPoint(x: 0.96, y: 0.87),
                               animations: blurAnimations(blurred))
            .startAnimation()
    }
    
    func blurAnimations(_ blurred: Bool) -> () -> Void {
        return {
            self.blurView.effect = blurred ? UIBlurEffect(style: .dark) : nil
            self.tableview.transform = blurred ? CGAffineTransform(scaleX: 0.75, y: 0.75) : .identity
            self.tableview.alpha = blurred ? 0.33 : 1.0
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func presentSetting(_ sender: Any) {
        self.presentTransition.wantsInteractiveStart = false
        presentTransition.auxAnimations = blurAnimations(true)
        presentTransition.auxAnimarionsCancel = blurAnimations(false)
        settingVC = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController
        settingVC.transitioningDelegate = self
        settingVC.didDismiss = {
            self.toggleBlur(false)
        }
        present(settingVC, animated: true, completion: nil)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard presentTransition.wantsInteractiveStart == false, let _ = presentTransition.animator else {
            return
        }
        
        touchsStartPointY = touches.first!.location(in: view).y
        presentTransition.interruptTransition()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let startY = touchsStartPointY else {
            return
        }
        
        let currentPointY = touches.first!.location(in: view).y
        if currentPointY < startY - 40 {
            touchsStartPointY = nil
            presentTransition.animator?.addCompletion({ (_) in
                self.blurView.effect = nil
            })
        }else {
            touchsStartPointY = nil
            presentTransition.finish()
        }
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

extension LockScreenViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return presentTransition
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return presentTransition
    }
}

extension LockScreenViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDrapping = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isDrapping else {
            return
        }
        
        if !isPresentingSettings && scrollView.contentOffset.y < -30 {
            isPresentingSettings = true
            presentTransition.wantsInteractiveStart = true
            presentSetting(Void.self)
            return
        }
        
        if isPresentingSettings {
            let progress = max(1, min(1, ((-scrollView.contentOffset.y) - 30)/90))
            presentTransition.update(progress)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let progress = max(1, min(1, ((-scrollView.contentOffset.y) - 30)/90))
        if progress > 0.5 {
            presentTransition.finish()
        }else {
            presentTransition.cancel()
        }
        
        isPresentingSettings = false
        isDrapping = false
    }
}
