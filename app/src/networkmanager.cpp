#include "networkmanager.h"
#include <QtCore/QDebug>

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
//    webSocket.sendTextMessage(QStringLiteral("Hello, world!"));
}

void NetworkManager::onBinaryMessageReceived(QByteArray message)
{
    qDebug() << "Message received:" << message;
}

void NetworkManager::onTextMessageReceived(QString message)
{
    qDebug() << "Message received:" << message;
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
