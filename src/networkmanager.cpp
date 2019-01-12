#include "networkmanager.h"

NetworkManager::NetworkManager()
    : manager(std::make_unique<QNetworkAccessManager>())
{

}
