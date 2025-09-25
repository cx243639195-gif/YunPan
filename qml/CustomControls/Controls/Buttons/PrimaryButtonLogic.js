.pragma library
.import "../../I18n/I18nData.js" as I18nData

I18nData.registerTranslations("en", {
    buttons: {
        primary: {
            default: "Confirm",
            loading: "Loading..."
        },
        secondary: {
            default: "Cancel",
            loading: "Working..."
        }
    }
});

I18nData.registerTranslations("zh_CN", {
    buttons: {
        primary: {
            default: "确认",
            loading: "加载中..."
        },
        secondary: {
            default: "取消",
            loading: "处理中..."
        }
    }
});

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

function defaultBusyKey() {
    return "buttons.primary.loading";
}

function busyFallback() {
    return I18nData.translate(I18nData.defaultLanguage(), defaultBusyKey(), "Loading...");
}

function defaultTextFallback(key) {
    return I18nData.translate(I18nData.defaultLanguage(), key, key);
}

function displayText(i18nManager, revision, textKey, textFallback, busy, busyKey, busyFallbackText) {
    var fallback = busy
            ? (busyFallbackText || busyKey || textFallback || textKey)
            : (textFallback || textKey);

    if (!i18nManager)
        return fallback;

    void revision;

    var lookupKey = busy && busyKey ? busyKey : textKey;
    return i18nManager.tr(lookupKey, fallback);
}

function horizontalPadding() { return 20; }
function verticalPadding() { return 10; }
