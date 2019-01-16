var pieces = [];
var board;
var gameManager;

function init(parent, manager)
{
    board = parent
    gameManager = manager
}

function loadGame(pieceLayout) {
    for (var i = 0; i < pieceLayout.length; i+=3)
    {
        makePiece([pieceLayout[i], pieceLayout[i+1], pieceLayout[i+2]], i/3)
    }
}

function makePiece(piecePosition, index)
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
