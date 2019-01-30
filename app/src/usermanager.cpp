#include "usermanager.h"
#include <string>
#include <QDebug>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include <QRandomGenerator>
#include <QCryptographicHash>

UserManager::UserManager()
{

}

void UserManager::addNetworkManager(std::shared_ptr<NetworkManager> nm)
{
    network = nm;
    connect(network.get(), &NetworkManager::signUpReply,
            this, &UserManager::signUpReply);
    connect(network.get(), &NetworkManager::loginReply,
            this, &UserManager::loginReply);
    connect(network.get(), &NetworkManager::saltReceived,
            this, &UserManager::saltReceived);
    connect(network.get(), &NetworkManager::rankingsReceived,
            this, &UserManager::rankingsObjReceived);
}

void UserManager::getRankings()
{
    network->sendRequest(NetworkManager::Request::Rankings, QJsonObject());
}

void UserManager::rankingsObjReceived(QJsonObject rankings)
{
    QList<QString> rankingsList;

    for (auto& user : rankings.keys())
    {
        auto userObj = rankings[user].toObject();
        if (rankingsList.isEmpty())
        {
            rankingsList << user
                         << QString::number(userObj["wins"].toInt())
                         << QString::number(userObj["losses"].toInt());
        }
        else
        {
            int index = 1;
            if (rankingsList[index].toInt() >
                       userObj["wins"].toInt())
            {
                while (index < rankingsList.length() && rankingsList[index].toInt() >
                       userObj["wins"].toInt())
                {
                    index += 3;
                }
                rankingsList.insert(index-1, QString::number(userObj["losses"].toInt()));
                rankingsList.insert(index-1, QString::number(userObj["wins"].toInt()));
                rankingsList.insert(index-1, user);
            }
            else
            {
                rankingsList.prepend(QString::number(userObj["losses"].toInt()));
                rankingsList.prepend(QString::number(userObj["wins"].toInt()));
                rankingsList.prepend(user);
            }
        }
    }

    emit rankingsReceived(rankingsList);
}

void UserManager::logout()
{
    if (player->isLoggedIn())
    {
        qDebug() << "Logging out";
        QJsonObject data;
        data["user"] = player->getUsername();
        player->logout();
        network->sendRequest(NetworkManager::Request::Logout, data);
    }
}

void UserManager::signUpReply(QString username, bool result)
{
    if (result) {
//        m_isLoggedIn = true;
        player->setUsername(username);
        emit loggedIn();
    }
}

void UserManager::loginReply(QString username, bool result)
{
    if (result) {
//        m_isLoggedIn = true;
        player->setUsername(username);
        emit loggedIn();
    }
}

void UserManager::saltReceived(QString username, QString salt, bool result)
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
        network->sendRequest(NetworkManager::Request::Login, data);
    }
}

QString UserManager::generateSalt()
{
    auto rng = QRandomGenerator::securelySeeded();
    QString salt;
    for(int i=0; i<saltSize/4; ++i)
    {
        salt += QString::number(rng.generate(), 16);
    }
    return salt;
}

QString UserManager::hash(QString salt, QString password)
{
    auto crypto = QCryptographicHash(QCryptographicHash::Sha512);
    auto hash = crypto.hash(salt.toLocal8Bit() +
                              password.toLocal8Bit(), QCryptographicHash::Sha512);
    for (int i = 0; i < 300000; i++)
    {
        hash = crypto.hash(salt.toLocal8Bit() + hash, QCryptographicHash::Sha512);
    }
    auto finalHash = hash.toHex();
    return QString(finalHash);
}

void UserManager::registerUser(QString username, QString password)
{
    auto salt = generateSalt();
    auto hashStr = hash(salt, password);

    QJsonObject data;
    data["user"] = username;
    data["salt"] = salt;
    data["hash"] = hashStr;
    network->sendRequest(NetworkManager::Request::SignUp, data);
}

void UserManager::loginUser(QString username, QString password)
{
    QJsonObject data;
    tempPassword = password;
    data["user"] = username;
    network->sendRequest(NetworkManager::Request::Salt, data);
}
