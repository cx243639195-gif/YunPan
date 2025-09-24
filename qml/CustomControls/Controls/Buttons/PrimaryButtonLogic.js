.pragma library

function colorSet(palette) {
    var surface = palette && palette.surface ? palette.surface : {};
    var primary = palette && palette.primary ? palette.primary : {};

    return {
        background: primary.background || "#000000",
        hoveredBackground: primary.backgroundHovered || primary.background || "#000000",
        pressedBackground: primary.backgroundHovered || primary.background || "#000000",
        disabledBackground: surface.border || "#444444",
        foreground: primary.foreground || "#ffffff",
        disabledForeground: surface.subtle || "#ffffff"
    };
}

function backgroundColor(colors, hovered, down, enabled) {
    if (!colors)
        return "#000000";

    if (!enabled)
        return colors.disabledBackground;
    if (down)
        return colors.pressedBackground;
    if (hovered)
        return colors.hoveredBackground;
    return colors.background;
}

function foregroundColor(colors, enabled) {
    if (!colors)
        return "#ffffff";

    return enabled ? colors.foreground : colors.disabledForeground;
}

function opacity(enabled) {
    return enabled ? 1.0 : 0.7;
}

function displayText(i18nManager, revision, textKey, busy) {
    var fallback = busy ? "Loading..." : textKey;

    if (!i18nManager)
        return fallback;

    void revision;

    return busy
            ? i18nManager.tr("buttons.primary.loading", fallback)
            : i18nManager.tr(textKey, fallback);
}

function horizontalPadding() { return 20; }
function verticalPadding() { return 10; }
