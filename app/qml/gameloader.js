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

function killPiece(index)
{
    var piece = pieces[index]
    piece.visible = false
}

function unstackPiece(index, color)
{
    var stackedPiece = pieces[index]
    stackedPiece.imageSource = color === "red" ?
                "res/red-obelisk.png" : "res/grey-obelisk.png"
}

function loadGame(pieceLayout) {
    pieces.forEach(destroyPiece)
    pieces = []
    var packetSize = 5;
    for (var i = 0; i < pieceLayout.length; i+=packetSize)
    {
        makePiece([pieceLayout[i], pieceLayout[i+1], pieceLayout[i+2]],
                  pieceLayout[i+3], pieceLayout[i+4], i/packetSize)
    }
}

function destroyPiece(piece)
{
    piece.destroy()
}

function makePiece(piecePosition, type, color, index)
{
    var comp = Qt.createComponent("qrc:/Piece.qml")
    var image
    switch(type)
    {
    case PieceType.Pyramid:
        image = color === 0 ? "res/red-pyramid.png" : "res/grey-pyramid.png"
        break;
    case PieceType.Djed:
        image = color === 0 ? "res/red-djed.png" : "res/grey-djed.png"
        break;
    case PieceType.Obelisk:
        image = color === 0 ? "res/red-obelisk-stacked.png" : "res/grey-obelisk-stacked.png"
        break;
    case PieceType.Pharoah:
        image = color === 0 ? "res/red-pharoah.png" : "res/grey-pharoah.png"
        break;
    }
    if (comp.status === Component.Ready) {
        var piece = comp.createObject(board)
        piece.imageSource = image
        piece.xPos = piecePosition[0]
        piece.yPos = piecePosition[1]
        piece.angle = piecePosition[2]
        piece.index = index
        piece.board = board
        piece.gameManager = gameManager
        pieces.push(piece)
    }
    else if (comp.status === Component.Error) {
        console.log("error creating piece: ", comp.errorString())
    }
}
