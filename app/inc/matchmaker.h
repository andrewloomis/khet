#ifndef MATCHMAKER_H
#define MATCHMAKER_H

#include <QObject>
#include <memory>
#include "networkmanager.h"
#include "khetlib/player.h"

class MatchMaker : public QObject
{
    Q_OBJECT

public:
    MatchMaker(QObject* parent = nullptr);
    void addNetworkManager(std::shared_ptr<NetworkManager> nm);
    void addPlayer(std::shared_ptr<Player> player) { me = player; }
    Q_INVOKABLE void sendGameInvite(QString opponentName, QString config);
    Q_INVOKABLE void sendInviteDeclined(QString opponentName);
    Q_INVOKABLE void sendInviteAccepted(QString opponentName, QString config);
    Q_INVOKABLE void findOnlinePlayers();

signals:
    void onlinePlayerFound(QString newPlayer);
    void onlinePlayerRemoved(QString removedPlayer);
    void gameInvite(QString opponentName, QString config);
    void gameApproved(QString opponentName);

private slots:
    void processNewPlayers(QList<QString> players, bool result);
    void gameInviteReceived(QString opponentName, QString config);
    void gameRequestApproved(QString opponentName);

private:
    QList<QString> onlinePlayers;
    std::shared_ptr<Player> me;
    std::shared_ptr<NetworkManager> network;
};

#endif // MATCHMAKER_H
