import UIKit

extension UIFont {
    enum Family {
        case thin, extraLight, light, regular, medium, semiBold, bold, extraBold, black
        
        var kind: String {
            switch self {
            case .thin:
                return "Thin"
            case .extraLight:
                return "ExtraLight"
            case .light:
                return "Light"
            case .regular:
                return "Regular"
            case .medium:
                return "Medium"
            case .semiBold:
                return "SemiBold"
            case .bold:
                return "Bold"
            case .extraBold:
                return "ExtraBold"
            case .black:
                return "Black"
            }
        }
        
        var defaultSize: CGFloat {
            switch self {
            case .thin:
                return 10
            case .extraLight:
                return 10
            case .light:
                return 10
            case .regular:
                return 10
            case .medium:
                return 12
            case .semiBold:
                return 20
            case .bold:
                return 30
            case .extraBold:
                return 35
            case .black:
                return 40
            }
        }
    }
    
    // TODO: 종류별로 Font size를 정해서 기본값 지정해도 될듯
    static func pretendard(family: Family = .medium, size: CGFloat = 12) -> UIFont {
        return UIFont(name: "Pretendard-\(family.kind)", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func pretendardDefaultSize(family: Family = .medium) -> UIFont {
        return UIFont(name: "Pretendard-\(family.kind)", size: family.defaultSize) ?? UIFont.systemFont(ofSize: family.defaultSize)
    }
    
    // 큰글씨 : 가는체, 볼드or 엑스트라볼드
    // 작은글씨 (일반) : 중간체, 볼드
}
