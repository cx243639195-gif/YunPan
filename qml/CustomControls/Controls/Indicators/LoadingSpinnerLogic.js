.pragma library

var TWO_PI = Math.PI * 2;

function defaultDiameter() {
    return 16;
}

function strokeRatio() {
    return 0.18;
}

function sweepRatio() {
    return 0.65;
}

function segmentCount() {
    return 12;
}

function stepInterval() {
    return 90;
}

function minOpacity() {
    return 0.25;
}

function nextPhase(current, count) {
    if (count <= 0)
        return 0;
    return (current + 1) % count;
}

function opacityFor(offset, baseOpacity) {
    var falloff = 0.65;
    var clampedBase = Math.max(0.0, Math.min(baseOpacity, 1.0));
    return clampedBase + (1.0 - clampedBase) * Math.pow(falloff, offset);
}

function paint(ctx, width, height, color, count, phase, baseOpacity, strokeRatio, sweepRatio) {
    if (!ctx)
        return;

    ctx.resetTransform();
    ctx.clearRect(0, 0, width, height);

    var size = Math.min(width, height);
    if (size <= 0 || count <= 0)
        return;

    var stroke = Math.max(1, Math.round(size * strokeRatio));
    var radius = Math.max(0, (size - stroke) / 2);
    var stepAngle = TWO_PI / count;
    var sweep = stepAngle * sweepRatio;

    ctx.save();
    ctx.translate(width / 2, height / 2);
    ctx.lineWidth = stroke;
    ctx.lineCap = "round";
    ctx.strokeStyle = color;

    for (var i = 0; i < count; ++i) {
        var offset = i - phase;
        while (offset < 0)
            offset += count;

        ctx.globalAlpha = opacityFor(offset, baseOpacity);
        ctx.beginPath();
        var startAngle = i * stepAngle;
        ctx.arc(0, 0, radius, startAngle, startAngle + sweep, false);
        ctx.stroke();
    }

    ctx.restore();
    ctx.globalAlpha = 1.0;
}
