//
//  AttributedString.swift
//
//  Created by mac-cyy on 2021/12/1.
//

import UIKit

/*
 demo1
 let name = "name"
 let attribute: AttributedString = """
   Hi \(name, .color(.red), .font(UIFont.systemFont(ofSize: 22))),
   isn't this \("cool", .color(.blue), .oblique, .underline(.purple, .single))?
   \(image: UIImage.init(named: "wallet_card_cash_icon"), offset: 10, size: .init(width: 40, height: 40))

   \(wrap: """
     \(" XXXX Xmas! ", .font(.systemFont(ofSize: 36)), .color(.red), .bgColor(.yellow))
     \(image: UIImage.init(named: "wallet_card_cash_icon"), offset: 100, size: .init(width: 200, height: 200))
     """)

   test link \("target link",
   .link("https://developer.apple.com/news/?id=12172014b"), .underline(.blue, .single))!
   """
 
 
 demo2
 let attribute: AttributedString = "Hello \(name, .color(.red), .font(UIFont.systemFont(ofSize: 22)), .paragraph(.center, 10)), \(image: UIImage.init(named: "wallet_card_cash_icon"), offset: 0, size: .init(width: 40, height: 40))"
*/

struct AttributedString {
    let attributedString: NSAttributedString
}

extension AttributedString: CustomStringConvertible {
  var description: String {
    return String(describing: self.attributedString)
  }
}

extension AttributedString: ExpressibleByStringLiteral {
    init(stringLiteral: String) {
        self.attributedString = NSAttributedString(string: stringLiteral)
    }
}

extension AttributedString: ExpressibleByStringInterpolation {
    init(stringInterpolation: StringInterpolation) {
        self.attributedString = NSAttributedString(attributedString: stringInterpolation.attributedString)
    }

    struct StringInterpolation: StringInterpolationProtocol {
        var attributedString: NSMutableAttributedString

        init(literalCapacity: Int, interpolationCount: Int) {
            self.attributedString = NSMutableAttributedString()
        }

        func appendLiteral(_ literal: String) {
            let astr = NSAttributedString(string: literal)
            self.attributedString.append(astr)
        }

        func appendInterpolation(_ string: String, attributes: [NSAttributedString.Key: Any]) {
            let astr = NSAttributedString(string: string, attributes: attributes)
            self.attributedString.append(astr)
        }
    }
}

extension AttributedString.StringInterpolation {
    func appendInterpolation(_ string: String, _ style: AttributedString.Style) {
        let astr = NSAttributedString(string: string, attributes: style.attributes)
        self.attributedString.append(astr)
    }
    
    func appendInterpolation(_ string: String, _ style: AttributedString.Style...) {
        var attrs: [NSAttributedString.Key: Any] = [:]
        style.forEach { attrs.merge($0.attributes, uniquingKeysWith: {$1}) }
        let astr = NSAttributedString(string: string, attributes: attrs)
        self.attributedString.append(astr)
    }
    
    func appendInterpolation(wrap string: AttributedString, _ style: AttributedString.Style...) {
        var attrs: [NSAttributedString.Key: Any] = [:]
        style.forEach { attrs.merge($0.attributes, uniquingKeysWith: {$1}) }
        let mas = NSMutableAttributedString(attributedString: string.attributedString)
        let fullRange = NSRange(mas.string.startIndex..<mas.string.endIndex, in: mas.string)
        mas.addAttributes(attrs, range: fullRange)
        self.attributedString.append(mas)
     }
    
    /// 添加图片
    func appendInterpolation(image: UIImage?, offset: CGFloat = 0, size: CGSize? = nil) {
        guard let image = image else { return }
        let attachment = NSTextAttachment()
        attachment.image = image
        let s = size ?? image.size
        attachment.bounds = CGRect(x: 0, y: offset, width: s.width, height: s.height)
        self.attributedString.append(NSAttributedString(attachment: attachment))
    }
}

// MARK: - Style extension
extension AttributedString {
    struct Style {
        let attributes: [NSAttributedString.Key: Any]
        static let oblique = Style(attributes: [.obliqueness: 0.1])
        
        static func font(_ font: UIFont) -> Style {
            return Style(attributes: [.font: font])
        }
        
        static func color(_ color: UIColor) -> Style {
            return Style(attributes: [.foregroundColor: color])
        }
          
        static func bgColor(_ color: UIColor) -> Style {
            return Style(attributes: [.backgroundColor: color])
        }
          
        static func link(_ link: String) -> Style {
            return .link(URL(string: link)!)
        }
          
        static func link(_ link: URL) -> Style {
            return Style(attributes: [.link: link])
        }
        
        /// 字符间距
        static func kern(_ value: CGFloat) -> Style {
            return Style(attributes: [.kern: value])
        }
        
        ///设置字体倾斜度，取值为float，正值右倾，负值左倾
        static func oblique(_ value: CGFloat = 0.1) -> Style {
            return Style(attributes: [.obliqueness: value])
        }
        
        /// 设置字体的横向拉伸，取值为float，正值拉伸 ，负值压缩
        static func expansion(_ value: CGFloat) -> Style {
            return Style(attributes: [.expansion: value])
        }
        
        /// 设置下划线
        static func underline(_ color: UIColor,
                              _ style: NSUnderlineStyle) -> Style {
            return Style(attributes: [
                .underlineColor: color,
                .underlineStyle: style.rawValue
            ])
        }
        
        /// 设置删除线
        static func strikethrough(_ style: NSUnderlineStyle = .single,
                                  _ color: UIColor = UIColor.lightGray) -> Style {
            return Style(attributes: [
                .strikethroughColor: color,
                .strikethroughStyle: style.rawValue
            ])
        }
        
        /// 设置描边
        static func stroke(_ color: UIColor,
                           _ value: CGFloat = 0) -> Style {
            return Style(attributes: [
                .strokeColor: color,
                .strokeWidth: value
            ])
        }
        
        /// 设置基准位置 (正上负下)
        func baseline(_ value: CGFloat) -> Style {
            return Style(attributes: [
                .baselineOffset: value
            ])
        }
        
        /// 设置段落
        static func paragraph(_ alignment: NSTextAlignment = .center,
                              _ lineSpacing: CGFloat = 0.0,
                              _ paragraphSpacingBefore: CGFloat = 0,
                              _ lineBreakMode: NSLineBreakMode = .byWordWrapping) -> Style {
            let ps = NSMutableParagraphStyle()
            ps.alignment = alignment
            ps.lineBreakMode = lineBreakMode
            ps.lineSpacing = lineSpacing
            ps.paragraphSpacingBefore = paragraphSpacingBefore
            return Style(attributes: [.paragraphStyle: ps])
        }
        
        /// 设置段落
        static func paragraphStyle(_ style: NSMutableParagraphStyle) -> Style {
            return Style(attributes: [.paragraphStyle: style])
        }
    }
}



