//
//  DbUIViewExtensions.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/30/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//  Base on : https://raw.githubusercontent.com/SwifterSwift/SwifterSwift/master/Sources/Extensions/UIKit/UIViewExtensions.swift

// MARK: - enums

/// SwifterSwift: Shake directions of a view.
///
/// - horizontal: Shake left and right.
/// - vertical: Shake up and down.
public enum DbShakeDirection {
    case horizontal
    case vertical
}

/// SwifterSwift: Angle units.
///
/// - degrees: degrees.
/// - radians: radians.
public enum DbAngleUnit {
    case degrees
    case radians
}

/// SwifterSwift: Shake animations types.
///
/// - linear: linear animation.
/// - easeIn: easeIn animation
/// - easeOut: easeOut animation.
/// - easeInOut: easeInOut animation.
public enum DbShakeAnimationType {
    case linear
    case easeIn
    case easeOut
    case easeInOut
}

// MARK: - Properties
public extension UIView {
    
    /// SwifterSwift: Border color of view; also inspectable from Storyboard.
    @IBInspectable
    var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            layer.borderColor = color.cgColor
        }
    }
    
    /// SwifterSwift: Border width of view; also inspectable from Storyboard.
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    /// SwifterSwift: Corner radius of view; also inspectable from Storyboard.
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }
    
    /// SwifterSwift: First responder.
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }
        for subView in subviews where subView.isFirstResponder {
            return subView
        }
        return nil
    }
    
    /// SwifterSwift: Take screenshot of view (if applicable).
    var screenshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// SwifterSwift: Shadow color of view; also inspectable from Storyboard.
    var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    /// SwifterSwift: Shadow offset of view; also inspectable from Storyboard.
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    /// SwifterSwift: Shadow opacity of view; also inspectable from Storyboard.
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    /// SwifterSwift: Shadow radius of view; also inspectable from Storyboard.
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    /// SwifterSwift: Get view's parent view controller
    var parentViewController: UIViewController? {
        weak var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
}

// MARK: - Properties Layout
public extension UIView {
    
    /// SwifterSwift: x origin of view.
    var x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }
    
    /// SwifterSwift: y origin of view.
    var y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
    
    /// SwifterSwift: Width of view.
    var width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }
    
    // SwifterSwift: Height of view.
    var height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }
    
    /// SwifterSwift: Size of view.
    var size: CGSize {
        get {
            return frame.size
        }
        set {
            width = newValue.width
            height = newValue.height
        }
    }
    
    var origin: CGPoint {
        get {
            return frame.origin
        }
        set {
            x = newValue.x
            y = newValue.y
        }
    }
    
    /// SwifterSwift: center x origin of view.
    var centerX: CGFloat {
        get {
            return center.x
        }
        set {
            center.x = newValue
        }
    }
    
    /// SwifterSwift: center y origin of view.
    var centerY: CGFloat {
        get {
            return center.y
        }
        set {
            center.y = newValue
        }
    }
    
    /// SwifterSwift: x origin of view.
    var top: CGFloat {
        get {
            return y
        }
        set {
            y = newValue
        }
    }
    
    /// SwifterSwift: y origin of view.
    var left: CGFloat {
        get {
            return x
        }
        set {
            x = newValue
        }
    }
    
    /// SwifterSwift: bottom origin of view.
    var bottom: CGFloat {
        get {
            return y + height
        }
        set {
            y = newValue - height
        }
    }
    
    /// SwifterSwift: bottom origin of view.
    var right: CGFloat {
        get {
            return x + width
        }
        set {
            x = newValue - width
        }
    }
}

// MARK: - Methods
public extension UIView {
    
    /// SwifterSwift: Set some or all corners radiuses of view.
    ///
    /// - Parameters:
    ///   - corners: array of corners to change (example: [.bottomLeft, .topRight]).
    ///   - radius: radius for selected corners.
    func db_roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
    
    /// SwifterSwift: Add shadow to view.
    ///
    /// - Parameters:
    ///   - color: shadow color (default is #137992).
    ///   - radius: shadow radius (default is 3).
    ///   - offset: shadow offset (default is .zero).
    ///   - opacity: shadow opacity (default is 0.5).
    func db_addShadow(ofColor color: UIColor = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0), radius: CGFloat = 3, offset: CGSize = .zero, opacity: Float = 0.5) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
    
    /// SwifterSwift: Add array of subviews to view.
    ///
    /// - Parameter subviews: array of subviews to add to self.
    func db_addSubviews(_ subviews: [UIView]) {
        subviews.forEach({self.addSubview($0)})
    }
    
    /// SwifterSwift: Fade in view.
    ///
    /// - Parameters:
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil)
    func db_fadeIn(duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        if isHidden {
            isHidden = false
        }
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1
        }, completion: completion)
    }
    
    /// SwifterSwift: Fade out view.
    ///
    /// - Parameters:
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil)
    func db_fadeOut(duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        if isHidden {
            isHidden = false
        }
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }, completion: completion)
    }
    
    /// SwifterSwift: Load view from nib.
    ///
    /// - Parameters:
    ///   - name: nib name.
    ///   - bundle: bundle of nib (default is nil).
    /// - Returns: optional UIView (if applicable).
    class func db_loadFromNib(named name: String, bundle: Bundle? = nil) -> UIView? {
        return UINib(nibName: name, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
    
    /// SwifterSwift: Remove all subviews in view.
    func db_removeSubviews() {
        subviews.forEach({$0.removeFromSuperview()})
    }
    
    /// SwifterSwift: Remove all gesture recognizers from view.
    func db_removeGestureRecognizers() {
        gestureRecognizers?.forEach(removeGestureRecognizer)
    }
    
    /// SwifterSwift: Rotate view by angle on relative axis.
    ///
    /// - Parameters:
    ///   - angle: angle to rotate view by.
    ///   - type: type of the rotation angle.
    ///   - animated: set true to animate rotation (default is true).
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil).
    func db_rotate(byAngle angle: CGFloat, ofType type: DbAngleUnit, animated: Bool = false, duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        let angleWithType = (type == .degrees) ? CGFloat.pi * angle / 180.0 : angle
        let aDuration = animated ? duration : 0
        UIView.animate(withDuration: aDuration, delay: 0, options: .curveLinear, animations: { () -> Void in
            self.transform = self.transform.rotated(by: angleWithType)
        }, completion: completion)
    }
    
    /// SwifterSwift: Rotate view to angle on fixed axis.
    ///
    /// - Parameters:
    ///   - angle: angle to rotate view to.
    ///   - type: type of the rotation angle.
    ///   - animated: set true to animate rotation (default is false).
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil).
    func db_rotate(toAngle angle: CGFloat, ofType type: DbAngleUnit, animated: Bool = false, duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        let angleWithType = (type == .degrees) ? CGFloat.pi * angle / 180.0 : angle
        let aDuration = animated ? duration : 0
        UIView.animate(withDuration: aDuration, animations: {
            self.transform = self.transform.concatenating(CGAffineTransform(rotationAngle: angleWithType))
        }, completion: completion)
    }
    
    /// SwifterSwift: Scale view by offset.
    ///
    /// - Parameters:
    ///   - offset: scale offset
    ///   - animated: set true to animate scaling (default is false).
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil).
    func db_scale(by offset: CGPoint, animated: Bool = false, duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        if animated {
            UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: { () -> Void in
                self.transform = self.transform.scaledBy(x: offset.x, y: offset.y)
            }, completion: completion)
        } else {
            transform = transform.scaledBy(x: offset.x, y: offset.y)
            completion?(true)
        }
    }
    
    /// SwifterSwift: Shake view.
    ///
    /// - Parameters:
    ///   - direction: shake direction (horizontal or vertical), (default is .horizontal)
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - animationType: shake animation type (default is .easeOut).
    ///   - completion: optional completion handler to run with animation finishes (default is nil).
    func db_shake(direction: DbShakeDirection = .horizontal, duration: TimeInterval = 1, animationType: DbShakeAnimationType = .easeOut, completion:(() -> Void)? = nil) {
        
        CATransaction.begin()
        let animation: CAKeyframeAnimation
        switch direction {
        case .horizontal:
            animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        case .vertical:
            animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        }
        switch animationType {
        case .linear:
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        case .easeIn:
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        case .easeOut:
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        case .easeInOut:
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        }
        CATransaction.setCompletionBlock(completion)
        animation.duration = duration
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
        CATransaction.commit()
    }
}

/* Ex :
 sampleImageView.addTapGestureRecognizer {
    print("image tapped")
 }
 */

public extension UIView {
    
    // In order to create computed properties for extensions, we need a key to
    // store and access the stored property
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    // Set our computed property type to a closure
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    // This is the meat of the sauce, here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    func db_addTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Every time the user taps on the UIImageView, this function gets called,
    // which triggers the closure we stored
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?()
        } else {
            print("no action")
        }
    }
    
    enum UIShadowLocation: String {
        case none
        case bottom
        case top
        case left
        case right
    }
    
    func db_addShadow(withLocation location: UIShadowLocation, color: UIColor = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0), length: CGFloat = 10.0, radius: CGFloat = 3.0, opacity: Float = 0.5)
    {
        switch location {
        case .bottom:
            db_addShadow(ofColor: color, radius: radius, offset: CGSize(width: 0, height: length), opacity: opacity)
            break
        case .top:
            db_addShadow(ofColor: color, radius: radius, offset: CGSize(width: 0, height: -length), opacity: opacity)
            break
        case .left:
            db_addShadow(ofColor: color, radius: radius, offset: CGSize(width: length, height: 0), opacity: opacity)
            break
        case .right:
            db_addShadow(ofColor: color, radius: radius, offset: CGSize(width: -length, height: 0), opacity: opacity)
            break
        case .none:
            db_addShadow(ofColor: color, radius: radius, offset: .zero, opacity: opacity)
            break
        }
    }

    func db_isShow(duration: TimeInterval = 0.3, completion: ((Bool) -> Void)? = nil)
    {
        // -- Set for hidden --
        if isHidden == false {
           isHidden = true
        }
        
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        }, completion: { finished in
            self.isHidden = false
            completion?(finished)
        })
    }

    func db_isHidden(duration: TimeInterval = 0.3, removeFromSuperview: Bool = false, completion: ((Bool) -> Void)? = nil)
    {
        // -- Set for show --
        if isHidden == true {
            isHidden = false
        }

        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        }, completion: { finished in
            self.isHidden = true
            if removeFromSuperview {
                self.removeFromSuperview()
            }
            completion?(finished)
        })
    }

}

// MARK: - Anchor view to bottom, animation with keyboard (hide/show)

extension UIView {
    
    // In order to create computed properties for extensions, we need a key to
    // store and access the stored property
    fileprivate struct DbKeyboardHandlerParams {
        static var keyboardHandler = "UIView_keyboardHandler"
    }
    
    private var keyboardHandler: DbKeyboardHandler {
        get {
            var keyboardHandler = objc_getAssociatedObject(self, &DbKeyboardHandlerParams.keyboardHandler) as? DbKeyboardHandler
            if keyboardHandler == nil {
                keyboardHandler = DbKeyboardHandler()
                objc_setAssociatedObject(self, &DbKeyboardHandlerParams.keyboardHandler, keyboardHandler, .OBJC_ASSOCIATION_RETAIN)
            }
            return keyboardHandler!
        }
    }
    
    func db_anchorViewToBottomViewWithKeyboard() -> Void
    {
        // -- Khong hieu vi dau ma demo chay duoc, nhung khi ap dung vao project thi chay sai, mac du debug gia tri la dung --
        self.y = CGFloat(Db.screenHeight()) - self.height - DbUtils.safeAreaBottomPadding()
        
        // -- Co the define bien o day --
        //        var keyboardHandler = objc_getAssociatedObject(self, &DbKeyboardHandlerParams) as? DbKeyboardHandler
        //        if keyboardHandler == nil {
        //            keyboardHandler = DbKeyboardHandler()
        //            objc_setAssociatedObject(self, &DbKeyboardHandlerParams, keyboardHandler, .OBJC_ASSOCIATION_RETAIN)
        //        }
        
        keyboardHandler.listen { (keyboardInfo) in
            // print("keyboardInfo.keyboardFrame = \(String(describing: keyboardInfo.keyboardFrame))")
            // print("keyboardInfo.keyboardFrame = \(String(describing: keyboardInfo.status))")
            
            // -- Move view control --
            //var inputViewFrame: CGRect = self.viewButtonControl.frame
            if keyboardInfo.status == .KeyboardStatusWillShow {
                if self.tag == 0 {
                    self.y = keyboardInfo.keyboardFrame.origin.y - self.height
                    self.tag = 1010
                }
            } else if keyboardInfo.status == .KeyboardStatusWillHide {
                if self.tag == 1010 {
                    self.y = keyboardInfo.keyboardFrame.size.height + self.y - DbUtils.safeAreaBottomPadding()
                    self.tag = 0
                }
            }
            
        }
    }
}

extension UIView {
    
    // In order to create computed properties for extensions, we need a key to
    // store and access the stored property
    fileprivate struct PrivateHeightLayoutConstraintObjectKeys {
        static var heightConstraint = "HeightLayoutConstraintObjectKeys"
    }
    
    // Set our computed property type to a closure
    fileprivate var privateHeightLayoutConstraint: Int {
        get {
            return objc_getAssociatedObject(self, &PrivateHeightLayoutConstraintObjectKeys.heightConstraint) as? Int ?? 0
        }
        set {
            objc_setAssociatedObject(self, &PrivateHeightLayoutConstraintObjectKeys.heightConstraint, newValue as Int, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func db_getNSLayoutConstraint(layoutAttribute: NSLayoutAttribute) -> NSLayoutConstraint?
    {
        var returnConstraint: NSLayoutConstraint?
        
        for constraint: NSLayoutConstraint in self.constraints {
            if constraint.firstAttribute == layoutAttribute {
                returnConstraint = constraint
                break
            }
        }
        
        return returnConstraint
    }
    
    /*
     Note: Dung de hide/show UIView co NSLayoutConstraintHeight, chieu cao hien tai cua no se duoc save vao view.tag
     nen dung cach nay thi khong su dung view.tag
     - superView : co the truyen vao hay lay mac dinh la self.superview
     */
    
    func db_isHiddenWithHeightConstraint(hidden: Bool, animation: Bool = false, superView view: UIView? = nil)
    {
        // -- Dang cung trang thai thi khong can chay --
        if self.isHidden == hidden {
            return
        }
        
        guard let heightConstraint = self.db_getNSLayoutConstraint(layoutAttribute: .height) else {
            fatalError("Dont have heightConstraint")
        }
        
        var parentView = self.superview
        if view != nil {
            parentView = view
        }
        
        // print("heightConstraint.constant = \(String(describing: heightConstraint.constant))")
        
        if hidden { // Showing => hide
            self.privateHeightLayoutConstraint = Int(heightConstraint.constant)
            // self.tag = Int(heightConstraint.constant)
            heightConstraint.constant = 0
        } else {      // Hiding => Show
            heightConstraint.constant = CGFloat(self.privateHeightLayoutConstraint)
            self.privateHeightLayoutConstraint = 0
//            heightConstraint.constant = CGFloat(self.tag)
//            self.tag = 0
        }
        
        if animation {
            // -- Run animation update constraint --
            if !hidden {
                self.isHidden = false
            }
            
            self.alpha = hidden ? 1.0 : 0.0
            UIView.animate(withDuration: 0.3, animations: {
                //parentView?.superview?.layoutIfNeeded()
                parentView?.layoutIfNeeded()
                
                self.alpha = hidden ? 0.0 : 1.0
                
                
            }) { (finished) in
                if hidden {
                    self.isHidden = true
                }
            }
        } else {
            self.isHidden = hidden
        }

    }
    
}
