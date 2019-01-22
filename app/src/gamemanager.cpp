#include "gamemanager.h"

GameManager::GameManager(QObject *parent)
    : QObject(parent), game(true)
{

}

void GameManager::findOnlinePlayers()
{

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

int GameManager::getPieceColor(int index) const
{
    return game.getPieceColor(static_cast<std::size_t>(index)) == Color::Red ? 0 : 1;
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
}

void GameManager::updatePieceAngle(int index, int angle)
{
    game.updatePieceAngle(static_cast<std::size_t>(index),angle);
}

QList<int> GameManager::getBeamCoords()
{
    return game.calculateBeamCoords();
}
