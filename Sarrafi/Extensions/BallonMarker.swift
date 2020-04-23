//
//  BallonMarker.swift
//  Sarrafi
//
//  Created by armin on 4/23/20.
//  Copyright © 2020 shalchian. All rights reserved.
//

import Charts
import UIKit

open class BalloonMarker: MarkerImage {
    @objc open var color: UIColor
    @objc open var arrowSize = CGSize(width: 15, height: 11)
    @objc open var font: UIFont
    @objc open var textColor: UIColor
    @objc open var insets: UIEdgeInsets
    @objc open var minimumSize = CGSize()
    
    @objc open var priceType: String
    @objc open var date: [String]
    
    fileprivate var labelPrice: String?
    fileprivate var labelDate: String?
    fileprivate var _labelSize: CGSize = CGSize()
    fileprivate var _paragraphStyle: NSMutableParagraphStyle?
    fileprivate var _drawAttributes = [NSAttributedString.Key : Any]()
    
    @objc public init(date: [String], priceType: String, color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets) {
        self.date = date
        self.priceType = priceType
        self.color = color
        self.font = font
        self.textColor = textColor
        self.insets = insets
        
        _paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        _paragraphStyle?.alignment = .center
        super.init()
    }
    
    open override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint {
        var offset = self.offset
        var size = self.size

        if size.width == 0.0 && image != nil {
            size.width = image!.size.width
        }
        if size.height == 0.0 && image != nil {
            size.height = image!.size.height
        }

        let width = size.width
        let height = size.height
        let padding: CGFloat = 8.0

        var origin = point
        origin.x -= width / 2
        origin.y -= height

        if origin.x + offset.x < 0.0 {
            offset.x = -origin.x + padding
        } else if let chart = chartView, origin.x + width + offset.x > chart.bounds.size.width {
            offset.x = chart.bounds.size.width - origin.x - width - padding
        }

        if origin.y + offset.y < 0 {
            offset.y = height + padding;
        } else if let chart = chartView, origin.y + height + offset.y > chart.bounds.size.height {
            offset.y = chart.bounds.size.height - origin.y - height - padding
        }

        return offset
    }
    
    open override func draw(context: CGContext, point: CGPoint) {
        guard let labelPrice = labelPrice else { return }
        guard let labelDate = labelDate else { return }
        
        let offset = self.offsetForDrawing(atPoint: point)
        let size = self.size
        
        var rect = CGRect( origin: CGPoint( x: point.x + offset.x, y: point.y + offset.y), size: size)
        rect.origin.x -= size.width / 2.0
        rect.origin.y -= size.height
        
        context.saveGState()
        
        context.setFillColor(color.cgColor)
        
        if offset.y > 0 {
            
            context.beginPath()
            let rect2 = CGRect(x: rect.origin.x, y: rect.origin.y + arrowSize.height, width: rect.size.width, height: rect.size.height - arrowSize.height)
            let clipPath = UIBezierPath(roundedRect: rect2, cornerRadius: 5.0).cgPath
            context.addPath(clipPath)
            context.closePath()
            context.fillPath()
            
            // arraow vertex
            context.beginPath()
            let p1 = CGPoint(x: rect.origin.x + rect.size.width / 2.0 - arrowSize.width / 2.0, y: rect.origin.y + arrowSize.height + 1)
            context.move(to: p1)
            context.addLine(to: CGPoint(x: p1.x + arrowSize.width, y: p1.y))
            context.addLine(to: CGPoint(x: point.x, y: point.y))
            context.addLine(to: p1)

            context.fillPath()
            
        } else {
            context.beginPath()
            let rect2 = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: rect.size.height - arrowSize.height)
            let clipPath = UIBezierPath(roundedRect: rect2, cornerRadius: 5.0).cgPath
            context.addPath(clipPath)
            context.closePath()
            context.fillPath()

            // arraow vertex
            context.beginPath()
            let p1 = CGPoint(x: rect.origin.x + rect.size.width / 2.0 - arrowSize.width / 2.0, y: rect.origin.y + rect.size.height - arrowSize.height - 1)
            context.move(to: p1)
            context.addLine(to: CGPoint(x: p1.x + arrowSize.width, y: p1.y))
            context.addLine(to: CGPoint(x: point.x, y: point.y))
            context.addLine(to: p1)

            context.fillPath()
        }
        
        if offset.y > 0 {
            rect.origin.y += self.insets.top + arrowSize.height
        } else {
            rect.origin.y += self.insets.top
        }
        
        rect.size.height -= self.insets.top + self.insets.bottom
        
        UIGraphicsPushContext(context)
        
        let labelPriceRect = CGRect(x: rect.minX, y: rect.minY - 5, width: rect.width, height: rect.height)
        let labelDateRect = CGRect(x: rect.minX, y: labelPriceRect.maxY, width: rect.width, height: rect.height)
        
        labelPrice.draw(in: labelPriceRect, withAttributes: _drawAttributes)
        labelDate.draw(in: labelDateRect, withAttributes: _drawAttributes)
        
        UIGraphicsPopContext()
        
        context.restoreGState()
    }
    
    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        let yValue = "\(entry.y) \(priceType)"
        let xValue = "تاریخ \(date[Int(entry.x)])"
        setPriceLabel(yValue)
        setDateLabel(xValue)
    }
    
    @objc open func setPriceLabel(_ newLabel: String) {
        labelPrice = newLabel
        
        _drawAttributes.removeAll()
        _drawAttributes[.font] = self.font
        _drawAttributes[.paragraphStyle] = _paragraphStyle
        _drawAttributes[.foregroundColor] = self.textColor
        
        _labelSize = labelPrice?.size(withAttributes: _drawAttributes) ?? CGSize.zero
        
        var size = CGSize()
        size.width = _labelSize.width + self.insets.left + self.insets.right
        size.height = _labelSize.height + self.insets.top + self.insets.bottom
        size.width = max(minimumSize.width, size.width)
        size.height = max(minimumSize.height, size.height)
        self.size = size
    }
    
    @objc open func setDateLabel(_ newLabel: String) {
        labelDate = newLabel
        
        _drawAttributes.removeAll()
        _drawAttributes[.font] = self.font
        _drawAttributes[.paragraphStyle] = _paragraphStyle
        _drawAttributes[.foregroundColor] = self.textColor
        
        _labelSize = labelDate?.size(withAttributes: _drawAttributes) ?? CGSize.zero
        
        var size = CGSize()
        size.width = _labelSize.width + self.insets.left + self.insets.right
        size.height = _labelSize.height + self.insets.top + self.insets.bottom
        size.width = max(minimumSize.width, size.width)
        size.height = max(minimumSize.height, size.height)
        self.size = size
    }
}
