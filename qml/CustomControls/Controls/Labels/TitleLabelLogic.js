.pragma library
.import "../../I18n/I18nData.js" as I18nData

I18nData.registerTranslations("en", {
    labels: {
        headline: "Custom Controls Library"
    }
});

I18nData.registerTranslations("zh_CN", {
    labels: {
        headline: "自定义控件库"
    }
});

function defaultText(key) {
    return I18nData.translate(I18nData.defaultLanguage(), key, key);
}

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
