import QtQuick 2.15
import "." as Custom
import "TitleLabelLogic.js" as Logic

Text {
    id: control

    property string textKey: "labels.headline"

    readonly property var themePalette: Custom.ThemeManager.palette

    text: {
        Custom.I18nManager.currentLanguage;
        return Custom.I18nManager.tr(control.textKey, control.textKey);
    }

    color: Logic.color(themePalette)
    font.pixelSize: Logic.fontSize()
    font.weight: Logic.fontWeight()
    wrapMode: Text.WrapAnywhere
    horizontalAlignment: Text.AlignHCenter
}
