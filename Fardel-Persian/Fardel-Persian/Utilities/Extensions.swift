//
//  Extensions.swift
//  Fardel-Persian
//
//  Created by MaHDi on 7/5/18.
//  Copyright © 2018 Mahdi. All rights reserved.
//

import UIKit

// Mark: Custom UIColor Extensions

extension UIColor {
    static func fromRgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}


// Mark: Custom UIView Extensions

extension UIView {
    func dropShadow() {
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        self.layer.shadowRadius = 5.0
        self.layer.shadowColor = UIColor.lightGray.cgColor
    }
    
    func setGradientBackground(topColor: UIColor,bottomColor: UIColor) {
        
        // TODO: Adding Gradient Layer to View.
        
        var topColor: UIColor = topColor {
            didSet{
                self.setNeedsLayout()
            }
        }
        var bottomColor: UIColor = bottomColor {
            didSet{
                self.setNeedsLayout()
            }
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor,bottomColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func anchorManual(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        // TODO: Adding constraints to view based on Auto-Layout
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

extension Date {
    
    func timeAgoSinceNow(useNumericDates: Bool = false) -> String {
        
        let calendar = Calendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let components = calendar.dateComponents(unitFlags, from: self, to: now)
        
        let formatter = DateComponentUnitFormatter()
        return formatter.string(forDateComponents: components, useNumericDates: useNumericDates)
    }
    
    func getTime(timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MMM d, yyyy"//yyyy-MM-dd HH:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
}

extension UISearchBar {
    func removeBackgroundImageView(){
        if let view:UIView = self.subviews.first {
            for curr in view.subviews {
                guard let searchBarBackgroundClass = NSClassFromString("UISearchBarBackground") else {
                    return
                }
                if curr.isKind(of:searchBarBackgroundClass){
                    if let imageView = curr as? UIImageView{
                        imageView.removeFromSuperview()
                        break
                    }
                }
            }
        }
    }
}
