struct Coordinates: Hashable {
    let x: Int
    let y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    static func == (lhs: Coordinates, rhs: Coordinates) -> Bool {
        lhs.x == rhs.x &&
        lhs.y == rhs.y
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
    
    func getZone() -> (zone: Coordinates, inside: Coordinates) {
        let halfFieldSize = Field.Zone.size / 2
        let xCordTranslated = x > 0 ? x + halfFieldSize : x - halfFieldSize
        let yCordTranslated = y > 0 ? y + halfFieldSize : y - halfFieldSize
        let xZone = xCordTranslated / Field.Zone.size
        let yZone = yCordTranslated / Field.Zone.size
        
        let xZoneCor = x - xZone * Field.Zone.size
        let yZoneCor = y - yZone * Field.Zone.size
        let xZoneCell = xZoneCor + Field.Zone.size / 2
        let yZoneCell = yZoneCor + Field.Zone.size / 2
        
        return (Coordinates(x: xZone, y: yZone), Coordinates(x: xZoneCell, y: yZoneCell))
    }
    
    static func global(zone: Coordinates, inside: Coordinates) -> Coordinates {
        let zoneStartX = zone.x * Field.Zone.size - Field.Zone.size / 2
        let zoneStartY = zone.y * Field.Zone.size - Field.Zone.size / 2
        let global = Coordinates(x: zoneStartX + inside.x, y: zoneStartY + inside.y)
        return global
    }
}
