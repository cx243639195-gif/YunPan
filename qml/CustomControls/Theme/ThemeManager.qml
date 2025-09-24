pragma Singleton
import QtQuick 2.15
import "ThemeData.js" as ThemeData

QtObject {
    id: themeManager

    property string currentTheme: ThemeData.defaultTheme()
    property var palette: ThemeData.theme(currentTheme)
    property int revision: 0
    property var _tokenCache: Object.create(null)

    signal themeChanged(string themeName)

    function availableThemes() {
        return ThemeData.themeNames();
    }

    function setTheme(themeName) {
        if (!ThemeData.hasTheme(themeName)) {
            console.warn("ThemeManager: unknown theme", themeName);
            return;
        }
        if (themeName === currentTheme)
            return;

        currentTheme = themeName;
    }

    function toggleTheme() {
        var names = availableThemes();
        if (names.length < 2)
            return;
        var index = names.indexOf(currentTheme);
        var nextIndex = (index + 1) % names.length;
        setTheme(names[nextIndex]);
    }

    function token(path) {
        if (!path)
            return palette;

        var cached = _tokenCache[path];
        if (cached !== undefined)
            return cached;

        var value = ThemeData.resolveToken(palette, path);
        _tokenCache[path] = value;
        return value;
    }

    onPaletteChanged: _tokenCache = Object.create(null)
    onCurrentThemeChanged: {
        _tokenCache = Object.create(null);
        revision += 1;
        themeChanged(currentTheme);
    }
}
