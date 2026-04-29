
#include "traceabletextitem.h"

#include <QPainter>
#include <QFontMetricsF>

TraceableTextItem::TraceableTextItem(QQuickPaintedItem *parent)
    : QQuickPaintedItem(parent)
{
    setAntialiasing(true);
    m_pen.setBrush(Qt::NoBrush);
    m_pen.setStyle(Qt::DotLine);
    m_pen.setWidthF(2.0);
    m_pen.setColor(Qt::black);

    // Default font
    m_font.setPointSize(50);
    m_font.setBold(true);
    updatePath();
}

void TraceableTextItem::paint(QPainter *painter)
{
    painter->setPen(m_pen);
    painter->drawPath(m_path);
}

void TraceableTextItem::setText(const QString &text)
{
    if (m_text == text)
        return;

    m_text = text;
    updatePath();
    emit textChanged();
    update(); // Request repaint
}

void TraceableTextItem::setFont(const QFont &font)
{
    if (m_font == font)
        return;

    m_font = font;
    updatePath();
    emit fontChanged();
    update(); // Request repaint
}

void TraceableTextItem::setPenColor(const QColor &color)
{
    if (m_pen.color() == color)
        return;

    m_pen.setColor(color);
    emit penColorChanged();
    update(); // Request repaint
}

void TraceableTextItem::setPenStyle(Qt::PenStyle style)
{
    if (m_pen.style() == style)
        return;

    m_pen.setStyle(style);
    emit penStyleChanged();
    update(); // Request repaint
}

void TraceableTextItem::setPenWidth(qreal width)
{
    if (m_pen.widthF() == width)
        return;

    m_pen.setWidthF(width);
    emit penWidthChanged();
    update(); // Request repaint
}

void TraceableTextItem::updatePath()
{
    m_path = QPainterPath();
    if (m_text.isEmpty())
        return;

    QFontMetricsF fm(m_font);
    qreal x = 0;
    qreal y = fm.ascent(); // Position text at baseline

    m_path.addText(x, y, m_font, m_text);

    // Adjust size based on the path bounding rect
    QRectF bounds = m_path.boundingRect();
    setWidth(bounds.width());
    setHeight(bounds.height());
}
