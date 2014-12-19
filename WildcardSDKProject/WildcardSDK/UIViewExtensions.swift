//
//  Extensions.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/8/14.
//
//

import Foundation

public extension UIView{
    
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
    
    // for any view with a superview, constrain all edges flush with superview
    public func constrainToSuperViewEdges(){
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        superview?.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.superview, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0))
        superview?.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.superview, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0))
        superview?.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.superview, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0.0))
        superview?.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.superview, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0.0))
        superview?.layoutIfNeeded()
    }
    
    public func constrainLeftToSuperView(offset:CGFloat)->NSLayoutConstraint{
        setTranslatesAutoresizingMaskIntoConstraints(false)
        let leftConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.superview, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: offset)
        superview?.layoutIfNeeded()
        return leftConstraint
    }
    
    public func constrainRightToSuperView(offset:CGFloat)->NSLayoutConstraint{
        setTranslatesAutoresizingMaskIntoConstraints(false)
        let rightConstraint = NSLayoutConstraint(item: self.superview!, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: offset)
        superview?.layoutIfNeeded()
        return rightConstraint
    }
    
    public func constrainTopToSuperView(offset:CGFloat)->NSLayoutConstraint{
        setTranslatesAutoresizingMaskIntoConstraints(false)
        let topConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.superview, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: offset)
        superview?.layoutIfNeeded()
        return topConstraint
    }
    
    public func constrainBottomToSuperView(offset:CGFloat)->NSLayoutConstraint{
        setTranslatesAutoresizingMaskIntoConstraints(false)
        let bottomConstraint = NSLayoutConstraint(item: self.superview!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: offset)
        superview?.layoutIfNeeded()
        return bottomConstraint
    }
    
    public func verticallyCenterToSuperView(offset:CGFloat)->NSLayoutConstraint {
        setTranslatesAutoresizingMaskIntoConstraints(false)
        let yConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: superview, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: offset)
        superview!.addConstraint(yConstraint)
        return yConstraint
    }
    
    public func horizontallyCenterToSuperView(offset:CGFloat)->NSLayoutConstraint {
        setTranslatesAutoresizingMaskIntoConstraints(false)
        let xConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: superview, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: offset)
        superview!.addConstraint(xConstraint)
        return xConstraint
    }
    
    public func constrainHeight(height:CGFloat)->NSLayoutConstraint{
        setTranslatesAutoresizingMaskIntoConstraints(false)
        let heightConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: height)
        superview!.addConstraint(heightConstraint)
        return heightConstraint
    }
    
    public func constrainWidth(width:CGFloat)->NSLayoutConstraint{
        setTranslatesAutoresizingMaskIntoConstraints(false)
        let widthConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: width)
        superview!.addConstraint(widthConstraint)
        return widthConstraint
    }
    
    public func constrainWidth(width:CGFloat, andHeight:CGFloat){
        setTranslatesAutoresizingMaskIntoConstraints(false)
        addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: width))
        addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: andHeight))
    }
    
    // adds a blur overlay to the view and returns a reference to it.
    public func addBlurOverlay(style:UIBlurEffectStyle)->UIView{
        let overlay = UIView(frame: CGRectZero)
        addSubview(overlay)
        overlay.constrainToSuperViewEdges()
        
        let visualEffect = UIVisualEffectView(effect: UIBlurEffect(style:style)) as UIVisualEffectView
        overlay.addSubview(visualEffect)
        visualEffect.constrainToSuperViewEdges()
        
        return overlay
    }
    
    public func hasSuperview()->Bool{
        return superview != nil
    }
    
    public func parentViewController() -> UIViewController? {
        var parentResponder: UIResponder? = self
        while true {
            if parentResponder == nil {
                return nil
            }
            parentResponder = parentResponder!.nextResponder()
            println(parentResponder)
            if parentResponder is UIViewController {
                return (parentResponder as UIViewController)
            }
        }
    }
    
    func addBottomBorderWithWidth(width:CGFloat, color:UIColor){
        let borderImageView = UIImageView(frame: CGRectZero)
        borderImageView.backgroundColor = color
        borderImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(borderImageView)
        addConstraint(NSLayoutConstraint(item: borderImageView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: borderImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: borderImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: width))
        addConstraint(NSLayoutConstraint(item: borderImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
    }
    
    func addTopBorderWithWidth(width:CGFloat, color:UIColor){
        let borderImageView = UIImageView(frame: CGRectZero)
        borderImageView.backgroundColor = color
        borderImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(borderImageView)
        addConstraint(NSLayoutConstraint(item: borderImageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: borderImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: borderImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: width))
        addConstraint(NSLayoutConstraint(item: borderImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
    }
  
}