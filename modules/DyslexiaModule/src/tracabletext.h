#ifndef TRACABLETEXT_H
#define TRACABLETEXT_H

#include <QQuickPaintedItem>
#include <QPainterPath>
#include <QFont>
#include <QColor>
#include <QVector>
#include <QPointF>

class TracableText : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)
    Q_PROPERTY(QFont font READ font WRITE setFont NOTIFY fontChanged)
    Q_PROPERTY(QColor penColor READ penColor WRITE setPenColor NOTIFY penColorChanged)
    Q_PROPERTY(Qt::PenStyle penStyle READ penStyle WRITE setPenStyle NOTIFY penStyleChanged)
    Q_PROPERTY(qreal penWidth READ penWidth WRITE setPenWidth NOTIFY penWidthChanged)
    Q_PROPERTY(QColor traceColor READ traceColor WRITE setTraceColor NOTIFY traceColorChanged)

public:
    TracableText(QQuickItem *parent = nullptr);

    void paint(QPainter *painter) override;

    QString text() const { return m_text; }
    void setText(const QString &text);

    QFont font() const { return m_font; }
    void setFont(const QFont &font);

    QColor penColor() const { return m_penColor; }
    void setPenColor(const QColor &color);

    Qt::PenStyle penStyle() const { return m_penStyle; }
    void setPenStyle(Qt::PenStyle style);

    qreal penWidth() const { return m_penWidth; }
    void setPenWidth(qreal width);

    QColor traceColor() const { return m_traceColor; }
    void setTraceColor(const QColor &color);

    Q_INVOKABLE void addTracePoint(qreal x, qreal y);
    Q_INVOKABLE void startNewTracePath(qreal x, qreal y);
    Q_INVOKABLE void clearTrace();

signals:
    void textChanged();
    void fontChanged();
    void penColorChanged();
    void penStyleChanged();
    void penWidthChanged();
    void traceColorChanged();

private:
    QString m_text;
    QFont m_font;
    QColor m_penColor;
    Qt::PenStyle m_penStyle;
    qreal m_penWidth;
    QColor m_traceColor;

    QVector<QPainterPath> m_tracePaths;
    QPainterPath m_currentTracePath;
};

#endif // TRACABLETEXT_H
