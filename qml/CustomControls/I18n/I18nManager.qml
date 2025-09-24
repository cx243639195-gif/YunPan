pragma Singleton
import QtQuick 2.15
import "I18nData.js" as I18nData

QtObject {
    id: i18n

    property string currentLanguage: I18nData.defaultLanguage()
    property int revision: 0
    property var _translationCache: Object.create(null)

    signal languageChanged(string language)

    function availableLanguages() {
        return I18nData.languageCodes();
    }

    function setLanguage(language) {
        if (!I18nData.hasLanguage(language)) {
            console.warn("I18nManager: unknown language", language);
            return;
        }
        if (language === currentLanguage)
            return;

        currentLanguage = language;
    }

    function toggleLanguage() {
        var langs = availableLanguages();
        if (langs.length < 2)
            return;
        var index = langs.indexOf(currentLanguage);
        var nextIndex = (index + 1) % langs.length;
        setLanguage(langs[nextIndex]);
    }

    function tr(key, fallback) {
        var cacheKey = key + "|" + (fallback !== undefined ? fallback : "");
        var cached = _translationCache[cacheKey];
        if (cached !== undefined)
            return cached;

        var value = I18nData.translate(currentLanguage, key, fallback);
        _translationCache[cacheKey] = value;
        return value;
    }

    onCurrentLanguageChanged: {
        _translationCache = Object.create(null);
        revision += 1;
        languageChanged(currentLanguage);
    }
}
