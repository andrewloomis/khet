#ifndef NETWORKMANAGER_H
#define NETWORKMANAGER_H

#include <QtNetwork>
#include <memory>

class NetworkManager
{
public:
    NetworkManager();

private:
    std::unique_ptr<QNetworkAccessManager> manager;
};

#endif // NETWORKMANAGER_H
