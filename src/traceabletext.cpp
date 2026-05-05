#include "traceabletext.h"
#include <QPainter>
#include <QPainterPathStroker>

TraceableText::TraceableText(QQuickItem *parent)
    : QQuickPaintedItem(parent)
{
    setRenderTarget(RenderTarget::FramebufferObject);
    setAntialiasing(true);
}

QString TraceableText::text() const { return m_text; }
QFont TraceableText::font() const { return m_font; }
QColor TraceableText::penColor() const { return m_penColor; }
Qt::PenStyle TraceableText::penStyle() const { return m_penStyle; }
qreal TraceableText::penWidth() const { return m_penWidth; }
QColor TraceableText::traceColor() const { return m_traceColor; }

void TraceableText::setText(const QString &text)
{
    if (m_text != text) {
        m_text = text;
        updateTextPath();
        emit textChanged();
    }
}

void TraceableText::setFont(const QFont &font)
{
    if (m_font != font) {
        m_font = font;
        updateTextPath();
        emit fontChanged();
    }
}

void TraceableText::setPenColor(const QColor &color)
{
    if (m_penColor != color) {
        m_penColor = color;
        emit penColorChanged();
    }
}

void TraceableText::setPenStyle(Qt::PenStyle style)
{
    if (m_penStyle != style) {
        m_penStyle = style;
        emit penStyleChanged();
    }
}

void TraceableText::setPenWidth(qreal width)
{
    if (m_penWidth != width) {
        m_penWidth = width;
        emit penWidthChanged();
    }
}

void TraceableText::setTraceColor(const QColor &color)
{
    if (m_traceColor != color) {
        m_traceColor = color;
        emit traceColorChanged();
    }
}

void TraceableText::updateTextPath()
{
    m_textPath = QPainterPath();
    // Center the text in the item
    QRectF itemRect(0, 0, width(), height());
    QFontMetrics fm(m_font);
    QRectF textRect = fm.boundingRect(m_text).translated(-fm.boundingRect(m_text).topLeft());
    QPointF baseline(
        (itemRect.width() - textRect.width()) / 2,
        (itemRect.height() + textRect.height()) / 2
        );
    m_textPath.addText(baseline, m_font, m_text);
    update();
}

void TraceableText::paint(QPainter *painter)
{
    painter->setRenderHint(QPainter::Antialiasing);

    // 1. Draw outline (dashed/dotted)
    QPen pen(m_penColor, m_penWidth, m_penStyle, Qt::RoundCap, Qt::RoundJoin);
    painter->setPen(pen);
    painter->setBrush(Qt::NoBrush);   // Only outline
    painter->drawPath(m_textPath);

    // 2. Draw “traced” paint on top
    if (!m_tracePath.isEmpty()) {
        QPen tracePen(m_traceColor, m_penWidth, Qt::SolidLine, Qt::RoundCap, Qt::RoundJoin);
        painter->setPen(tracePen);
        painter->setBrush(Qt::NoBrush);
        painter->drawPath(m_tracePath);
    }
}

// Connect to mouse events (add this in your main item or a wrapper)
void TraceableText::mousePressEvent(QMouseEvent *event)
{
    m_tracePath = QPainterPath();
    m_tracePath.moveTo(event->pos());
    update();
}

void TraceableText::mouseMoveEvent(QMouseEvent *event)
{
    if (event->buttons() & Qt::LeftButton) {
        m_tracePath.lineTo(event->pos());
        update();
    }
}

void TraceableText::mouseReleaseEvent(QMouseEvent *event)
{
    Q_UNUSED(event);
    // Optionally reset or keep trace depending on your UX
}