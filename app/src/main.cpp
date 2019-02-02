#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "gamemanager.h"
#include "usermanager.h"
#include "matchmaker.h"
#include "networkmanager.h"
#include <memory>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    qmlRegisterType<GameManager>("khet.gamemanager", 1, 0, "GameManager");
    qmlRegisterType<UserManager>("khet.usermanager", 1, 0, "UserManager");
    qmlRegisterType<MatchMaker>("khet.matchmaker", 1, 0, "MatchMaker");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    auto nm = std::make_shared<NetworkManager>();
    auto player = std::make_shared<Player>();
    auto root = engine.rootObjects().first();
    auto gameManager = root->findChild<GameManager*>("gameManager");
    gameManager->addNetworkManager(nm);
    gameManager->addPlayer(player);
    auto userManager = root->findChild<UserManager*>("userManager");
    userManager->addNetworkManager(nm);
    userManager->addPlayer(player);
    auto matchMaker = root->findChild<MatchMaker*>("matchMaker");
    matchMaker->addNetworkManager(nm);
    matchMaker->addPlayer(player);
    QObject::connect(&app, &QGuiApplication::aboutToQuit, userManager, &UserManager::logout);

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
