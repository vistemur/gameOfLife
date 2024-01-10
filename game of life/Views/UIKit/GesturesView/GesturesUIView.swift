import UIKit

class GesturesUIView: UIView {
    
    // MARK: - Public properties
    
    var touchEnded: ((CGPoint, CGRect) -> Void)?
    var touchMoved: ((CGPoint) -> Void)?
    var zoomed: ((CGFloat) -> Void)?
    
    // MARK: - Private properties
    
    private var startLocation = [UITouch: CGPoint]()
            
    private lazy var tapGesture: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer()
        return tapGesture
    }()
    
    var pinchGesture: UIPinchGestureRecognizer!
    
    // MARK: - Setup
    
    private func setup() {
        isUserInteractionEnabled = true
        isMultipleTouchEnabled = true
        tapGesture.delegate = self
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction(_:)))
        addGestureRecognizer(pinchGesture)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func pinchAction(_ gestureRecognizer: UIPinchGestureRecognizer) {
        zoomed?(gestureRecognizer.scale)
        gestureRecognizer.scale = 1
    }
}

// MARK: - GesturesUIView

extension GesturesUIView: UIGestureRecognizerDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            startLocation[touch] = touch.location(in: self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, touches.count == 1 else {
            return
        }
        
        let previousLocation = touch.previousLocation(in: self)
        let location = touch.location(in: self)
        let translation = CGPoint(x: location.x - previousLocation.x, y: location.y - previousLocation.y)
        touchMoved?(translation)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if startLocation[touch] == location {
                touchEnded?(location, bounds)
            }
            startLocation[touch] = nil
        }
    }
}
