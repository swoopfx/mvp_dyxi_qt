#include "traceabletexte.h"
#include <QDebug>

TracableTexte::TracableTexte(QQuickItem *parent)
    : QQuickPaintedItem(parent)
{
    setAcceptedMouseButtons(Qt::LeftButton);
    setAcceptTouchEvents(true);
    setAntialiasing(true);
}

TracableTexte::~TracableTexte() = default;

void TracableTexte::setText(const QString &text)
{
    if (m_text != text) {
        m_text = text;
        m_outlinePath = QPainterPath();
        if (!m_text.isEmpty()) {
            QFontMetrics fm(m_font);
            m_outlinePath.addText(0, fm.ascent(), m_font, m_text);
        }
        update();
        emit textChanged();
    }
}

void TracableTexte::setFont(const QFont &font)
{
    if (m_font != font) {
        m_font = font;
        m_outlinePath = QPainterPath();
        if (!m_text.isEmpty()) {
            QFontMetrics fm(m_font);
            m_outlinePath.addText(0, fm.ascent(), m_font, m_text);
        }
        update();
        emit fontChanged();
    }
}

void TracableTexte::setOutlineColor(const QColor &color)
{
    if (m_outlineColor != color) {
        m_outlineColor = color;
        update();
        emit outlineColorChanged();
    }
}

void TracableTexte::setTraceColor(const QColor &color)
{
    if (m_traceColor != color) {
        m_traceColor = color;
        update();
        emit traceColorChanged();
    }
}

void TracableTexte::setPenWidth(qreal width)
{
    if (m_penWidth != width) {
        m_penWidth = width;
        update();
        emit penWidthChanged();
    }
}

void TracableTexte::setPenStyle(Qt::PenStyle style)
{
    if (m_penStyle != style) {
        m_penStyle = style;
        update();
        emit penStyleChanged();
    }
}

void TracableTexte::setTracingEnabled(bool enabled)
{
    if (m_tracingEnabled != enabled) {
        m_tracingEnabled = enabled;
        if (!enabled) {
            clearTrace();
        }
        emit tracingEnabledChanged();
    }
}

void TracableTexte::setTraceSmoothness(qreal smoothness)
{
    if (m_traceSmoothness != smoothness) {
        m_traceSmoothness = qBound(0.0, smoothness, 1.0);
        emit traceSmoothnessChanged();
    }
}

void TracableTexte::paint(QPainter *painter)
{
    painter->setRenderHint(QPainter::Antialiasing, true);

    // Center the text in the item
    QRectF bounds = m_outlinePath.boundingRect();
    QPointF centerOffset(width() / 2 - bounds.width() / 2,
                         height() / 2 - bounds.height() / 2 + bounds.y());

    // Draw dotted/dashed outline
    QPen outlinePen(m_outlineColor, m_penWidth, m_penStyle, Qt::RoundCap, Qt::RoundJoin);
    painter->setPen(outlinePen);
    painter->setBrush(Qt::NoBrush);
    painter->drawPath(m_outlinePath.translated(centerOffset));

    // Draw user trace path
    if (!m_tracePoints.isEmpty() && m_tracingEnabled) {
        QPainterPath tracePath;
        if (!m_tracePoints.isEmpty()) {
            tracePath.moveTo(m_tracePoints.first());
        }
        for (int i = 1; i < m_tracePoints.size(); ++i) {
            tracePath.lineTo(m_tracePoints[i]);
        }

        QPen tracePen(m_traceColor, m_penWidth * 1.5, Qt::SolidLine, Qt::RoundCap, Qt::RoundJoin);
        painter->setPen(tracePen);
        painter->setBrush(Qt::NoBrush);
        painter->drawPath(tracePath.translated(centerOffset));
    }
}

void TracableTexte::mousePressEvent(QMouseEvent *event)
{
    if (m_tracingEnabled) {
        m_isTracing = true;
        QPointF pos = mapFromGlobal(event->globalPosition().toPoint());
        addTracePoint(pos);
        update();
    }
    QQuickPaintedItem::mousePressEvent(event);
}

void TracableTexte::mouseMoveEvent(QMouseEvent *event)
{
    if (m_isTracing && m_tracingEnabled) {
        QPointF pos = mapFromGlobal(event->globalPosition().toPoint());
        addTracePoint(pos);
        update();
    }
    QQuickPaintedItem::mouseMoveEvent(event);
}

void TracableTexte::mouseReleaseEvent(QMouseEvent *event)
{
    m_isTracing = false;
    QQuickPaintedItem::mouseReleaseEvent(event);
}

void TracableTexte::touchEvent(QTouchEvent *event)
{
    if (!m_tracingEnabled) {
        QQuickPaintedItem::touchEvent(event);
        return;
    }

    switch (event->type()) {
    case QEvent::TouchBegin:
    case QEvent::TouchUpdate: {
        m_isTracing = true;
        const QTouchEvent::TouchPoint &touch = event->points().first();
        QPointF pos = touch.position();
        addTracePoint(pos);
        update();
        event->accept();
        break;
    }
    case QEvent::TouchEnd:
        m_isTracing = false;
        event->accept();
        break;
    default:
        QQuickPaintedItem::touchEvent(event);
    }
}

void TracableTexte::clearTrace()
{
    m_tracePoints.clear();
    m_isTracing = false;
    update();
}

void TracableTexte::addTracePoint(const QPointF &point)
{
    if (m_tracePoints.isEmpty()) {
        m_tracePoints.append(point);
        m_lastTracePoint = point;
    } else {
        // Smooth tracing - only add points that are sufficiently distant
        qreal distance = QLineF(m_lastTracePoint, point).length();
        if (distance > m_penWidth * m_traceSmoothness) {
            m_tracePoints.append(point);
            m_lastTracePoint = point;
        }
    }
}