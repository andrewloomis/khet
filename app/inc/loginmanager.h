#ifndef LOGINMANAGER_H
#define LOGINMANAGER_H

#include <QObject>
#include <QFile>
#include <string>
#include "networkmanager.h"

class LoginManager : public QObject
{
    Q_OBJECT
public:
    LoginManager();
    Q_INVOKABLE bool registerUser(QString username, QString password);

private:
    NetworkManager network;
};

#endif // LOGINMANAGER_H
