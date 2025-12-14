import SwiftUI

protocol FieldProtocol {
    func setup(cells: [[Int]])
    func toggle(_ location: CGPoint)
    func getNextGeneration()
    func copy() -> Field
}

@Observable class Field {
        
    var zones: [Coordinates: Zone]
    
    init() {
        self.zones = [:]
    }
    
    private init(zones: [Coordinates : Zone]) {
        self.zones = zones
    }

    @Observable class Zone: Hashable {
        
        static var size = 3
        
        var coordinates: Coordinates
        var cells: [[Int]]
        var swapCells: [[Int]]
        
        init() {
            coordinates = Coordinates(x: 0, y: 0)
            cells = Array(repeating: Array(repeating: 0, count: Zone.size), count: Zone.size)
            swapCells = Array(repeating: Array(repeating: 0, count: Zone.size), count: Zone.size)
        }
        
        convenience init(coordinates: Coordinates) {
            self.init()
            self.coordinates = coordinates
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(coordinates)
        }
        
        static func == (lhs: Field.Zone, rhs: Field.Zone) -> Bool {
            lhs.coordinates == rhs.coordinates
        }
    }
    
    func getZone(x: Int, y: Int) -> Zone? {
        zones[Coordinates(x: x, y: y)]
    }
}

extension Field: FieldProtocol {
    
    func setup(cells: [[Int]]) {
        let height = cells.count
        let width = cells.first?.count ?? 0
        let centerY = height / 2
        let centerX = width / 2
        
        for y in 0 ..< height {
            for x in 0 ..< width {
                let translatedY = y - centerY
                let translatedX = x - centerX
                if cells[y][x] == 1 {
                    toggleAt(x: translatedX, y: translatedY)
                }
            }
        }
    }
    
    func toggle(_ location: CGPoint) {
        let xCord = Int(location.x.rounded())
        let yCord = Int(location.y.rounded())
        toggleAt(x: xCord, y: yCord)
    }
    
    private func toggleAt(x: Int, y: Int) {
        let (zoneCoordinates, inside) = Coordinates(x: x, y: y).getZone()
        
        if let zone = zones[zoneCoordinates] {
            if zone.cells[inside.y][inside.x] == 1 {
                zone.cells[inside.y][inside.x] = 0
            } else {
                zone.cells[inside.y][inside.x] = 1
            }
        } else {
            // add zone
            let zone = Zone(coordinates: zoneCoordinates)
            zone.cells[inside.y][inside.x] = 1
            zones[zoneCoordinates] = zone
        }
    }
    
    func getNextGeneration() {
        // min 1 neighbor
        
        var additionalCellsToCount = Set<Coordinates>()
        var zonesToDelete = Set<Coordinates>()
        
        for (coordinates, zone) in zones {
            var zoneCellsCount = 0
            
            for y in 0 ..< Field.Zone.size {
                for x in 0 ..< Field.Zone.size {
                    let globalCoordinates = Coordinates.global(zone: coordinates, inside: Coordinates(x: x, y: y))
                    let neighborsCount = countNeghborsFor(coordinates: globalCoordinates)
                    
                    if zone.cells[y][x] == 1 {
                        switch neighborsCount {
                        case let n where n < 2:
                            zone.swapCells[y][x] = 0
                        case let n where n > 3:
                            zone.swapCells[y][x] = 0
                        default:
                            zone.swapCells[y][x] = 1
                            zoneCellsCount += 1
                        }
                    } else {
                        if neighborsCount == 3 {
                            zone.swapCells[y][x] = 1
                            zoneCellsCount += 1
                        } else {
                            zone.swapCells[y][x] = 0
                        }
                    }
                    
                    if zone.cells[y][x] == 1 {
                        // if on the edge without neigbor zone -> check neighbor cells (that has this cell as neighbor)
                        
                        // up
                        if y == 0 {
                            for x in globalCoordinates.x - 1 ... globalCoordinates.x + 1 {
                                additionalCellsToCount.insert(Coordinates(x: x, y: globalCoordinates.y - 1))
                            }
                        }
                        
                        // down
                        if y == Field.Zone.size - 1 {
                            for x in globalCoordinates.x - 1 ... globalCoordinates.x + 1 {
                                additionalCellsToCount.insert(Coordinates(x: x, y: globalCoordinates.y + 1))
                            }
                        }
                        
                        // left
                        if x == 0 {
                            for y in globalCoordinates.y - 1 ... globalCoordinates.y + 1 {
                                additionalCellsToCount.insert(Coordinates(x: globalCoordinates.x - 1, y: y))
                            }
                        }
                        
                        // right
                        if x == Field.Zone.size - 1 {
                            for y in globalCoordinates.y - 1 ... globalCoordinates.y + 1 {
                                additionalCellsToCount.insert(Coordinates(x: globalCoordinates.x + 1, y: y))
                            }
                        }
                    }
                }
            }
            
            if zoneCellsCount == 0 {
                zonesToDelete.insert(coordinates)
            }
        }
                
        for additionalCell in additionalCellsToCount {
            let neighborsCount = countNeghborsFor(coordinates: additionalCell)
            
            if neighborsCount == 3 {
                let (zoneCoordinates, inside) = additionalCell.getZone()
                if let zone = zones[zoneCoordinates] {
                    zone.swapCells[inside.y][inside.x] = 1
                } else {
                    let zone = Zone(coordinates: zoneCoordinates)
                    zone.swapCells[inside.y][inside.x] = 1
                    zones[zoneCoordinates] = zone
                }
            }
        }
        
        for coordinates in zonesToDelete {
            zones[coordinates] = nil
        }
        
        for (_, zone) in zones {
            zone.cells = zone.swapCells
        }
    }
    
    private func countNeghborsFor(coordinates: Coordinates) -> Int {
        var count = 0
        
        for neighborY in coordinates.y - 1 ... coordinates.y + 1 {
            for neighborX in coordinates.x - 1 ... coordinates.x + 1 {
                
                if neighborY == coordinates.y && neighborX == coordinates.x {
                    continue
                }
                
                count += valueAt(coordinates: Coordinates(x: neighborX, y: neighborY))
            }
        }
        
        return count
    }
    
    private func valueAt(coordinates: Coordinates) -> Int {
        let (zoneCoordinates, inside) = coordinates.getZone()
        
        guard let zone = zones[zoneCoordinates] else {
            return 0
        }

        return zone.cells[inside.y][inside.x]
    }
    
    func copy() -> Field {
        let newField = Field()
        var newZones: [Coordinates: Zone] = [:]
        zones.forEach { key, value in
            let zone = Zone(coordinates: key)
            zone.cells = value.cells.map { $0.map { $0 } }
            zone.swapCells = value.swapCells.map { $0.map { $0 } }
            newZones[key] = zone
        }
        newField.zones = newZones
        return newField
    }
    
    func setupCopy(from: Field) {
        var newZones: [Coordinates: Zone] = [:]
        from.zones.forEach { key, value in
            let zone = Zone(coordinates: key)
            zone.cells = value.cells.map { $0.map { $0 } }
            zone.swapCells = value.swapCells.map { $0.map { $0 } }
            newZones[key] = zone
        }
        zones = newZones
    }
}

extension Field: CustomStringConvertible {
    
    var description: String {
        return "zones = \(zones.count)"
    }
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
