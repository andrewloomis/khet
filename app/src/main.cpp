#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "gamemanager.h"
#include "loginmanager.h"

int main(int argc, char *argv[])
{
//    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    qmlRegisterType<GameManager>("khet.gamemanager", 1, 0, "GameManager");
    qmlRegisterType<LoginManager>("khet.loginmanager", 1, 0, "LoginManager");
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
