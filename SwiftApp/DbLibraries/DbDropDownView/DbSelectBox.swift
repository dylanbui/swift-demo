//
//  DbSelectBox.swift
//  SearchTextField
//
//  Created by Dylan Bui on 10/29/18.
//  Copyright © 2018 Dylan Bui. All rights reserved.
//

import Foundation
import UIKit

class DbSelectBox: UIControl
{
    fileprivate var title: UILabel!
    fileprivate var arrow: DbSelectBoxArrow!
    public var dropDownView: DbDropDownView!
    
    public var placeholder: String! {
        didSet {
            title.text = placeholder
            title.adjustsFontSizeToFitWidth = true
        }
    }
    
    public var tint: UIColor? {
        didSet {
            title.textColor = textColor ?? tint
            arrow.backgroundColor = tint
        }
    }
    
    public var arrowPadding: CGFloat = 7.0 {
        didSet{
            let size = arrow.superview!.frame.size.width-(arrowPadding*2)
            arrow.frame = CGRect(x: arrowPadding, y: arrowPadding, width: size, height: size)
        }
    }
    
    // Text
    public var font: String? {
        didSet {
            title.font = UIFont(name: font!, size: fontSize)
        }
    }
    public var fontSize: CGFloat = 17.0 {
        didSet{
            title.font = title.font.withSize(fontSize)
        }
    }
    public var textColor: UIColor? {
        didSet{
            title.textColor = textColor
        }
    }
    public var textAlignment: NSTextAlignment? {
        didSet{
            title.textAlignment = textAlignment!
        }
    }
    
    // MARK: - Init
    
    // Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupDropDown()
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
        setupDropDown()
    }
    
    fileprivate func setup()
    {
        // -- Config title --
        
        title = UILabel(frame: CGRect(x: 0,
                                      y: 0,
                                      width: (self.frame.width-self.frame.height),
                                      height: self.frame.height))
        title.textAlignment = .center
        self.addSubview(title)
        
        let arrowContainer = UIView(frame: CGRect(x: title.frame.maxX,
                                                  y: 0,
                                                  width: title.frame.height,
                                                  height: title.frame.height))
        arrowContainer.isUserInteractionEnabled = false
        self.addSubview(arrowContainer)
        
        arrow = DbSelectBoxArrow(origin: CGPoint(x: arrowPadding, y: arrowPadding),
                                 size: arrowContainer.frame.width-(arrowPadding*2))
        arrow.backgroundColor = .black
        arrowContainer.addSubview(arrow)
        
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor?.cgColor
        self.addTarget(self, action: #selector(touch), for: .touchUpInside)
    }
    
    fileprivate func setupDropDown()
    {
        self.dropDownView = DbDropDownView(withAnchorView: self)
        self.dropDownView.hideOptionsWhenSelect = true
        // self.dropDownView.hideOptionsWhenTouchOut = true
        
        self.dropDownView.theme = .selectBoxTheme()
        self.dropDownView.tableYOffset = 5.0
        
        self.dropDownView.tableDoingAppear {
            self.arrow.position = .up
        }
        
        self.dropDownView.tableDoingDisappear {
            self.arrow.position = .down
        }
        
        self.dropDownView.tableDidDisappear {
            self.isSelected = false
            self.superview?.viewWithTag(5002)?.removeFromSuperview()
        }
    }
    
    @objc fileprivate func touch()
    {
        // -- Calculator Anchor view --
        var anchorFrame = self.frame
        anchorFrame.origin.y = self.frame.maxY
        anchorFrame.size.height = 0
        
        let anchorView = UIView(frame: anchorFrame)
        anchorView.tag = 5002
        anchorView.backgroundColor = UIColor.purple
        self.superview?.addSubview(anchorView)
        
        self.dropDownView.anchorView = anchorView
        
        isSelected = !isSelected
        isSelected ? self.dropDownView.showDropDown() : self.dropDownView.hideDropDown()
    }
    
    // MARK: - Class methods
    
    // Class methods
    public func resign() -> Bool
    {
        if isSelected {
            self.dropDownView.hideDropDown()
        }
        return true
    }
    
    public func didSelect(completion: @escaping (_ options: [DbDropDownViewItem], _ index: Int) -> ())
    {
        self.dropDownView.didSelect(completion: { (options, index) in
            self.title.text = options[index].title
            completion(options, index)
        })
    }
    
}

// MARK: - Extension
// MARK: -

extension DbDropDownViewTheme {
    
    public static func selectBoxTheme() -> DbDropDownViewTheme
    {
        var theme = DbDropDownViewTheme(cellHeight: 40,
                                        bgColor: UIColor (red: 0.8, green: 0.8, blue: 0.8, alpha: 0.4),
                                        borderColor: UIColor (red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0),
                                        separatorColor: UIColor.lightGray.withAlphaComponent(0.5),
                                        font: UIFont.boldSystemFont(ofSize: 13), fontColor: UIColor.gray)
        
        theme.bgCellColor = .white //UIColor (red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        theme.subtitleFont = UIFont.italicSystemFont(ofSize: 10)
        theme.subtitleFontColor = UIColor.brown
        theme.checkmarkColor = UIColor.blue // User checkmark
        return theme
    }
    
}


// Arrow
enum DbSelectBoxArrowPosition
{
    case left
    case down
    case right
    case up
}

class DbSelectBoxArrow: UIView
{
    
    var position: DbSelectBoxArrowPosition = .down {
        didSet{
            switch position {
            case .left:
                self.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
                break
                
            case .down:
                self.transform = CGAffineTransform(rotationAngle: CGFloat.pi*2)
                break
                
            case .right:
                self.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
                break
                
            case .up:
                self.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                break
            }
        }
    }
    
    init(origin: CGPoint, size: CGFloat) {
        super.init(frame: CGRect(x: origin.x, y: origin.y, width: size, height: size))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        // Get size
        let size = self.layer.frame.width
        
        // Create path
        let bezierPath = UIBezierPath()
        
        // Draw points
        let qSize = size/4
        
        bezierPath.move(to: CGPoint(x: 0, y: qSize))
        bezierPath.addLine(to: CGPoint(x: size, y: qSize))
        bezierPath.addLine(to: CGPoint(x: size/2, y: qSize*3))
        bezierPath.addLine(to: CGPoint(x: 0, y: qSize))
        bezierPath.close()
        
        // Mask to path
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        self.layer.mask = shapeLayer
    }
}
