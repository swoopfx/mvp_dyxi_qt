#include "tracabletext.h"

#include <QPainter>
#include <QDebug>

TracableText::TracableText(QQuickItem *parent)
    : QQuickPaintedItem(parent),
      m_penColor(Qt::black),
      m_penStyle(Qt::DotLine),
      m_penWidth(1.0),
      m_traceColor(Qt::red)
{
    // Set a default font
    m_font.setPointSize(24);
    m_font.setBold(true);
    setFlag(ItemHasContents, true);
}

void TracableText::paint(QPainter *painter)
{
    if (m_text.isEmpty()) {
        return;
    }

    painter->setRenderHint(QPainter::Antialiasing);

    // Draw the tracable text outline
    QPen outlinePen(m_penColor, m_penWidth, m_penStyle);
    painter->setPen(outlinePen);
    painter->setBrush(Qt::NoBrush); // Transparent brush for the outline

    QFontMetricsF fm(m_font);
    qreal textWidth = fm.horizontalAdvance(m_text);
    qreal textHeight = fm.height();

    QPainterPath textPath;
    textPath.addText(0, textHeight, m_font, m_text);

    // Center the text within the item's bounds
    qreal xOffset = (width() - textWidth) / 2;
    qreal yOffset = (height() - textHeight) / 2 - fm.descent(); // Adjust for baseline

    painter->save();
    painter->translate(xOffset, yOffset);
    painter->drawPath(textPath);
    painter->restore();

    // Draw the traced paths
    QPen tracePen(m_traceColor, m_penWidth * 1.5, Qt::SolidLine, Qt::RoundCap, Qt::RoundJoin);
    painter->setPen(tracePen);
    painter->setBrush(Qt::NoBrush);

    for (const QPainterPath &path : m_tracePaths) {
        painter->drawPath(path);
    }
    painter->drawPath(m_currentTracePath);
}

void TracableText::setText(const QString &text)
{
    if (m_text == text)
        return;

    m_text = text;
    clearTrace(); // Clear trace when text changes
    emit textChanged();
    update(); // Request a repaint
}

void TracableText::setFont(const QFont &font)
{
    if (m_font == font)
        return;

    m_font = font;
    emit fontChanged();
    update(); // Request a repaint
}

void TracableText::setPenColor(const QColor &color)
{
    if (m_penColor == color)
        return;

    m_penColor = color;
    emit penColorChanged();
    update(); // Request a repaint
}

void TracableText::setPenStyle(Qt::PenStyle style)
{
    if (m_penStyle == style)
        return;

    m_penStyle = style;
    emit penStyleChanged();
    update(); // Request a repaint
}

void TracableText::setPenWidth(qreal width)
{
    if (m_penWidth == width)
        return;

    m_penWidth = width;
    emit penWidthChanged();
    update(); // Request a repaint
}

void TracableText::setTraceColor(const QColor &color)
{
    if (m_traceColor == color)
        return;

    m_traceColor = color;
    emit traceColorChanged();
}

void TracableText::addTracePoint(qreal x, qreal y)
{
    if (m_currentTracePath.isEmpty()) {
        m_currentTracePath.moveTo(x, y);
    } else {
        m_currentTracePath.lineTo(x, y);
    }
    update();
}

void TracableText::startNewTracePath(qreal x, qreal y)
{
    if (!m_currentTracePath.isEmpty()) {
        m_tracePaths.append(m_currentTracePath);
    }
    m_currentTracePath = QPainterPath();
    m_currentTracePath.moveTo(x, y);
    update();
}

void TracableText::clearTrace()
{
    m_tracePaths.clear();
    m_currentTracePath = QPainterPath();
    update();
}
