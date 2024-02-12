import SwiftUI

struct FieldSetupView: View {
    
    private var field = Field()
    private var renderer = FieldRenderer()

    var body: some View {
        NavigationView {
            VStack {
        
                ZStack {
                    Canvas { context, size in
                        renderer.render(field: field, context: &context, size: size)
                    }
                    GesturesView { location, size in
                        let zoom = renderer.renderZone.zoom
                        let translation = renderer.renderZone.translation
                        let blockSize = size.width * zoom
                        
                        let translatedX = location.x - translation.x
                        let centralizedX = translatedX - size.width / 2
                        let x = centralizedX / blockSize
                        
                        let translatedY = location.y - translation.y
                        let centralizedY = translatedY - size.height / 2
                        let y = centralizedY / blockSize
                        
                        field.toggle(CGPointMake(x, y))
                    } touchMoved: { translation in
                        renderer.renderZone.translation = CGPoint(
                            x: renderer.renderZone.translation.x + translation.x,
                            y: renderer.renderZone.translation.y + translation.y
                        )
                    } zoomed: { zoom in
                        let newRenderZone = renderer.renderZone
                        newRenderZone.zoom *= zoom
                        newRenderZone.translation.y *= zoom
                        newRenderZone.translation.x *= zoom
                        renderer.renderZone = newRenderZone
                    }
                }

                NavigationLink(
                    destination: GameView(cells: field.cells, renderZone: renderer.renderZone)
                ) {
                    Text("start")
                }
                
            }
        }
    }
}

#Preview {
    FieldSetupView()
}
