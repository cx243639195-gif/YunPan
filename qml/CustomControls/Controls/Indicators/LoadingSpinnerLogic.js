.pragma library

function defaultDiameter() {
    return 16;
}

function strokeRatio() {
    return 0.18;
}

function sweepAngle() {
    return 220;
}

function rotationDuration() {
    return 900;
}

function pulseDuration() {
    return 1200;
}

function minOpacity() {
    return 0.35;
}

function strokeWidthFor(size, ratio) {
    return Math.max(1, Math.round(size * ratio));
}
