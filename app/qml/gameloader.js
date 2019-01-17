var pieces = [];
var board;
var gameManager;
var PieceType = {
    "Pyramid": 0,
    "Djed": 1,
    "Obelisk": 2,
    "Pharoah": 3
}

function init(parent, manager)
{
    board = parent
    gameManager = manager
}

function getPiece(index)
{
    return pieces[index]
}

function loadGame(pieceLayout) {
    var packetSize = 4;
    for (var i = 0; i < pieceLayout.length; i+=packetSize)
    {
        switch(pieceLayout[i+3])
        {
        case PieceType.Pyramid:
            makePyramid([pieceLayout[i], pieceLayout[i+1], pieceLayout[i+2]], i/packetSize)
            break;
        case PieceType.Djed:
            makeDjed([pieceLayout[i], pieceLayout[i+1], pieceLayout[i+2]], i/packetSize)
            break;
        }


    }
}

function makePyramid(piecePosition, index)
{
    var comp = Qt.createComponent("qrc:/Pyramid.qml");
    if (comp.status === Component.Ready) {
        var pyramid = comp.createObject(board)
        pyramid.xPos = piecePosition[0]
        pyramid.yPos = piecePosition[1]
        pyramid.angle = piecePosition[2]
        pyramid.index = index
        pyramid.gameManager = gameManager
        pieces.push(pyramid)
    }
    else if (comp.status === Component.Error) {
        console.log("error creating piece: ", comp.errorString())
    }
}

function makeDjed(piecePosition, index)
{
    var comp = Qt.createComponent("qrc:/Djed.qml");
    if (comp.status === Component.Ready) {
        var djed = comp.createObject(board)
        djed.xPos = piecePosition[0]
        djed.yPos = piecePosition[1]
        djed.angle = piecePosition[2]
        djed.index = index
        djed.gameManager = gameManager
        djed.board = board
        pieces.push(djed)
    }
    else if (comp.status === Component.Error) {
        console.log("error creating piece: ", comp.errorString())
    }
}
