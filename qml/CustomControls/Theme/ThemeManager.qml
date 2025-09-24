pragma Singleton
import QtQuick 2.15
import "ThemeData.js" as ThemeData

QtObject {
    id: themeManager

    property string currentTheme: ThemeData.defaultTheme()
    property var palette: ThemeData.theme(currentTheme)

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
        return ThemeData.resolveToken(palette, path);
    }

    onCurrentThemeChanged: themeChanged(currentTheme)
}
