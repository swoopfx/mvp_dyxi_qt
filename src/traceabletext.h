#ifndef TRACEABLETEXT_H
#define TRACEABLETEXT_H

#include <QQuickPaintedItem>
#include <QPen>
#include <QPainterPath>
#include <QQmlEngine>

class TraceableText : public QQuickPaintedItem
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)
    Q_PROPERTY(QFont font READ font WRITE setFont NOTIFY fontChanged)
    Q_PROPERTY(QColor penColor READ penColor WRITE setPenColor NOTIFY penColorChanged)
    Q_PROPERTY(Qt::PenStyle penStyle READ penStyle WRITE setPenStyle NOTIFY penStyleChanged)
    Q_PROPERTY(qreal penWidth READ penWidth WRITE setPenWidth NOTIFY penWidthChanged)
    Q_PROPERTY(QColor traceColor READ traceColor WRITE setTraceColor NOTIFY traceColorChanged)

public:
    explicit TraceableText(QQuickItem *parent = nullptr);

    QString text() const;
    QFont font() const;
    QColor penColor() const;
    Qt::PenStyle penStyle() const;
    qreal penWidth() const;
    QColor traceColor() const;

public Q_SLOTS:
    void setText(const QString &text);
    void setFont(const QFont &font);
    void setPenColor(const QColor &color);
    void setPenStyle(Qt::PenStyle style);
    void setPenWidth(qreal width);
    void setTraceColor(const QColor &color);
    void updateTextPath();
    // void mousePressEvent(QMouseEvent *);
    // void mouseMoveEvent(QMouseEvent *);
    // void mouseReleaseEvent(QMouseEvent)

Q_SIGNALS:
    void textChanged();
    void fontChanged();
    void penColorChanged();
    void penStyleChanged();
    void penWidthChanged();
    void traceColorChanged();

protected:
    void paint(QPainter *painter) override;

private:
    QString m_text{"cat"};
    QFont m_font{"Arial", 48};
    QColor m_penColor{Qt::black};
    Qt::PenStyle m_penStyle{Qt::DotLine};
    qreal m_penWidth{3.0};
    QColor m_traceColor{Qt::red};
    QPainterPath m_textPath;
    QPainterPath m_tracePath;

    // QQuickItem interface
protected:
    void mousePressEvent(QMouseEvent *event) override;
    void mouseMoveEvent(QMouseEvent *event) override;
    void mouseReleaseEvent(QMouseEvent *event) override;
};
#endif // TRACEABLETEXT_H