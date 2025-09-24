.pragma library

function backgroundColor(palette, control) {
    if (!palette || !palette.primary)
        return "#000000";

    if (!control.enabled)
        return palette.surface.border;
    if (control.down)
        return palette.primary.backgroundHovered;
    if (control.hovered)
        return palette.primary.backgroundHovered;
    return palette.primary.background;
}

function foregroundColor(palette, control) {
    if (!palette || !palette.primary)
        return "#ffffff";

    if (!control.enabled)
        return palette.surface.subtle;
    return palette.primary.foreground;
}

function opacity(control) {
    return control.enabled ? 1.0 : 0.7;
}

function horizontalPadding() { return 20; }
function verticalPadding() { return 10; }
