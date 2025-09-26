import QtQuick 2.15
import "../.." as Custom
import "TitleLabelLogic.js" as Logic

Text {
    id: control

    property string textKey: "labels.headline"
    property int languageRevision: Custom.I18nManager.revision
    property int themeRevision: Custom.ThemeManager.revision
    property var themePalette: Custom.ThemeManager.palette
    property string displayText: {
        languageRevision;
        return Custom.I18nManager.tr(control.textKey, Logic.defaultText(control.textKey));
    }
    property color displayColor: {
        themeRevision;
        return Logic.color(themePalette);
    }

    text: displayText

    color: displayColor
    font.pixelSize: Logic.fontSize()
    font.weight: Logic.fontWeight()
    wrapMode: Text.WrapAnywhere
    horizontalAlignment: Text.AlignHCenter
}
