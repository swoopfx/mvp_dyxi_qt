#include "tracabletext.h"

#include <QPainter>
#include <QDebug>

TracableText::TracableText(QQuickItem *parent)
    : QQuickPaintedItem(parent),
      m_penColor(Qt::black),
      m_penStyle(Qt::DotLine),
      m_penWidth(1.0)
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

    QPen pen(m_penColor, m_penWidth, m_penStyle);
    painter->setPen(pen);
    painter->setBrush(Qt::NoBrush); // Transparent brush

    QFontMetricsF fm(m_font);
    qreal textWidth = fm.horizontalAdvance(m_text);
    qreal textHeight = fm.height();

    QPainterPath path;
    path.addText(0, textHeight, m_font, m_text);

    // Center the text within the item's bounds
    qreal xOffset = (width() - textWidth) / 2;
    qreal yOffset = (height() - textHeight) / 2 - fm.descent(); // Adjust for baseline

    painter->translate(xOffset, yOffset);
    painter->drawPath(path);
}

void TracableText::setText(const QString &text)
{
    if (m_text == text)
        return;

    m_text = text;
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
