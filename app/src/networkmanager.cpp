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
}

void NetworkManager::connectToServer()
{
    webSocket.open(QUrl(serverIp));
}

void NetworkManager::onConnected()
{
    qDebug() << "WebSocket connected to" << webSocket.peerAddress().toString();
    qDebug() << webSocket.state();
    connect(&webSocket, &QWebSocket::textMessageReceived,
            this, &NetworkManager::onTextMessageReceived);
    connect(&webSocket, &QWebSocket::binaryMessageReceived,
            this, &NetworkManager::onBinaryMessageReceived);
    if (!queuedMessage.isEmpty())
    {
        send(queuedMessage);
    }
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
        emit playerQueryReply(playerList, true);
//        playerList.isEmpty() ? emit playerQueryReply(playerList, false) :
//                               emit playerQueryReply(playerList, true);
    }
    else if (msg.value("response") == "game_request")
    {
        if (msg.value("reply").toString() == "ok")
        {
            emit gameRequestApproved(msg.value("opponent").toString());
        }
    }
    else if (msg.value("response") == "rankings")
    {
        emit rankingsReceived(msg.value("rankings").toObject());
    }
    else if (msg.value("request") == "game_invite")
    {
        auto opponent = msg.value("fromUser").toString();
        emit gameInviteReceived(opponent);
    }
    else if (msg.value("command") == "set_color")
    {
        auto color = msg.value("color").toString();
        emit setColorReceived(color);
    }
    else if (msg.value("command") == "your_turn")
    {
        auto opponentTurnInfo = msg.value("opponent_turn_info").toObject();
        int index = opponentTurnInfo.value("piece_index").toInt();
        int angle = opponentTurnInfo.value("piece_angle").toInt();
        int xPos = opponentTurnInfo.value("x_pos").toInt();
        int yPos = opponentTurnInfo.value("y_pos").toInt();
        emit opponentMoved(index, angle, xPos, yPos);
    }
    else if (msg.value("command") == "game_over")
    {
        emit endGameReceived(msg.value("winner").toString());
    }
}

void NetworkManager::onTextMessageReceived(QString message)
{
//    qDebug() << "Message received:" << message;
}

void NetworkManager::sendReply(const Reply& rep, const QJsonObject& data)
{
    QJsonObject reply;
    switch(rep)
    {
    case Reply::InviteAccepted:
        reply["reply"] = "invite_accepted";
        reply["data"] = data;
        emit inviteAccepted(data.value("opponent").toString());
        break;
    case Reply::InviteDeclined:
        reply["reply"] = "invite_declined";
        reply["data"] = data;
        break;
    }
    send(QJsonDocument(reply).toJson());
}

void NetworkManager::sendRequest(const Request& req, const QJsonObject& data)
{
    if (!isConnected()) connectToServer();
//    while (!isConnected());

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
    case Request::GameRequest:
        request["request"] = "game_request";
        request["data"] = data;
        break;
    case Request::TurnComplete:
        request["request"] = "turn_complete";
        request["data"] = data;
        break;
    case Request::GameOver:
        request["request"] = "game_over";
        request["data"] = data;
        break;
    case Request::Rankings:
        request["request"] = "rankings";
    }
    auto message = QJsonDocument(request).toJson();
    if (isConnected())
    {
        send(message);
    }
    else
    {
        queuedMessage = message;
    }

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
