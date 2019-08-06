//
//  WidgetView.swift
//  UIViewPropertyAnimator
//
//  Created by donggua on 2019/8/2.
//  Copyright © 2019年 wky. All rights reserved.
//

import UIKit

class WidgetView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var previewInteraction: UIPreviewInteraction?
    var owner: WidgetsOwnerProtocol!
    let items: [String] = ["Bahama Air", "PackMe", "Fight", "Slide", "Iris", "Herbs", "Reveal", "Office"]
    override func didMoveToWindow() {
        super.didMoveToWindow()

        guard let _ = superview else {
            previewInteraction?.delegate = nil
            return
        }
        previewInteraction = UIPreviewInteraction(view: collectionView)
        previewInteraction?.delegate = self
    }
}

//
// MARK: - Collection View data source
//
extension WidgetView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! IconCell
        cell.name.text = items[indexPath.row]
        cell.icon.image = UIImage(named: "icon\(indexPath.row+1)")
        return cell
    }
}

extension WidgetView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)

        if let cell = collectionView.cellForItem(at: indexPath) as? IconCell {
            cell.iconJiggle()
        }
    }
}


//
// MARK: - Peak delegate methods
//
extension WidgetView: UIPreviewInteractionDelegate {
    
    func previewInteractionShouldBegin(_ previewInteraction: UIPreviewInteraction) -> Bool {
        if let indexPath = collectionView?.indexPathForItem(at: previewInteraction.location(in: collectionView!)), let cell = collectionView?.cellForItem(at: indexPath) as? IconCell {
            owner.startPreview(for: cell.icon)
        }
        return true
    }
    
    func previewInteraction(_ previewInteraction: UIPreviewInteraction, didUpdatePreviewTransition transitionProgress: CGFloat, ended: Bool) {
        owner.updatePreview(percent: transitionProgress)
        if ended {
            owner.finishPreview()
        }
    }
    
    func previewInteractionDidCancel(_ previewInteraction: UIPreviewInteraction) {
        owner.cancelPreview()
    }
    
}

