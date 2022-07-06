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
        guard let appIconImage = Content.appIconImage else {
            return LPLinkMetadata()
        }
        
        let metaData = LPLinkMetadata()
        metaData.title = title
        metaData.iconProvider = NSItemProvider(object: appIconImage)
        metaData.originalURL = URL(fileURLWithPath: content)
        
        return metaData
    }
}

// MARK: - Namespaces
extension SharePinNumberActivityItemSource {
    private enum Content {
        static let appIconImage = UIImage(named: "appIconOrangeRect")
    }
}
