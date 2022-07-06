import Network

struct NetworkConnectionManager {
    static let shared = NetworkConnectionManager()
    let monitor = NWPathMonitor()
    var isCurrentlyConnected: Bool {
        return monitor.currentPath.status == .satisfied
    }
    
    private init() { }
    
    func startMonitoring() {
        monitor.start(queue: DispatchQueue.global())
    }
}
