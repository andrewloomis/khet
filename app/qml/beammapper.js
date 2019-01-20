.import "coordcalculator.js" as CoordCalculator
.import QtQuick 2.0 as QtQuick

var board
var beamParts = []
var spaceDistance = 97

function init(parent)
{
    board = parent
}

function createBeam(coords)
{
    for (var i = 0; i < coords.length; i+=3)
    {
        var comp = Qt.createComponent("qrc:/LaserBeam.qml");
        if (comp.status === QtQuick.Component.Ready) {
            var beamPart = comp.createObject(board)

            beamPart.anchors.left = board.left
            beamPart.anchors.top = board.top
            if (i == 0)
            {
                console.log("creating beam from 9,7 to", coords[i], ",", coords[i+1],
                            "hitting", coords[i+2] === 0 ? "wall" : "a piece")
                CoordCalculator.beamPartCoords(9,7, coords[i], coords[i+1], coords[i+2])
            }
            else
            {
                console.log("creating beam from", coords[i-3], ",", coords[i-2],"to",
                            coords[i], ",", coords[i+1], ",", "hitting", (coords[i+2] === 0 ? "wall" : "a piece"))
                CoordCalculator.beamPartCoords(coords[i-3], coords[i-2], coords[i], coords[i+1], coords[i+2])
            }
            beamPart.width = CoordCalculator.getBeamWidth()
            beamPart.height = CoordCalculator.getBeamHeight()
            beamPart.anchors.leftMargin = CoordCalculator.getBeamLeftMargin()
            beamPart.anchors.topMargin = CoordCalculator.getBeamTopMargin()
            beamParts.push(beamPart)
        }
        else if (comp.status === Component.Error) {
            console.log("error creating beamPart: ", comp.errorString())
        }
    }
    CoordCalculator.resetBeamDirection()
}


function destroyBeam()
{
    beamParts.forEach(destroyPart)
    beamParts = []
}

function destroyPart(part)
{
    part.destroy()
}
