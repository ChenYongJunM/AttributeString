# AttributeString
ExpressibleByStringInterpolation AttributeString
基于swift5.0字符串字面量协议包装的attributestring

 `
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
 `
