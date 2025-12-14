import SwiftUI

struct GameView: View {
    
    // model
    
    let initialField: Field
    let renderZone: FieldRenderer.RenderZone
    
    // private
    
    private let field = Field()
    private let renderer = FieldRenderer()
    private let timer = Lftimer(timeInterval: 0.1)
    
    var body: some View {
        
        ZStack {
            Canvas { context, size in
                renderer.render(field: field, context: &context, size: size)
            }
            GesturesView(touchEnded: nil)
            { translation in
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
        .onAppear { // setup data
            field.setupCopy(from: initialField)
            renderer.renderZone = renderZone.copy()
            timer.action = {
                field.getNextGeneration()
            }
            timer.start()
        }
        .onDisappear {
            timer.stop()
        }
    }
    
}

#Preview {
    let cells = [
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 1, 1, 1, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
    ]
    let field = Field()
    field.setup(cells: cells)
    return GameView(initialField: field, renderZone: FieldRenderer.RenderZone())
}
