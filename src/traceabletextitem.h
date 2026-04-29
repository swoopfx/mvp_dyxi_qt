
#ifndef TRACEABLETEXTITEM_H
#define TRACEABLETEXTITEM_H

#include <QQuickPaintedItem>
#include <QPainterPath>
#include <QFont>
#include <QPen>
#include <QQmlEngine>

class TraceableTextItem : public QQuickPaintedItem
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)
    Q_PROPERTY(QFont font READ font WRITE setFont NOTIFY fontChanged)
    Q_PROPERTY(QColor penColor READ penColor WRITE setPenColor NOTIFY penColorChanged)
    Q_PROPERTY(Qt::PenStyle penStyle READ penStyle WRITE setPenStyle NOTIFY penStyleChanged)
    Q_PROPERTY(qreal penWidth READ penWidth WRITE setPenWidth NOTIFY penWidthChanged)

public:
    TraceableTextItem(QQuickPaintedItem *parent = nullptr);

    void paint(QPainter *painter) override;

    QString text() const { return m_text; }
    void setText(const QString &text);

    QFont font() const { return m_font; }
    void setFont(const QFont &font);

    QColor penColor() const { return m_pen.color(); }
    void setPenColor(const QColor &color);

    Qt::PenStyle penStyle() const { return m_pen.style(); }
    void setPenStyle(Qt::PenStyle style);

    qreal penWidth() const { return m_pen.widthF(); }
    void setPenWidth(qreal width);

signals:
    void textChanged();
    void fontChanged();
    void penColorChanged();
    void penStyleChanged();
    void penWidthChanged();

private:
    QString m_text;
    QFont m_font;
    QPen m_pen;
    QPainterPath m_path;

    void updatePath();
};

#endif // TRACEABLETEXTITEM_H
