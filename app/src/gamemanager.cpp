#include "gamemanager.h"

GameManager::GameManager(QObject *parent) : QObject(parent)
{

}

QList<int> GameManager::getPiecePositions() const
{
    QList<int> positions;
    std::array<Piece, 24> pieces = game.getPieces();
    for (auto& piece : pieces)
    {
        positions.append(piece.position().x);
        positions.append(piece.position().y);
    }
    return positions;
}

int GameManager::possibleTranslationsForPiece(int index)
{
    return game.possibleTranslationsForPiece(index);
}
