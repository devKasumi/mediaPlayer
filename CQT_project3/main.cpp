#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "player.h"
#include "playlistmodel.h"
#include <QQmlContext>
#include <QFileDevice>
#include <QList>
#include <QUrl>
#include <QStandardPaths>
#include <QDir>
#include <QFileDialog>
#include <QCommandLineParser>
#include <QMediaPlayer>
#include "translation.h"


int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    qRegisterMetaType<QMediaPlaylist*>("QMediaPlaylist*");
    qRegisterMetaType<QMediaPlaylist::PlaybackMode>("QMediaPlaylist::playbackMode");

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    Translation translator(&app);
    translator.setCurrentLanguage("us");

    Player player;

    engine.rootContext()->setContextProperty("MyModel", player.m_playlistModel);
    engine.rootContext()->setContextProperty("player", player.m_player);
    engine.rootContext()->setContextProperty("utility", &player);
    engine.rootContext()->setContextProperty("translator", &translator);


    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if(engine.rootObjects().isEmpty())
        return -1;


    return app.exec();
}
