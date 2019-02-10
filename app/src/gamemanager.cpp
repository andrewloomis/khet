#include "gamemanager.h"

GameManager::GameManager(QObject *parent)
    : QObject(parent)
{
    connect(&game, &Game::pieceKilled, this, &GameManager::pieceKilledInGame);
    connect(&game, &Game::pharoahKilled, this, &GameManager::pharoahKilled);
    connect(&game, &Game::unstackPiece, this, &GameManager::unstackPiece);
}

void GameManager::addNetworkManager(std::shared_ptr<NetworkManager> nm)
{
    network = nm;
    connect(network.get(), &NetworkManager::gameRequestApproved,
            this, &GameManager::multiplayerGameStart);
    connect(network.get(), &NetworkManager::inviteAccepted,
            this, &GameManager::multiplayerGameStart);
    connect(network.get(), &NetworkManager::setColorReceived,
            this, &GameManager::setPlayerColor);
    connect(network.get(), &NetworkManager::opponentMoved,
            this, &GameManager::moveOpponentPiece);
    connect(network.get(), &NetworkManager::endGameReceived,
            this, &GameManager::endGameReceived);
}

void GameManager::reset()
{
    moveComplete = false;
    movedPieceIndex = -1;
    gameMode = "sandbox";
    game.reset();
}

void GameManager::endGameReceived(QString winner)
{
    emit endGame(winner);
}

void GameManager::pharoahKilled(int index)
{
    QString winner = game.getPieceColor(static_cast<size_t>(index)) ==
            Color::Red ? "grey" : "red";
    emit endGame(winner);
    // Only one player can send game over request
    if (me->pieceColor() == game.getPieceColor(static_cast<size_t>(index))
            && gameMode != "sandbox")
    {
        QJsonObject data;
        data["user"] = me->getUsername();
        data["opponent"] = opponent.getUsername();
        data["winner"] = winner;
        network->sendRequest(NetworkManager::Request::GameOver, data);
    }
}

void GameManager::setPlayerColor(QString color)
{
    qDebug() << "Setting player color to" << color;
    me->setColor(color == "red" ? Color::Red : Color::Grey);
    emit myColorChanged();
}

void GameManager::moveOpponentPiece(int index, int angle, int xPos, int yPos)
{
    if (gameMode != "sandbox")
    {
        emit opponentPieceMoved(index, angle, xPos, yPos);
        game.nextTurn();
        qDebug() << (game.currentPlayerTurn() == Color::Red ? "Red" : "Grey")
                 << "player turn";
    }
}

void GameManager::moveFinished()
{
    if (isPlayerTurn())
    {
        moveComplete = true;
    }
}

void GameManager::turnFinished()
{
    if (isPlayerTurn() && moveComplete && gameMode != "sandbox")
    {
        QJsonObject data;
        data["user"] = me->getUsername();
        data["piece_index"] = movedPieceIndex;
        data["piece_angle"] = game.getPieceAngle(static_cast<size_t>(movedPieceIndex));
        Position pos = game.getPiecePosition(static_cast<size_t>(movedPieceIndex));
        data["x_pos"] = pos.x;
        data["y_pos"] = pos.y;

        network->sendRequest(NetworkManager::Request::TurnComplete, data);
        moveComplete = false;
        emit myTurnFinished();
    }

    game.nextTurn();
    qDebug() << (game.currentPlayerTurn() == Color::Red ? "Red" : "Grey")
             << "player turn";
}

void GameManager::pieceKilledInGame(int index)
{
    QString type;
    switch (game.getPieceType(static_cast<size_t>(index)))
    {
    case PieceType::Pyramid:
        type = "pyramid";
        break;
    case PieceType::Obelisk:
        type = "obelisk";
        break;
    case PieceType::Djed:
        type = "djed";
        break;
    case PieceType::Pharoah:
        type = "pharoah";
        break;
    }
    emit pieceKilled(index, type, getPieceColor(index));
}

void GameManager::multiplayerGameStart(QString opponentName)
{
    gameMode = "multiplayer";
    opponent.setUsername(opponentName);
    emit modeChanged();
}

QList<int> GameManager::getPiecePositions() const
{
    QList<int> positions;
    const auto& pieces = game.getPieces();
    for (const auto& piece : pieces)
    {
        positions.append(piece->position().x);
        positions.append(piece->position().y);
        positions.append(piece->angle());
        positions.append(static_cast<int>(piece->type()));
        positions.append(static_cast<int>(piece->color()));
    }
    return positions;
}

QString GameManager::getPieceColor(int index) const
{
    return game.getPieceColor(static_cast<std::size_t>(index)) == Color::Red ? "red" : "grey";
}

int GameManager::isPieceAtPosition(int x, int y) const
{
    const auto& pieces = game.getPieces();
    for (const auto& piece : pieces)
    {
        if (piece->position().x == x && piece->position().y == y) return piece->index();
    }
    return -1;
}

int GameManager::possibleTranslationsForPiece(int index)
{
    return game.possibleTranslationsForPiece(static_cast<std::size_t>(index));
}

void GameManager::updatePiecePosition(int index, int x, int y)
{
    game.updatePiecePosition(static_cast<std::size_t>(index),x,y);
    movedPieceIndex = index;
    moveFinished();
}

void GameManager::updatePieceAngle(int index, int angle)
{
    game.updatePieceAngle(static_cast<std::size_t>(index),angle);
    movedPieceIndex = index;
    moveFinished();
}

QList<int> GameManager::getBeamCoords(int startX, int startY)
{
    return game.calculateBeamCoords(startX, startY);
}
