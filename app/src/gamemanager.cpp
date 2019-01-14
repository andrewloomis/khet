#include "gamemanager.h"

GameManager::GameManager(QObject *parent) : QObject(parent)
{

}

QList<int> GameManager::getPiecePositions() const
{
    QList<int> positions;
    std::array<Piece, 2> pieces = game.getPieces();
    for (auto& piece : pieces)
    {
        positions.append(piece.position().x);
        positions.append(piece.position().y);
    }
    return positions;
}

int GameManager::possibleTranslationsForPiece(int index)
{
    return game.possibleTranslationsForPiece(static_cast<std::size_t>(index));
}

void GameManager::updatePiecePosition(int index, int x, int y, int angle)
{
    game.updatePiecePosition(static_cast<std::size_t>(index),x,y,angle);
}

QList<int> GameManager::getBeamCoords() const
{
    return game.calculateBeamCoords();
}
