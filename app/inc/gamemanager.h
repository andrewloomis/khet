#ifndef GAMEMANAGER_H
#define GAMEMANAGER_H

#include <QObject>
#include <QPoint>
#include <QList>
#include <khetlib/game.h>
#include <khetlib/player.h>

class GameManager : public QObject
{
    Q_OBJECT
public:
    explicit GameManager(QObject *parent = nullptr);
    Q_INVOKABLE QList<int> getPiecePositions() const;
    Q_INVOKABLE int isPieceAtPosition(int x, int y) const;
    Q_INVOKABLE int possibleTranslationsForPiece(int index);
    Q_INVOKABLE void updatePiecePosition(int index, int x, int y);
    Q_INVOKABLE void updatePieceAngle(int index, int angle);
    Q_INVOKABLE QList<int> getBeamCoords();
    Q_INVOKABLE bool isPlayerTurn() const { return game.currentPlayerTurn() == me.pieceColor(); }
signals:

public slots:

private:
    Game game;
    Player me;
    Player opponent;
};

#endif // GAMEMANAGER_H
