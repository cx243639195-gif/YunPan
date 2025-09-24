import QtQuick 2.15
import QtQuick.Controls 2.15
import "." as Custom
import "PrimaryButtonLogic.js" as Logic

Button {
    id: control

    property string textKey: "buttons.primary.default"
    property bool busy: false

    readonly property var themePalette: Custom.ThemeManager.palette

    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding
    implicitWidth: Math.max(background.implicitWidth, contentItem.implicitWidth + leftPadding + rightPadding)

    leftPadding: Logic.horizontalPadding()
    rightPadding: Logic.horizontalPadding()
    topPadding: Logic.verticalPadding()
    bottomPadding: Logic.verticalPadding()

    enabled: !control.busy
    focusPolicy: Qt.StrongFocus
    opacity: Logic.opacity(control)

    contentItem: Row {
        id: layout
        spacing: control.busy ? 8 : 0
        anchors.centerIn: parent

        BusyIndicator {
            visible: control.busy
            running: control.busy
            implicitWidth: 16
            implicitHeight: 16
        }

        Text {
            function translatedText() {
                return Custom.I18nManager.tr(control.busy ? "buttons.primary.loading" : control.textKey,
                                              control.busy ? "Loading..." : control.textKey);
            }

            text: {
                Custom.I18nManager.revision;
                return translatedText();
            }

            font.bold: true
            color: Logic.foregroundColor(control.themePalette, control)
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.NoWrap
        }
    }

    background: Rectangle {
        id: background
        implicitWidth: 120
        implicitHeight: 36
        radius: 6
        color: Logic.backgroundColor(control.themePalette, control)
        border.color: "transparent"
    }
}
