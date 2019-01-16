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
    Q_INVOKABLE void updatePiecePosition(int index, int x, int y);
    Q_INVOKABLE void updatePieceAngle(int index, int angle);
    Q_INVOKABLE QList<int> getBeamCoords() const;
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
