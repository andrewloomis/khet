#include "gamemanager.h"

GameManager::GameManager(QObject *parent) : QObject(parent)
{

}

QList<int> GameManager::getPiecePositions() const
{
    QList<int> positions;
    std::vector<std::shared_ptr<Piece>> pieces = game.getPieces();
    for (auto& piece : pieces)
    {
        positions.append(piece->position().x);
        positions.append(piece->position().y);
        positions.append(piece->angle());
    }
    return positions;
}

int GameManager::possibleTranslationsForPiece(int index)
{
    return game.possibleTranslationsForPiece(static_cast<std::size_t>(index));
}

void GameManager::updatePiecePosition(int index, int x, int y)
{
    game.updatePiecePosition(static_cast<std::size_t>(index),x,y);
}

void GameManager::updatePieceAngle(int index, int angle)
{
    game.updatePieceAngle(static_cast<std::size_t>(index),angle);
}

QList<int> GameManager::getBeamCoords() const
{
    return game.calculateBeamCoords();
}
