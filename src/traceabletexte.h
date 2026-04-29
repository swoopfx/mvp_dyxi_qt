#ifndef TRACEABLETEXTE_H
#define TRACEABLETEXTE_H

#include <QQuickPaintedItem>
#include <QPainter>
#include <QPainterPath>
#include <QPen>
#include <QFont>
#include <QMouseEvent>
#include <QTouchEvent>
#include <QQmlEngine>

class TracableTexte : public QQuickPaintedItem
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)
    Q_PROPERTY(QFont font READ font WRITE setFont NOTIFY fontChanged)
    Q_PROPERTY(QColor outlineColor READ outlineColor WRITE setOutlineColor NOTIFY outlineColorChanged)
    Q_PROPERTY(QColor traceColor READ traceColor WRITE setTraceColor NOTIFY traceColorChanged)
    Q_PROPERTY(qreal penWidth READ penWidth WRITE setPenWidth NOTIFY penWidthChanged)
    Q_PROPERTY(Qt::PenStyle penStyle READ penStyle WRITE setPenStyle NOTIFY penStyleChanged)
    Q_PROPERTY(bool tracingEnabled READ tracingEnabled WRITE setTracingEnabled NOTIFY tracingEnabledChanged)
    Q_PROPERTY(qreal traceSmoothness READ traceSmoothness WRITE setTraceSmoothness NOTIFY traceSmoothnessChanged)

public:
    explicit TracableTexte(QQuickItem *parent = nullptr);
    ~TracableTexte();

    QString text() const { return m_text; }
    void setText(const QString &text);
    QFont font() const { return m_font; }
    void setFont(const QFont &font);
    QColor outlineColor() const { return m_outlineColor; }
    void setOutlineColor(const QColor &color);
    QColor traceColor() const { return m_traceColor; }
    void setTraceColor(const QColor &color);
    qreal penWidth() const { return m_penWidth; }
    void setPenWidth(qreal width);
    Qt::PenStyle penStyle() const { return m_penStyle; }
    void setPenStyle(Qt::PenStyle style);
    bool tracingEnabled() const { return m_tracingEnabled; }
    void setTracingEnabled(bool enabled);
    qreal traceSmoothness() const { return m_traceSmoothness; }
    void setTraceSmoothness(qreal smoothness);

    void paint(QPainter *painter) override;

signals:
    void textChanged();
    void fontChanged();
    void outlineColorChanged();
    void traceColorChanged();
    void penWidthChanged();
    void penStyleChanged();
    void tracingEnabledChanged();
    void traceSmoothnessChanged();

protected:
    void mousePressEvent(QMouseEvent *event) override;
    void mouseMoveEvent(QMouseEvent *event) override;
    void mouseReleaseEvent(QMouseEvent *event) override;
    void touchEvent(QTouchEvent *event) override;

private:
    void clearTrace();
    void addTracePoint(const QPointF &point);

    QString m_text;
    QFont m_font;
    QColor m_outlineColor = Qt::darkBlue;
    QColor m_traceColor = Qt::red;
    qreal m_penWidth = 3.0;
    Qt::PenStyle m_penStyle = Qt::DotLine;
    bool m_tracingEnabled = true;
    qreal m_traceSmoothness = 0.3;

    QPainterPath m_outlinePath;
    QVector<QPointF> m_tracePoints;
    bool m_isTracing = false;
    QPointF m_lastTracePoint;
};

#endif // TRACEABLETEXTE_H
