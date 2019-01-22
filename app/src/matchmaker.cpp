#include "matchmaker.h"
#include <QJsonObject>

MatchMaker::MatchMaker(QObject* parent)
{

}

void MatchMaker::addNetworkManager(std::shared_ptr<NetworkManager> nm)
{
    network = nm;
    connect(network.get(), &NetworkManager::playerQueryReply, this, &MatchMaker::processNewPlayers);
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
    }
}

void MatchMaker::findOnlinePlayers()
{
    QJsonObject data;
    data["user"] = me->getUsername();
    network->sendRequest(NetworkManager::Request::OnlinePlayerQuery, data);
}
