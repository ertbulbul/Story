import UIKit
extension UIView {
    
    /// This function allows us to anchor a view with using the top, the left, the right and the bottom anchor.
    
    func anchorToTop(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil) {
        
        anchorWithConstantsToTop(top, left: left, bottom: bottom, right: right, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        
    }
    
    func anchorWithConstantsToTop(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0) {
        
        _ = anchor(top, left: left, bottom: bottom, right: right, topConstant: topConstant, leftConstant: leftConstant, bottomConstant: bottomConstant, rightConstant: rightConstant)
        
    }
    
    /// This is the main anchoring function. It allows us to position a view.
    
    func anchor(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
            
        }
        
        if let left = left {
            
            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
            
        }
        
        if let bottom = bottom {
            
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
            
        }
        
        if let right = right {
            
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
            
        }
        
        if widthConstant > 0 {
            
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
            
        }
        
        if heightConstant > 0 {
            
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
            
        }
        
        anchors.forEach({$0.isActive = true})
        
        return anchors
        
    }
    
    /// It shakes the view. It can be used in wrong password action.
    
    func shakeIt() {
        
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        animation.duration = 0.6
        
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        
        layer.add(animation, forKey: "shake")
        
    }
    
    /// This function adds shadow to a card.
    
    func addCardShadow(color:UIColor = UIColor.white) {
        
        layer.cornerRadius = 5
        
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 2)
        
        layer.masksToBounds = false
        
        layer.shadowColor = UIColor.darkGray.cgColor
        
        layer.shadowOffset = CGSize(width: 0, height: 2)
        
        layer.shadowOpacity = 0.3
        
        layer.shadowPath = shadowPath.cgPath
        
        layer.backgroundColor = color.cgColor
        
    }
    
    /// This function adds shadow to a view.
    
    func addShadow(color:UIColor = UIColor.darkGray) {
        
        layer.shadowColor = color.cgColor
        
        layer.shadowOpacity = 0.3
        
        layer.shadowOffset = CGSize(width: 0, height: 2)
        
        layer.shadowRadius = 2
        
    }
    
    /// This function creates rounded corners.
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        let mask = CAShapeLayer()
        
        mask.path = path.cgPath
        
        self.layer.mask = mask
        
    }
    
    /// This function starts rotating for a view.
    
    func startRotate() {
        
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        
        rotation.fromValue = 0
        
        rotation.toValue = NSNumber(value: Double.pi * 2)
        
        rotation.duration = 2
        
        rotation.isCumulative = true
        
        rotation.repeatCount = Float.greatestFiniteMagnitude
        
        self.layer.add(rotation, forKey: "rotationAnimation")
        
    }
    
    /// This function stops rotating
    
    func stopRotate() {
        
        self.layer.removeAnimation(forKey: "rotationAnimation")
        
    }
    
 
    
    /// This function clears the gradient.
    
    func clearGradient() {
        for sublayer in layer.sublayers! where sublayer is CAGradientLayer { sublayer.removeFromSuperlayer() }
    }
    func round(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    
}
extension UISlider{
    func setValue(_ value:Int, animated: Bool){
        self.setValue(Float(value), animated: animated)
    }
}
