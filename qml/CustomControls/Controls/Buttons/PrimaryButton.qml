import QtQuick 2.15
import QtQuick.Controls 2.15
import "." as Custom
import "PrimaryButtonLogic.js" as Logic

Button {
    id: control

    property string textKey: "buttons.primary.default"
    property bool busy: false

    property var themePalette: Custom.ThemeManager.palette
    property string displayText: Custom.I18nManager.tr(control.textKey, control.textKey)
    property color backgroundColor: "#000000"
    property color foregroundColor: "#ffffff"
    property real resolvedOpacity: 1.0

    function updateDisplayText() {
        displayText = Custom.I18nManager.tr(control.busy ? "buttons.primary.loading" : control.textKey,
                                            control.busy ? "Loading..." : control.textKey);
    }

    function updateColors() {
        backgroundColor = Logic.backgroundColor(control.themePalette, control);
        foregroundColor = Logic.foregroundColor(control.themePalette, control);
    }

    function updateOpacity() {
        resolvedOpacity = Logic.opacity(control);
    }

    function refreshVisualState() {
        updateColors();
        updateOpacity();
    }

    Component.onCompleted: {
        updateDisplayText();
        refreshVisualState();
    }

    onBusyChanged: {
        updateDisplayText();
        refreshVisualState();
    }

    onTextKeyChanged: updateDisplayText()
    onHoveredChanged: updateColors()
    onDownChanged: updateColors()
    onEnabledChanged: updateOpacity()
    onThemePaletteChanged: updateColors()

    Connections {
        target: Custom.I18nManager
        onLanguageChanged: updateDisplayText()
    }

    Connections {
        target: Custom.ThemeManager
        onThemeChanged: updateColors()
    }

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
        spacing: control.busy ? 8 : 0
        anchors.centerIn: parent

        BusyIndicator {
            visible: control.busy
            running: control.busy
            implicitWidth: 16
            implicitHeight: 16
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
