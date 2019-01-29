#include "matchmaker.h"
#include <QJsonObject>

MatchMaker::MatchMaker(QObject* parent)
{

}

void MatchMaker::addNetworkManager(std::shared_ptr<NetworkManager> nm)
{
    network = nm;
    connect(network.get(), &NetworkManager::playerQueryReply, this, &MatchMaker::processNewPlayers);
    connect(network.get(), &NetworkManager::gameInviteReceived, this, &MatchMaker::gameInviteReceived);
    connect(network.get(), &NetworkManager::gameRequestApproved, this, &MatchMaker::gameRequestApproved);
}

void MatchMaker::processNewPlayers(QList<QString> players, bool result)
{
    if (result)
    {
        for (auto& player : players)
        {
            if (!onlinePlayers.contains(player))
            {
                onlinePlayers << player;
                emit onlinePlayerFound(player);
            }
        }
        for (auto& player : onlinePlayers)
        {
            if (!players.contains(player))
            {
                emit onlinePlayerRemoved(player);
            }
        }
    }
}

void MatchMaker::gameInviteReceived(QString opponentName)
{
    emit gameInvite(opponentName);
}

void MatchMaker::gameRequestApproved(QString opponentName)
{
    emit gameApproved(opponentName);
}

void MatchMaker::sendGameInvite(QString opponentName)
{
    QJsonObject data;
    data["user"] = me->getUsername();
    data["opponent"] = opponentName;
    network->sendRequest(NetworkManager::Request::GameRequest, data);
}

void MatchMaker::sendInviteAccepted(QString opponentName)
{
    QJsonObject data;
    data["user"] = me->getUsername();
    data["opponent"] = opponentName;
    network->sendReply(NetworkManager::Reply::InviteAccepted, data);
}

void MatchMaker::sendInviteDeclined(QString opponentName)
{
    QJsonObject data;
    data["user"] = me->getUsername();
    data["opponent"] = opponentName;
    network->sendReply(NetworkManager::Reply::InviteDeclined, data);
}

void MatchMaker::findOnlinePlayers()
{
    QJsonObject data;
    data["user"] = me->getUsername();
    network->sendRequest(NetworkManager::Request::OnlinePlayerQuery, data);
}
