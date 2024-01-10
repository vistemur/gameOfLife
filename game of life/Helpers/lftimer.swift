import Foundation

class Lftimer {
    
    private var timer: Timer?
    private let timeInterval: TimeInterval
    var action: (() -> Void)?
    
    init(timeInterval: TimeInterval = 1, action: (() -> Void)? = nil) {
        self.timeInterval = timeInterval
        self.action = action
    }
    
    @discardableResult
    func start() -> Self {
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { [weak self] _ in
            self?.timerAction()
        }
        return self
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    private func timerAction() {
        action?()
        stop()
        start()
    }
    
    deinit {
        stop()
    }
    
}
