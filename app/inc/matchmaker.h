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

    Q_INVOKABLE void findOnlinePlayers();

signals:
    void onlinePlayerFound(QString newPlayer);

private slots:
    void processNewPlayers(QList<QString> players, bool result);

private:
    QList<QString> onlinePlayers;
    std::shared_ptr<Player> me;
    std::shared_ptr<NetworkManager> network;
};

#endif // MATCHMAKER_H
