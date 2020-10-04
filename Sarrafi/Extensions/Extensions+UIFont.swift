import Foundation
import UIKit

extension UIFont {
	
	static func shabnam(ofSize size: CGFloat, weight: Weight = .regular) -> UIFont {
		switch weight {
		case .black, .bold, .heavy:
			return UIFont(name: "Shabnam-Bold-FD", size: size)!
		case .medium, .semibold:
			return UIFont(name: "Shabnam-Medium-FD", size: size)!
		case .regular:
			return UIFont(name: "Shabnam-FD", size: size)!
		case .light:
			return UIFont(name: "Shabnam-Light-FD", size: size)!
		case .thin, .ultraLight:
			return UIFont(name: "Shabnam-This-FD", size: size)!
		default:
			return UIFont(name: "Shabnam-FD", size: size)!
		}
	}
	
}
