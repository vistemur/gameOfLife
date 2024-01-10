import SwiftUI

struct GesturesView: UIViewRepresentable {
    
    var touchEnded: ((CGPoint, CGRect) -> Void)?
    var touchMoved: ((CGPoint) -> Void)?
    var zoomed: ((CGFloat) -> Void)?
    
    func makeUIView(context: Context) -> GesturesUIView {
        let view = GesturesUIView()
        view.touchEnded = touchEnded
        view.touchMoved = touchMoved
        view.zoomed = zoomed
        return view
    }
    
    func updateUIView(_ uiView: GesturesUIView, context: Context) {
    }
    
}
