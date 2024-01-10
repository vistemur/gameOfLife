//
//  GameView.swift
//  game of life
//
//  Created by Roman Pozdnyakov on 18.12.2023.
//

import SwiftUI

struct GameView: View {
    
    var field: Field
    let renderer = FieldRenderer()
    let timer: Lftimer
    
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
    }
    
}

#Preview {
    GameView(field: Field(), timer: Lftimer())
}
