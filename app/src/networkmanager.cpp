#include "networkmanager.h"
#include <QtCore/QDebug>
#include <QJsonDocument>
#include <QJsonArray>

NetworkManager::NetworkManager(QObject *parent) :
    QObject(parent)
{
    connect(&webSocket, &QWebSocket::connected, this, &NetworkManager::onConnected);
    connect(&webSocket, QOverload<const QList<QSslError>&>::of(&QWebSocket::sslErrors),
            this, &NetworkManager::onSslErrors);
    webSocket.open(QUrl(serverIp));
}

void NetworkManager::onConnected()
{
    qDebug() << "WebSocket connected";
    connect(&webSocket, &QWebSocket::textMessageReceived,
            this, &NetworkManager::onTextMessageReceived);
    connect(&webSocket, &QWebSocket::binaryMessageReceived,
            this, &NetworkManager::onBinaryMessageReceived);
}

void NetworkManager::onBinaryMessageReceived(QByteArray message)
{
    qDebug() << "Message received:" << message;
    QJsonObject msg = QJsonDocument::fromJson(message).object();
    auto user = msg.value("user").toString();
    if (msg.value("response") == "signup")
    {
        msg.value("reply") == "ok" ? emit signUpReply(user, true) :
                                     emit signUpReply(user, false);
    }
    else if (msg.value("response") == "login")
    {
        msg.value("reply") == "ok" ? emit loginReply(user, true) :
                                     emit loginReply(user, false);
    }
    else if (msg.value("response") == "salt")
    {
        auto salt = msg.value("reply").toString();
        salt == "" ? emit saltReceived(user, salt, false) :
                     emit saltReceived(user, salt, true);
    }
    else if (msg.value("response") == "online_player_query")
    {
        auto players = msg.value("reply").toArray();
        QList<QString> playerList;
        for (auto player : players)
        {
            playerList << player.toString();
        }
        playerList.isEmpty() ? emit playerQueryReply(playerList, false) :
                               emit playerQueryReply(playerList, true);
    }
}

void NetworkManager::onTextMessageReceived(QString message)
{
    qDebug() << "Message received:" << message;
}

void NetworkManager::sendRequest(const Request& req, const QJsonObject& data)
{
    QJsonObject request;
    switch(req)
    {
    case Request::SignUp:
        request["request"] = "signup";
        request["data"] = data;
        break;
    case Request::Login:
        request["request"] = "login";
        request["data"] = data;
        break;
    case Request::Logout:
        request["request"] = "logout";
        request["data"] = data;
        break;
    case Request::Salt:
        request["request"] = "salt";
        request["data"] = data;
        break;
    case Request::OnlinePlayerQuery:
        request["request"] = "online_player_query";
        request["data"] = data;
        break;

    }
    send(QJsonDocument(request).toJson());
}

void NetworkManager::send(const QByteArray& data)
{
    webSocket.sendBinaryMessage(data);
}

void NetworkManager::onSslErrors(const QList<QSslError> &errors)
{
    Q_UNUSED(errors);
    for (auto& error: errors)
        qDebug() << error.errorString();

    // WARNING: Never ignore SSL errors in production code.
    // The proper way to handle self-signed certificates is to add a custom root
    // to the CA store.

    webSocket.ignoreSslErrors();
}
