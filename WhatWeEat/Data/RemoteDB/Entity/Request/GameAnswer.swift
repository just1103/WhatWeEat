import Foundation

struct GameAnswer {
    let hangover: Bool?
    let greasy: Bool?
    let health: Bool?
    let alchol: Bool?
    let instant: Bool?
    let spicy: Bool?
    let rich: Bool?
    let rice: Bool?
    let noodle: Bool?
    let soup: Bool?
//    let notRiceNoodleSoup: String  // 기타 버튼 (ex. 치킨 등 notRiceNoodleSoup 밥/면/국 미해당 메뉴)을 탭하면 rice, noodle, soup 모두 false 처리
    let nation: [Nation]
}

enum Nation: String {
    case korean = "KOREAN"
    case western = "WESTERN"
    case japanese = "JAPANESE"
    case chinese = "CHINESE"
    case convenient = "CONVENIENT"
    case exotic = "EXOTIC"
    case etc = "ETC"  // ex. 샐러드
}
