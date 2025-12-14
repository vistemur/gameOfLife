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
        
        drawEmptyCells(context: &context, size: size, blockSize: blockSize, borderWidth: borderWidth)
        drawField(field: field, context: &context, size: size, blockSize: blockSize, borderWidth: borderWidth)
    }
    
    private func drawEmptyCells(context: inout GraphicsContext, size: CGSize, blockSize: CGFloat, borderWidth: CGFloat) {
        let startLocation: CGPoint = CGPoint(x: size.width / 2 - blockSize / 2 + renderZone.translation.x,
                                             y: size.height / 2 - blockSize / 2 + renderZone.translation.y)
        
        var y = startLocation.y
        while y < size.height {
            var x = startLocation.x
            while x < size.width {
                let rect = CGRect(origin: CGPointMake(x + borderWidth / 2,
                                                      y + borderWidth / 2),
                                  size: CGSizeMake(blockSize - borderWidth, blockSize - borderWidth))
                context.fill(Path(rect), with: .color(.empty))
                x += blockSize
            }
            
            x = startLocation.x
            while x >  -blockSize {
                let rect = CGRect(origin: CGPointMake(x + borderWidth / 2,
                                                      y + borderWidth / 2),
                                  size: CGSizeMake(blockSize - borderWidth, blockSize - borderWidth))
                context.fill(Path(rect), with: .color(.empty))
                x -= blockSize
            }
            
            y += blockSize
        }
        
        y = startLocation.y
        while y > -blockSize {
            var x = startLocation.x
            while x < size.width {
                let rect = CGRect(origin: CGPointMake(x + borderWidth / 2,
                                                      y + borderWidth / 2),
                                  size: CGSizeMake(blockSize - borderWidth, blockSize - borderWidth))
                context.fill(Path(rect), with: .color(.empty))
                x += blockSize
            }
            
            x = startLocation.x
            while x > -blockSize {
                let rect = CGRect(origin: CGPointMake(x + borderWidth / 2,
                                                      y + borderWidth / 2),
                                  size: CGSizeMake(blockSize - borderWidth, blockSize - borderWidth))
                context.fill(Path(rect), with: .color(.empty))
                x -= blockSize
            }
            
            y -= blockSize
        }
    }
    
    private func drawField(field: Field, context: inout GraphicsContext, size: CGSize, blockSize: CGFloat, borderWidth: CGFloat) {
        for zone in field.zones.values {
            renderZone(zone: zone, context: &context, blockSize: blockSize, size: size, borderWidth: borderWidth)
        }
    }
    
    private func renderZone(zone: Field.Zone, context: inout GraphicsContext, blockSize: CGFloat, size: CGSize, borderWidth: CGFloat) {
        let zoneSize: CGFloat = CGFloat(Field.Zone.size) * blockSize
        let startLocation: CGPoint = CGPoint(x: size.width / 2 - zoneSize / 2 + CGFloat(zone.coordinates.x) * zoneSize + renderZone.translation.x,
                                             y: size.height / 2 - zoneSize / 2 + CGFloat(zone.coordinates.y) * zoneSize + renderZone.translation.y)
        
        for row in 0 ..< Field.Zone.size {
            for column in 0 ..< Field.Zone.size {
                let rect = CGRect(origin: CGPointMake(startLocation.x + CGFloat(column) * blockSize + borderWidth / 2,
                                                      startLocation.y + CGFloat(row) * blockSize + borderWidth / 2),
                                  size: CGSizeMake(blockSize - borderWidth, blockSize - borderWidth))
                if zone.cells[row][column] == 1 {
                    context.fill(Path(rect), with: .color(.selected))
                } else {
                    context.fill(Path(rect), with: .color(.empty))
                }
            }
        }
        
        let outlineRect = CGRect(origin: CGPointMake(startLocation.x,
                                                 startLocation.y),
                             size: CGSizeMake(blockSize * CGFloat(Field.Zone.size), blockSize * CGFloat(Field.Zone.size)))
        var outlinePath = Path()
        outlinePath.addRect(outlineRect)
        context.stroke(outlinePath, with: .color(.green), lineWidth: 3)
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
        
        func copy() -> RenderZone {
            RenderZone(translation: translation, zoom: zoom)
        }
    }
}

private extension Color {
    static let selected = Color.blue
    static let empty = Color.brown
    static let border = Color.black
}
