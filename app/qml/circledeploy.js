var Position = {
    "TopLeft": 1,
    "Top": 2,
    "TopRight": 4,
    "Left": 8,
    "Right": 16,
    "BottomLeft": 32,
    "Bottom": 64,
    "BottomRight": 128
}

var circles = [];
var piece;

function init(parent)
{
    piece = parent;
}

function retract() {
    circles.forEach(retractCircle)
}

function retractCircle(circle)
{
    circle.state = "retracted"
}

function deploy(positions)
{
    if (positions & Position.TopLeft)
    {
        deployCircle().state = "deployTopLeft"
    }
    if (positions & Position.Top)
    {
        deployCircle().state = "deployTop"
    }
    if (positions & Position.TopRight)
    {
        deployCircle().state = "deployTopRight"
    }
    if (positions & Position.Left)
    {
        deployCircle().state = "deployLeft"
    }
    if (positions & Position.Right)
    {
        deployCircle().state = "deployRight"
    }
    if (positions & Position.BottomLeft)
    {
        deployCircle().state = "deployBottomLeft"
    }
    if (positions & Position.Bottom)
    {
        deployCircle().state = "deployBottom"
    }
    if (positions & Position.BottomRight)
    {
        deployCircle().state = "deployBottomRight"
    }
}

function deployCircle()
{
    var comp = Qt.createComponent("qrc:/MoveCircle.qml");
    if (comp.status === Component.Ready) {
        var circle = comp.createObject(piece)
        circle.piece = piece
        circles.push(circle)
        return circle;
    }
    else if (comp.status === Component.Error) {
        console.log("error creating circle: ", comp.errorString())
    }
    return 0;
}
