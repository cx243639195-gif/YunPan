import QtQuick 2.15
import "." as Custom
import "TitleLabelLogic.js" as Logic

Text {
    id: control

    property string textKey: "labels.headline"
    property var themePalette: Custom.ThemeManager.palette
    property string displayText: Custom.I18nManager.tr(control.textKey, control.textKey)
    property color displayColor: Logic.color(themePalette)

    function updateText() {
        displayText = Custom.I18nManager.tr(control.textKey, control.textKey);
    }

    function updateColor() {
        displayColor = Logic.color(themePalette);
    }

    Component.onCompleted: {
        updateText();
        updateColor();
    }

    onTextKeyChanged: updateText()
    onThemePaletteChanged: updateColor()

    Connections {
        target: Custom.I18nManager
        onLanguageChanged: updateText()
    }

    Connections {
        target: Custom.ThemeManager
        onThemeChanged: updateColor()
    }

    text: displayText

    color: displayColor
    font.pixelSize: Logic.fontSize()
    font.weight: Logic.fontWeight()
    wrapMode: Text.WrapAnywhere
    horizontalAlignment: Text.AlignHCenter
}
