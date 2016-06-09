//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

typealias Position = CGPoint
typealias Distance = CGFloat


let minimumDistance: Distance = 2.0
func inRange(enemyPostion: Position, ownPosition: Position, friendlyDistance: Position, distance: Distance) -> Bool {
    let dx = enemyPostion.x - ownPosition.x
    let dy = enemyPostion.y - ownPosition.y
    let friendlyDx = friendlyDistance.x - ownPosition.x
    let friendlyDy = friendlyDistance.y - ownPosition.y
    
    let friendlyDistance = sqrt(friendlyDx * friendlyDx + friendlyDy * friendlyDy)
    let enemyDistance = sqrt(dx * dx + dy*dy)
    return  enemyDistance <= distance && enemyDistance >= minimumDistance && friendlyDistance >= minimumDistance
}


//Refactoring

typealias Region = Position -> Bool


// returns a region function that determins if a point is in a region
// Takes a parameter of distance
func circle(radius: Distance) -> Region {
    return {p in sqrt(p.x * p.x + p.y * p.y) <= radius}
}

// returns a region function that gets the shifted point in question
// This returns a point that given a funciton that is given a particular result of a position
// It should get an offset and get if its still in the region
func shift(offset: Position, region: Region) -> Region {
    return { point in
        let shiftedPoint = Position(x: offset.x + point.x, y: offset.y + point.y)
        return region(shiftedPoint)
    }
}


// returns a region function that is no in the given region
func invert(region: Region) -> Region {
    return {
        point in !region(point)
    }
}


// To find the intersection between two points
func intersection(firstRegion: Region, secondRegion: Region) -> Region {
    return { point in firstRegion(point) && secondRegion(point) }
}

// To find the intersection between two points
func union(firstRegion: Region, secondRegion: Region) -> Region {
    return { point in firstRegion(point) || secondRegion(point) }
}


// finding the difference in regions

func difference(region: Region, minusRegion: Region ) -> Region {
    return intersection(region, secondRegion: invert(minusRegion))
}

// Refactoring the first funciton

func inRangeOne(enemyPostion: Position, ownPosition: Position, friendlyDistance: Position, distance: Distance) -> Bool{
    
    let rangeRegion = difference(circle(distance), minusRegion: circle(minimumDistance))
    let targetRegion = shift(ownPosition, region: rangeRegion)
    let friendlyRegion = shift(friendlyDistance, region: circle(minimumDistance))
    let resultRegion = difference(targetRegion, minusRegion: friendlyRegion)
    return resultRegion(enemyPostion)
    }