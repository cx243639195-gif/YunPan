.pragma library

function fontSize() {
    return 24;
}

function fontWeight() {
    return 600;
}

function color(palette) {
    if (!palette || !palette.surface)
        return "#000000";
    return palette.surface.foreground;
}
