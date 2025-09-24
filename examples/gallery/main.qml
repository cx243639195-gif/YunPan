import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import CustomControls 1.0 as Custom

ApplicationWindow {
    id: window
    visible: true
    width: 480
    height: 320

    property string windowTitle: Custom.I18nManager.tr("labels.headline", "Custom Controls Library")
    property color windowBackground: Custom.ThemeManager.token("surface.background")
    property color panelBackground: Custom.ThemeManager.token("surface.backgroundRaised")
    property color panelBorder: Custom.ThemeManager.token("surface.border")

    function updateTitle() {
        windowTitle = Custom.I18nManager.tr("labels.headline", "Custom Controls Library");
    }

    function updateThemeColors() {
        windowBackground = Custom.ThemeManager.token("surface.background");
        panelBackground = Custom.ThemeManager.token("surface.backgroundRaised");
        panelBorder = Custom.ThemeManager.token("surface.border");
    }

    Component.onCompleted: {
        updateTitle();
        updateThemeColors();
    }

    Connections {
        target: Custom.I18nManager
        onLanguageChanged: updateTitle()
    }

    Connections {
        target: Custom.ThemeManager
        onThemeChanged: updateThemeColors()
    }

    title: windowTitle

    color: windowBackground

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 16

        Custom.TitleLabel {
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignLeft
        }

        RowLayout {
            spacing: 12

            Button {
                id: toggleThemeButton
                property string cachedText: Custom.I18nManager.tr("actions.toggleTheme", "Toggle theme")

                function updateText() {
                    cachedText = Custom.I18nManager.tr("actions.toggleTheme", "Toggle theme");
                }

                Component.onCompleted: updateText()

                Connections {
                    target: Custom.I18nManager
                    onLanguageChanged: updateText()
                }

                text: cachedText
                onClicked: Custom.ThemeManager.toggleTheme()
            }

            Button {
                id: toggleLanguageButton
                property string cachedText: Custom.I18nManager.tr("actions.toggleLanguage", "Switch language")

                function updateText() {
                    cachedText = Custom.I18nManager.tr("actions.toggleLanguage", "Switch language");
                }

                Component.onCompleted: updateText()

                Connections {
                    target: Custom.I18nManager
                    onLanguageChanged: updateText()
                }

                text: cachedText
                onClicked: Custom.I18nManager.toggleLanguage()
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 12
            color: window.panelBackground
            border.color: window.panelBorder

            Column {
                anchors.centerIn: parent
                spacing: 12

                Custom.PrimaryButton {
                    textKey: "buttons.primary.default"
                }

                Custom.PrimaryButton {
                    textKey: "buttons.secondary.default"
                    busy: true
                }
            }
        }
    }
}
