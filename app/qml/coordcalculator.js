var spaceDistance = 97/2
var boardWallWidth = 73/2

var beamDia = 10/2
var beamWidth = 0
var beamHeight = 0
var beamLeftMargin = 0
var beamTopMargin = 0
var isBeamVertical = true

function pieceLeftAnchor(xPos) {
    return boardWallWidth + xPos*spaceDistance
}

function pieceTopAnchor(yPos) {
    return boardWallWidth + yPos*spaceDistance
}

function isDirectionPositive(coordInitial, coordFinal)
{
    return coordFinal > coordInitial
}

function beamPartCoords(x1, y1, x2, y2, termination)
{
    if (isBeamVertical)
    {
        beamWidth = beamDia
        // Piece on edge reflects beam vertical, hitting wall
        if (y1 === y2 && termination === 0)
        {
            beamHeight = spaceDistance/2
            if (y1 === 0) beamTopMargin = boardWallWidth
            else beamTopMargin = boardWallWidth + y1*spaceDistance + spaceDistance/2
            beamLeftMargin = boardWallWidth + x1*spaceDistance + (spaceDistance - beamWidth)/2
        }
        else
        {
            // Hits wall
            if (termination === 0)
            {
                beamHeight = Math.abs(y2 - y1)*spaceDistance + spaceDistance/2
                beamTopMargin = isDirectionPositive(y1, y2) ? (boardWallWidth + y1*spaceDistance + spaceDistance/2) :
                                                              (boardWallWidth + y2*spaceDistance)
            }
            // Hits piece
            else
            {
                beamHeight = Math.abs(y2 - y1)*spaceDistance
                beamTopMargin = isDirectionPositive(y1, y2) ? (boardWallWidth + y1*spaceDistance + spaceDistance/2) :
                                                              (boardWallWidth + y2*spaceDistance + spaceDistance/2)
            }
            if((x1 === 9 && y1 === 7) || (x1 === 0 && y1 === 0)) beamHeight += spaceDistance/2
            if (x1 === 0 && y1 === 0) beamTopMargin -= spaceDistance/2
            beamLeftMargin = boardWallWidth + x1*spaceDistance + (spaceDistance - beamWidth)/2
        }
    }
    else
    {
        beamHeight = beamDia
        // Piece on edge reflects beam vertical, hitting wall
        if (x1 === x2 && termination === 0)
        {
            beamWidth = spaceDistance/2
            if (x1 === 0) beamLeftMargin = boardWallWidth
            else beamLeftMargin = boardWallWidth + x1*spaceDistance + spaceDistance/2
            beamTopMargin = boardWallWidth + y1*spaceDistance + (spaceDistance - beamHeight)/2
        }
        else
        {
            // Hits wall
            if (termination === 0)
            {
                beamWidth = Math.abs(x2 - x1)*spaceDistance + spaceDistance/2
                beamLeftMargin = isDirectionPositive(x1, x2) ? (boardWallWidth + x1*spaceDistance + spaceDistance/2) :
                                                              (boardWallWidth + x2*spaceDistance)
            }
            // Hits piece
            else
            {
                beamWidth = Math.abs(x2 - x1)*spaceDistance
                beamLeftMargin = isDirectionPositive(x1, x2) ? (boardWallWidth + x1*spaceDistance + spaceDistance/2) :
                                                              (boardWallWidth + x2*spaceDistance + spaceDistance/2)
            }
            beamTopMargin = boardWallWidth + y1*spaceDistance + (spaceDistance - beamHeight)/2
        }
    }
    isBeamVertical = !isBeamVertical;
}

function resetBeamDirection()
{
    isBeamVertical = true;
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
