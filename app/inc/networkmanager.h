#ifndef NETWORKMANAGER_H
#define NETWORKMANAGER_H

#include <QObject>
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
        OnlinePlayerQuery,
        GameRequest,
        TurnComplete,
        GameOver,
        Rankings
    };
    enum class Reply
    {
        InviteAccepted = 0,
        InviteDeclined
    };

    explicit NetworkManager(QObject *parent = nullptr);
    void send(const QByteArray& data);
    void sendRequest(const Request& req, const QJsonObject& data);
    void sendReply(const Reply& req, const QJsonObject& data);
    void connectToServer();
    bool isConnected() const { return webSocket.state() ==
                QAbstractSocket::ConnectedState; }

signals:
    void signUpReply(QString username, bool result);
    void loginReply(QString username, bool result);
    void saltReceived(QString username, QString salt, bool result);
    void playerQueryReply(QList<QString> players, bool result);
    void gameInviteReceived(QString opponentName, QString config);
    void gameRequestApproved(QString opponentName);
    void inviteAccepted(QString opponentName);
    void setColorReceived(QString color);
    void opponentMoved(int index, int angle, int xPos, int yPos);
    void endGameReceived(QString winner);
    void rankingsReceived(QJsonObject);

private slots:
    void onConnected();
    void onTextMessageReceived(QString message);
    void onBinaryMessageReceived(QByteArray message);
    void onSslErrors(const QList<QSslError> &errors);

private:
    QWebSocket webSocket;
    QString serverIp = "wss://100.16.106.184:60001";
    QByteArray queuedMessage = nullptr;
};

#endif // NETWORKMANAGER_H
