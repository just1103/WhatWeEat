import LinkPresentation
import UIKit

final class SharePinNumberActivityItemSource: NSObject, UIActivityItemSource {
    private var title: String
    private var content: String
    
    init(title: String, content: String) {
        self.title = title
        self.content = content
        super.init()
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return content
    }
    
    func activityViewController(
        _ activityViewController: UIActivityViewController,
        itemForActivityType activityType: UIActivity.ActivityType?
    ) -> Any? {
        return content
    }
    
    func activityViewController(
        _ activityViewController: UIActivityViewController,
        subjectForActivityType activityType: UIActivity.ActivityType?
    ) -> String {
        return title
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metaData = LPLinkMetadata()
        guard let appIconImage = Content.appIconImage else {  // TODO: 디자인 작업 후 앱 로고로 변경
            return LPLinkMetadata()
        }
        metaData.title = title
        metaData.iconProvider = NSItemProvider(object: appIconImage)
        metaData.originalURL = URL(fileURLWithPath: content)
        return metaData
    }
}

// MARK: - Namespaces
extension SharePinNumberActivityItemSource {
    private enum Content {
        static let appIconImage = UIImage(named: "appIconWhite")
    }
}
