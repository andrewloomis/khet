#ifndef GAMEMANAGER_H
#define GAMEMANAGER_H

#include <QObject>
#include <QList>
#include "networkmanager.h"
#include <khetlib/game.h>
#include <khetlib/player.h>
#include <memory>

class GameManager : public QObject
{
    Q_OBJECT
public:
    explicit GameManager(QObject *parent = nullptr);
    void addNetworkManager(std::shared_ptr<NetworkManager> nm) { network = nm; }
    void addPlayer(std::shared_ptr<Player> player) { me = player; }
    Q_INVOKABLE void findOnlinePlayers();

    // Game logic
    Q_INVOKABLE QList<int> getPiecePositions() const;
    Q_INVOKABLE int isPieceAtPosition(int x, int y) const;
    Q_INVOKABLE int possibleTranslationsForPiece(int index);
    Q_INVOKABLE void updatePiecePosition(int index, int x, int y);
    Q_INVOKABLE void updatePieceAngle(int index, int angle);
    Q_INVOKABLE QList<int> getBeamCoords();
    Q_INVOKABLE int getPieceColor(int index) const;
    Q_INVOKABLE void turnFinished() { game.nextTurn(); }
    Q_INVOKABLE int getMyColor() const { return me->pieceColor() == Color::Red ? 0 : 1; }
    Q_INVOKABLE bool isPlayerTurn() const { return game.currentPlayerTurn() == me->pieceColor(); }
    Q_INVOKABLE bool isGodMode() const { return game.isGodMode(); }

public slots:

private:
    Game game;
    std::shared_ptr<Player> me;
    Player opponent;
    std::shared_ptr<NetworkManager> network;
};

#endif // GAMEMANAGER_H
