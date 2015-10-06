//
//  Extensions.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/8/14.
//
//

import Foundation

public extension UIView{
    
    class func loadFromNibNamed(nibNamed: String) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: NSBundle.wildcardSDKBundle()
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
    
    /// For any view with a superview, constrain all edges flush with superview. e.g. Leading, Top, Bottom, Right all 0
    public func constrainToSuperViewEdges(){
        translatesAutoresizingMaskIntoConstraints = false
        constrainLeftToSuperView(0)
        constrainRightToSuperView(0)
        constrainTopToSuperView(0)
        constrainBottomToSuperView(0)
    }
    
    /// Given a reference view, constrain this view to be exactly the same size and position (Useful for overlays that aren't child views). Superviews must be the same
    public func constrainExactlyToView(view:UIView){
        if(hasSuperview() && (superview == view.superview)){
            translatesAutoresizingMaskIntoConstraints = false
            superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
            superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
            superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1.0, constant: 0.0))
            superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1.0, constant: 0.0))
        }
    }
    
    /// Given a reference view, align left. Superviews must be the same.
    public func alignLeftToView(view:UIView){
        if(hasSuperview() && (superview == view.superview)){
            translatesAutoresizingMaskIntoConstraints = false
            let constraint = NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1.0, constant: 0)
            superview?.addConstraint(constraint)
        }
    }
    
    /// Given a reference view, align right. Superviews must be the same.
    public func alignRightToView(view:UIView){
        if(hasSuperview() && (superview == view.superview)){
            translatesAutoresizingMaskIntoConstraints = false
            let constraint = NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: 0)
            superview?.addConstraint(constraint)
        }
    }
    
    /// Given a reference view, align top. Superviews must be the same.
    public func alignTopToView(view:UIView){
        if(hasSuperview() && (superview == view.superview)){
            translatesAutoresizingMaskIntoConstraints = false
            let constraint = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0)
            superview?.addConstraint(constraint)
        }
    }
    
    /// Given a reference view, align bottom. Superviews must be the same.
    public func alignBottomToView(view:UIView){
        if(hasSuperview() && (superview == view.superview)){
            translatesAutoresizingMaskIntoConstraints = false
            let constraint = NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0)
            superview?.addConstraint(constraint)
        }
    }
    
    public func constrainLeftToSuperView(offset:CGFloat)->NSLayoutConstraint{
        translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal, toItem: self.superview, attribute: .Leading, multiplier: 1.0, constant: offset)
        superview?.addConstraint(leftConstraint)
        return leftConstraint
    }
    
    public func constrainRightToSuperView(offset:CGFloat)->NSLayoutConstraint{
        translatesAutoresizingMaskIntoConstraints = false
        let rightConstraint = NSLayoutConstraint(item: self.superview!, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: offset)
        superview?.addConstraint(rightConstraint)
        return rightConstraint
    }
    
    public func constrainTopToSuperView(offset:CGFloat)->NSLayoutConstraint{
        translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: self.superview, attribute: .Top, multiplier: 1.0, constant: offset)
        superview?.addConstraint(topConstraint)
        return topConstraint
    }
    
    public func constrainBottomToSuperView(offset:CGFloat)->NSLayoutConstraint{
        translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint = NSLayoutConstraint(item: self.superview!, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: offset)
        superview?.addConstraint(bottomConstraint)
        return bottomConstraint
    }
    
    public func verticallyCenterToSuperView(offset:CGFloat)->NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let yConstraint = NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: superview, attribute: .CenterY, multiplier: 1.0, constant: offset)
        superview!.addConstraint(yConstraint)
        return yConstraint
    }
    
    public func horizontallyCenterToSuperView(offset:CGFloat)->NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let xConstraint = NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: superview, attribute: .CenterX, multiplier: 1.0, constant: offset)
        superview!.addConstraint(xConstraint)
        return xConstraint
    }
    
    public func constrainHeight(height:CGFloat)->NSLayoutConstraint{
        translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: height)
        addConstraint(heightConstraint)
        return heightConstraint
    }
    
    public func constrainWidth(width:CGFloat)->NSLayoutConstraint{
        translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: width)
        addConstraint(widthConstraint)
        return widthConstraint
    }
    
    public func constrainWidth(width:CGFloat, height:CGFloat){
        translatesAutoresizingMaskIntoConstraints = false
        constrainHeight(height)
        constrainWidth(width)
    }

    // adds a blur overlay to the view and returns a reference to it.
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
    
    public func parentViewController() -> UIViewController? {
        var parentResponder: UIResponder? = self
        while true {
            if parentResponder == nil {
                return nil
            }
            parentResponder = parentResponder!.nextResponder()
            if parentResponder is UIViewController {
                return (parentResponder as! UIViewController)
            }
        }
    }
    
    /// Adds a bottom border with specified width and color
    func addBottomBorderWithWidth(width:CGFloat, color:UIColor)->UIView{
        let borderImageView = UIImageView(frame: CGRectZero)
        borderImageView.backgroundColor = color
        borderImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(borderImageView)
        borderImageView.constrainLeftToSuperView(0)
        borderImageView.constrainRightToSuperView(0)
        borderImageView.constrainBottomToSuperView(0)
        borderImageView.constrainHeight(width)
        return borderImageView
    }
    
    /// Adds a left border with specified width and color
    func addLeftBorderWithWidth(width:CGFloat, color:UIColor)->UIView{
        let borderImageView = UIImageView(frame: CGRectZero)
        borderImageView.backgroundColor = color
        borderImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(borderImageView)
        borderImageView.constrainLeftToSuperView(0)
        borderImageView.constrainTopToSuperView(0)
        borderImageView.constrainBottomToSuperView(0)
        borderImageView.constrainWidth(width)
        return borderImageView
    }
    
    /// Adds a right border with specified width and color
    func addRightBorderWithWidth(width:CGFloat, color:UIColor)->UIView{
        let borderImageView = UIImageView(frame: CGRectZero)
        borderImageView.backgroundColor = color
        borderImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(borderImageView)
        borderImageView.constrainRightToSuperView(0)
        borderImageView.constrainTopToSuperView(0)
        borderImageView.constrainBottomToSuperView(0)
        borderImageView.constrainWidth(width)
        return borderImageView
    }
    
    /// Adds a top border with specified width and color
    func addTopBorderWithWidth(width:CGFloat, color:UIColor)->UIView{
        let borderImageView = UIImageView(frame: CGRectZero)
        borderImageView.backgroundColor = color
        borderImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(borderImageView)
        borderImageView.constrainLeftToSuperView(0)
        borderImageView.constrainRightToSuperView(0)
        borderImageView.constrainTopToSuperView(0)
        borderImageView.constrainHeight(width)
        return borderImageView
    }
  
}