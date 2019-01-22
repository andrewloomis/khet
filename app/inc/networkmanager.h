#ifndef NETWORKMANAGER_H
#define NETWORKMANAGER_H

#include <QtCore/QObject>
#include <QtWebSockets/QWebSocket>
#include <QtNetwork/QSslError>
#include <QtCore/QList>
#include <QtCore/QString>
#include <QtCore/QUrl>
#include <QJsonObject>
#include <memory>

class NetworkManager : public QObject
{
    Q_OBJECT
public:
    enum class Request
    {
        SignUp = 0,
        Login,
        Logout,
        Salt,
        OnlinePlayerQuery
    };
    explicit NetworkManager(QObject *parent = nullptr);
    void send(const QByteArray& data);
    void sendRequest(const Request& req, const QJsonObject& data);

signals:
    void signUpReply(QString username, bool result);
    void loginReply(QString username, bool result);
    void saltReceived(QString username, QString salt, bool result);
    void playerQueryReply(QList<QString> players, bool result);

private slots:
    void onConnected();
    void onTextMessageReceived(QString message);
    void onBinaryMessageReceived(QByteArray message);
    void onSslErrors(const QList<QSslError> &errors);

private:
    QWebSocket webSocket;
    QString serverIp = "wss://100.16.106.184:60001";
};

#endif // NETWORKMANAGER_H
