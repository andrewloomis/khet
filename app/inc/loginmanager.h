#ifndef LOGINMANAGER_H
#define LOGINMANAGER_H

#include <QObject>
#include <QFile>
#include <string>
#include "networkmanager.h"
#include "khetlib/player.h"
#include <memory>
class LoginManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString username READ getUsername)

public:
    LoginManager();
    Q_INVOKABLE void registerUser(QString username, QString password);
    Q_INVOKABLE void loginUser(QString username, QString password);
    Q_INVOKABLE void logout();
    Q_INVOKABLE bool isLoggedIn() const { return player->isLoggedIn(); }
    void addNetworkManager(std::shared_ptr<NetworkManager> nm);
    void addPlayer(std::shared_ptr<Player> p) { player = p; }

signals:
    void loggedIn();
    void userDoesNotExist();

private slots:
    void signUpReply(QString username, bool result);
    void loginReply(QString username, bool result);
    void saltReceived(QString username, QString salt, bool result);

private:
    QString getUsername() const { return player ? player->getUsername() : "Unknown"; }
    QString generateSalt();
    QString hash(QString salt, QString password);

    bool m_isLoggedIn = false;
    QString tempPassword;
    static constexpr int saltSize = 32;
    std::shared_ptr<NetworkManager> network = nullptr;
    std::shared_ptr<Player> player = nullptr;
};

#endif // LOGINMANAGER_H
