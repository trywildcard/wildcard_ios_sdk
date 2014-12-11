//
//  Extensions.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/8/14.
//
//

import Foundation

extension UIView{
    // for any view with a superview, constrain all edges flush with superview
    func constrainToSuperViewEdges(){
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.superview, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0))
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.superview, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0))
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.superview, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0.0))
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.superview, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0.0))
        self.superview?.layoutIfNeeded()
    }
    
    // adds a dark blur overlay to the view and returns a reference to it.
    func addBlurOverlay(style:UIBlurEffectStyle)->UIView{
        let overlay = UIView(frame: CGRectZero)
        addSubview(overlay)
        overlay.constrainToSuperViewEdges()
        
        let visualEffect = UIVisualEffectView(effect: UIBlurEffect(style:style)) as UIVisualEffectView
        overlay.addSubview(visualEffect)
        visualEffect.constrainToSuperViewEdges()
        
        return overlay
    }
    
    func hasSuperview()->Bool{
        return superview != nil
    }
    
    func parentViewController() -> UIViewController? {
        var parentResponder: UIResponder? = self
        while true {
            if parentResponder == nil {
                return nil
            }
            parentResponder = parentResponder!.nextResponder()
            if parentResponder is UIViewController {
                return (parentResponder as UIViewController)
            }
        }
    }
  
}