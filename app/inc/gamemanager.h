#ifndef GAMEMANAGER_H
#define GAMEMANAGER_H

#include <QObject>
#include <QPoint>
#include <QList>
#include <khetlib/game.h>

class GameManager : public QObject
{
    Q_OBJECT
public:
    explicit GameManager(QObject *parent = nullptr);
    Q_INVOKABLE QList<int> getPiecePositions() const;
    Q_INVOKABLE int possibleTranslationsForPiece(int index);
signals:

public slots:

private:
    // Ordering:
    // Red:
    // Pharoah x1
    // Djed x2
    // Obelisk x4
    // Pyramid x7
    // Grey (same order)

    Game game;
};

#endif // GAMEMANAGER_H
