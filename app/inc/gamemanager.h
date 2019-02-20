#ifndef GAMEMANAGER_H
#define GAMEMANAGER_H

#include <QObject>
#include <QList>
#include "networkmanager.h"
#include <khetlib/game.h>
#include <khetlib/player.h>
#include <khetlib/khettypes.h>
#include <memory>

class GameManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString me READ getMyUsername)
    Q_PROPERTY(QString opponent READ getOpponentUsername WRITE setOpponentUsername)
    Q_PROPERTY(QString myColor READ getMyColor NOTIFY myColorChanged)
    Q_PROPERTY(QString mode MEMBER gameMode NOTIFY modeChanged)
//    Q_PROPERTY(bool myTurn READ isPlayerTurn)

public:
    explicit GameManager(QObject *parent = nullptr);
    void addNetworkManager(std::shared_ptr<NetworkManager> nm);
    void addPlayer(std::shared_ptr<Player> player) { me = player; }

    // Game logic
    Q_INVOKABLE void setupBoard(QString config);
    Q_INVOKABLE QList<int> getPiecePositions() const;
    Q_INVOKABLE int isPieceAtPosition(int x, int y) const;
    Q_INVOKABLE int possibleTranslationsForPiece(int index);

    Q_INVOKABLE void updatePiecePosition(int index, int x, int y);
    Q_INVOKABLE void updatePieceAngle(int index, int angle);

    Q_INVOKABLE QList<int> getBeamCoords(int startX, int startY);
    Q_INVOKABLE QString getPieceColor(int index) const;
    Q_INVOKABLE void turnFinished();
    Q_INVOKABLE void moveFinished();

    Q_INVOKABLE bool isMoveComplete() const { return moveComplete; }
    Q_INVOKABLE bool isPlayerTurn() const { return game.currentPlayerTurn() == me->pieceColor(); }
    Q_INVOKABLE void reset();
signals:
//    void pieceKilled(int index);
    void pieceKilled(int index, QString type, QString color);
    void modeChanged();
    void myColorChanged();
    void opponentPieceMoved(int index, int angle, int xPos, int yPos);
    void endGame(QString winner);
    void unstackPiece(int index, QString color);
    void myTurnFinished();

private slots:
    void multiplayerGameStart(QString opponentName);
    void pieceKilledInGame(int index);
    void setPlayerColor(QString color);
    void moveOpponentPiece(int index, int angle, int xPos, int yPos);
    void pharoahKilled(int index);
    void endGameReceived(QString winner);

private:
    QString getMyUsername() { return me->getUsername(); }
    QString getMyColor() const { return me->pieceColor() == Color::Red ? "red" : "grey"; }
    QString getOpponentUsername() { return opponent.getUsername(); }
    void setOpponentUsername(QString name) { opponent.setUsername(name); }

    bool moveComplete = false;
    int movedPieceIndex = -1;
    QString gameMode = "sandbox";
    Game game;
    std::shared_ptr<Player> me = std::make_shared<Player>();
    Player opponent;
    std::shared_ptr<NetworkManager> network;
};

#endif // GAMEMANAGER_H
