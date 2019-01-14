var spaceDistance = 97
var boardWallWidth = 73

var beamWidth = 0
var beamHeight = 0
var beamLeftMargin = 0
var beamTopMargin = 0
var isBeamVertical

function pieceLeftAnchor(xPos) {
    return boardWallWidth + xPos*spaceDistance
}

function pieceTopAnchor(yPos) {
    return boardWallWidth + yPos*spaceDistance
}

function beamPartCoords(x1, y1, x2, y2, termination)
{
    if (x1 === x2)
    {
        isBeamVertical = true
        beamWidth = 10
        // Hits wall
        if (termination === 0)
        {
            beamHeight = Math.abs(y2 - y1)*spaceDistance + spaceDistance/2
            beamTopMargin = boardWallWidth
        }
        // Hits piece
        else
        {
            beamHeight = Math.abs(y2 - y1)*spaceDistance
            beamTopMargin = boardWallWidth + y2*spaceDistance + spaceDistance/2
        }
        if(x1 === 9 && y1 === 7) beamHeight += spaceDistance/2
        beamLeftMargin = boardWallWidth + x1*spaceDistance + (spaceDistance - beamWidth)/2
    }
    else
    {
        isBeamVertical = false
        beamHeight = 10
        // Hits wall
        if (termination === 0)
        {
            beamWidth = Math.abs(x2 - x1)*spaceDistance + spaceDistance/2
            beamLeftMargin = boardWallWidth
        }
        // Hits piece
        else
        {
            beamWidth = Math.abs(x2 - x1)*spaceDistance
            beamLeftMargin = boardWallWidth + x2*spaceDistance + spaceDistance/2
        }
        beamTopMargin = boardWallWidth + y1*spaceDistance + (spaceDistance - beamHeight)/2
    }
}

function getBeamHeight()
{
    return beamHeight
}

function getBeamWidth()
{
    return beamWidth
}

function getBeamLeftMargin() {
    return beamLeftMargin
}

function getBeamTopMargin() {
    return beamTopMargin
}
