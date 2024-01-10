import SwiftUI

@Observable class FieldRenderer {
    
    var renderZone: RenderZone
    
    init(renderZone: RenderZone = RenderZone()) {
        self.renderZone = renderZone
    }
    
    func render(field: Field, context: inout GraphicsContext, size: CGSize) {
        let blockSize = size.width * renderZone.zoom
        let borderWidth = blockSize / 20.0
        
        context.fill(Path(CGRect(origin: .zero, size: size)),
                     with: .color(.border))
        
        fillFieldArea(field: field, context: &context, blockSize: blockSize, size: size, borderWidth: borderWidth)
    }
    
    private func fillFieldArea(field: Field, context: inout GraphicsContext, blockSize: CGFloat, size: CGSize, borderWidth: CGFloat) {
        let firstBlockY = size.height / 2 - blockSize * CGFloat(field.height / 2) + renderZone.translation.y
        let firstBlockX = size.width / 2 - blockSize * CGFloat(field.width / 2) + renderZone.translation.x
        
        let startY = firstBlockY.remainder(dividingBy: blockSize) - blockSize
        let startX = firstBlockX.remainder(dividingBy: blockSize) - blockSize
        
        guard fieldIsOnScreen(field: field, firstBlockY: firstBlockY, firstBlockX: firstBlockX, blockSize: blockSize, size: size) else {
            drawBlocks(startY: startY, endY: size.height, startX: startX, endX: size.width, context: &context, blockSize: blockSize, borderWidth: borderWidth)
            return
        }
        
         drawBlocks(startY: startY, endY: firstBlockY, startX: startX, endX: size.width, context: &context, blockSize: blockSize, borderWidth: borderWidth)
        
        var currentY = firstBlockY
        for y in 0 ..< field.height {
            drawBlocksRow(startX: startX, endX: firstBlockX, y: currentY, context: &context, blockSize: blockSize, borderWidth: borderWidth)
            var currentX = firstBlockX
            for x in 0 ..< field.width {
                
                if currentY + blockSize > 0
                    && currentX + blockSize > 0
                    && currentY < size.height
                    && currentX < size.width {
                    let origin = CGPointMake(currentX + borderWidth / 2, currentY + borderWidth / 2)
                    let rect = CGRect(origin: origin,
                                      size: CGSizeMake(blockSize - borderWidth, blockSize - borderWidth))
                    context.fill(Path(rect),
                                 with: field.cells[y][x] == 0 ? .color(.empty) : .color(.selected))
                }
                
                currentX += blockSize
            }
            
            drawBlocksRow(startX: currentX, endX: size.width, y: currentY, context: &context, blockSize: blockSize, borderWidth: borderWidth)
            currentY += blockSize
        }

        drawBlocks(startY: currentY, endY: size.height, startX: startX, endX: size.width, context: &context, blockSize: blockSize, borderWidth: borderWidth)
    }
    
    private func fieldIsOnScreen(field: Field, firstBlockY: CGFloat, firstBlockX: CGFloat, blockSize: CGFloat, size: CGSize) -> Bool {
        if firstBlockX < 0
            && firstBlockX + blockSize * CGFloat(field.width) < 0 {
            return false
        }
        
        if firstBlockY < 0
            && firstBlockY + blockSize * CGFloat(field.height) < 0 {
            return false
        }
        
        if firstBlockX > size.width {
            return false
        }
        
        if firstBlockY > size.height {
            return false
        }
        
        return true
    }
    
    private func drawBlocks(startY: CGFloat, endY: CGFloat, startX: CGFloat, endX: CGFloat, context: inout GraphicsContext, blockSize: CGFloat, borderWidth: CGFloat) {
        guard startY < endY else {
            return
        }
        
        var currentY = startY
        while currentY < endY {
            drawBlocksRow(startX: startX, endX: endX, y: currentY, context: &context, blockSize: blockSize, borderWidth: borderWidth)
            currentY += blockSize
        }
    }
    
    private func drawBlocksRow(startX: CGFloat, endX: CGFloat, y: CGFloat, context: inout GraphicsContext, blockSize: CGFloat, borderWidth: CGFloat) {
        guard startX < endX else {
            return
        }
        
        var currentX = startX
        while currentX < endX {
            
            let rect = CGRect(origin: CGPointMake(currentX + borderWidth / 2, y + borderWidth / 2),
                              size: CGSizeMake(blockSize - borderWidth, blockSize - borderWidth))
            context.fill(Path(rect), with: .color(.red))
            
            currentX += blockSize
        }
    }
    
    @Observable class RenderZone {
        var translation: CGPoint
        var zoom: CGFloat
        
        init(translation: CGPoint = CGPoint(x: 0.0, y: 0.0), zoom: CGFloat = 1.0 / 8.0) {
            self.translation = translation
            self.zoom = zoom
        }
    }
}

private extension Color {
    static let selected = Color.blue
    static let empty = Color.brown
    static let border = Color.black
}
