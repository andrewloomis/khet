#include "loginmanager.h"
#include <string>
#include <QDebug>
#include <QJsonObject>
#include <QJsonDocument>
#include <QRandomGenerator>
#include <QCryptographicHash>

LoginManager::LoginManager()
{

}

void LoginManager::addNetworkManager(std::shared_ptr<NetworkManager> nm)
{
    network = nm;
    connect(network.get(), &NetworkManager::signUpReply, this, &LoginManager::signUpReply);
    connect(network.get(), &NetworkManager::loginReply, this, &LoginManager::loginReply);
    connect(network.get(), &NetworkManager::saltReceived, this, &LoginManager::saltReceived);
}

void LoginManager::logout()
{
    if (player->isLoggedIn())
    {
        qDebug() << "Logging out";
        player->logout();
        QJsonObject data;
        data["user"] = player->getUsername();
        network->sendRequest(NetworkManager::Request::Logout, data);
    }
}

void LoginManager::signUpReply(QString username, bool result)
{
    if (result) {
//        m_isLoggedIn = true;
        player->setUsername(username);
        emit loggedIn();
    }
}

void LoginManager::loginReply(QString username, bool result)
{
    if (result) {
//        m_isLoggedIn = true;
        player->setUsername(username);
        emit loggedIn();
    }
}

void LoginManager::saltReceived(QString username, QString salt, bool result)
{
    if (!result && salt == "")
    {
        qDebug() << "user" << username << "does not exist";
        emit userDoesNotExist();
    }
    else
    {
        QJsonObject data;
        data["user"] = username;
        data["hash"] = hash(salt, tempPassword);
    //    qDebug() << "Salt:" << salt << '\n' << "hash:" << hash;
        network->sendRequest(NetworkManager::Request::Login, data);
    }
}

QString LoginManager::generateSalt()
{
    auto rng = QRandomGenerator::securelySeeded();
    QString salt;
    for(int i=0; i<saltSize/4; ++i)
    {
        salt += QString::number(rng.generate(), 16);
    }
    return salt;
}

QString LoginManager::hash(QString salt, QString password)
{
    auto hash = QCryptographicHash(QCryptographicHash::Sha256).hash(salt.toLocal8Bit() +
                              password.toLocal8Bit(), QCryptographicHash::Sha256).toHex();
    return QString(hash);
}

void LoginManager::registerUser(QString username, QString password)
{
    auto salt = generateSalt();
    auto hashStr = hash(salt, password);

    QJsonObject data;
    data["user"] = username;
    data["salt"] = salt;
    data["hash"] = hashStr;
//    qDebug() << "Salt:" << salt << '\n' << "hash:" << hash;
    network->sendRequest(NetworkManager::Request::SignUp, data);
}

void LoginManager::loginUser(QString username, QString password)
{
    QJsonObject data;
    tempPassword = password;
    data["user"] = username;
    network->sendRequest(NetworkManager::Request::Salt, data);
}
