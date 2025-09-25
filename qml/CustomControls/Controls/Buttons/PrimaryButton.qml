import QtQuick 2.15
import QtQuick.Controls 2.15
import "../.." as Custom
import "PrimaryButtonLogic.js" as Logic

Button {
    id: control

    property string textKey: "buttons.primary.default"
    property string textFallback: Logic.defaultTextFallback(control.textKey)
    property bool busy: false
    property string busyTextKey: Logic.defaultBusyKey()
    property string busyTextFallback: Logic.busyFallback()
    property int busyIndicatorSize: 16

    property int languageRevision: Custom.I18nManager.revision
    property int themeRevision: Custom.ThemeManager.revision
    property var themePalette: Custom.ThemeManager.palette
    property var colorRoles: {
        themeRevision;
        return Logic.colorSet(themePalette);
    }
    property string displayText: Logic.displayText(Custom.I18nManager, languageRevision,
                                                  control.textKey, control.textFallback,
                                                  control.busy, control.busyTextKey,
                                                  control.busyTextFallback)
    property color backgroundColor: Logic.backgroundColor(colorRoles, control.hovered,
                                                          control.down, control.enabled)
    property color foregroundColor: Logic.foregroundColor(colorRoles, control.enabled)
    property real resolvedOpacity: Logic.opacity(control.enabled)

    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding
    implicitWidth: Math.max(background.implicitWidth, contentItem.implicitWidth + leftPadding + rightPadding)

    leftPadding: Logic.horizontalPadding()
    rightPadding: Logic.horizontalPadding()
    topPadding: Logic.verticalPadding()
    bottomPadding: Logic.verticalPadding()

    enabled: !control.busy
    focusPolicy: Qt.StrongFocus
    opacity: control.resolvedOpacity

    contentItem: Row {
        id: layout
        anchors.centerIn: parent
        spacing: busySpinnerLoader.active ? 8 : 0

        Loader {
            id: busySpinnerLoader
            active: control.busy
            asynchronous: true

            width: active ? control.busyIndicatorSize : 0
            height: active ? control.busyIndicatorSize : 0
            implicitWidth: width
            implicitHeight: height

            sourceComponent: Custom.LoadingSpinner {
                anchors.centerIn: parent
                running: control.busy
                color: control.foregroundColor
                implicitWidth: control.busyIndicatorSize
                implicitHeight: control.busyIndicatorSize
                width: implicitWidth
                height: implicitHeight
            }
        }

        Text {
            text: control.displayText

            font.bold: true
            color: control.foregroundColor
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
        color: control.backgroundColor
        border.color: "transparent"
    }
}
