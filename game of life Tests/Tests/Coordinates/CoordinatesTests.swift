import XCTest
@testable import game_of_life

final class CoordinatesTests: XCTestCase {

    func testFromGlobalToZoneZero() {
        Field.Zone.size = 3
        let global = Coordinates(x: 0, y: 0)

        let coordinates = global.getZone()
        XCTAssert(coordinates.zone.x == 0 && coordinates.zone.y == 0, "zone not correct")
        XCTAssert(coordinates.inside.x == 1 && coordinates.inside.y == 1, "inside not correct")
    }
    
    func testFromGlobalToZoneOne() {
        Field.Zone.size = 3
        let global = Coordinates(x: 3, y: 3)
        
        let coordinates = global.getZone()
        XCTAssert(coordinates.zone.x == 1 && coordinates.zone.y == 1, "zone not correct")
        XCTAssert(coordinates.inside.x == 1 && coordinates.inside.y == 1, "inside not correct")
    }
    
    func testFromGlobalToZoneMinus() {
        Field.Zone.size = 3
        let global = Coordinates(x: -4, y: -2)
        
        let coordinates = global.getZone()
        XCTAssert(coordinates.zone.x == -1 && coordinates.zone.y == -1, "zone not correct")
        XCTAssert(coordinates.inside.x == 0 && coordinates.inside.y == 2, "inside not correct")
    }
    
    func testFromZoneToGlobalZero() {
        let zone = Coordinates(x: 0, y: 0)
        let inside = Coordinates(x: 1, y: 1)
        
        let coordinates = Coordinates.global(zone: zone, inside: inside)
        XCTAssert(coordinates.x == 0 && coordinates.y == 0, "global not correct")
    }
    
    func testFromZoneToGlobalOne() {
        let zone = Coordinates(x: 1, y: 1)
        let inside = Coordinates(x: 0, y: 0)
        
        let coordinates = Coordinates.global(zone: zone, inside: inside)
        XCTAssert(coordinates.x == 2 && coordinates.y == 2, "global not correct")
    }
    
    func testFromZoneToGlobalMinus() {
        let zone = Coordinates(x: -1, y: 0)
        let inside = Coordinates(x: 1, y: 0)
        
        let coordinates = Coordinates.global(zone: zone, inside: inside)
        XCTAssert(coordinates.x == -3 && coordinates.y == -1, "global not correct")
    }
}
