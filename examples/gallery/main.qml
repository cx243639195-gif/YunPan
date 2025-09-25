import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import CustomControls 1.0 as Custom
import "Translations.js" as GalleryStrings

ApplicationWindow {
    id: window
    visible: true
    width: 480
    height: 320

    readonly property bool _stringsLoaded: GalleryStrings !== undefined
    property int languageRevision: Custom.I18nManager.revision
    property int themeRevision: Custom.ThemeManager.revision
    property string windowTitle: {
        languageRevision;
        return Custom.I18nManager.tr("labels.headline", "Custom Controls Library");
    }
    property color windowBackground: {
        themeRevision;
        return Custom.ThemeManager.token("surface.background");
    }
    property color panelBackground: {
        themeRevision;
        return Custom.ThemeManager.token("surface.backgroundRaised");
    }
    property color panelBorder: {
        themeRevision;
        return Custom.ThemeManager.token("surface.border");
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
                text: {
                    window.languageRevision;
                    return Custom.I18nManager.tr("actions.toggleTheme", "Toggle theme");
                }
                onClicked: Custom.ThemeManager.toggleTheme()
            }

            Button {
                id: toggleLanguageButton
                text: {
                    window.languageRevision;
                    return Custom.I18nManager.tr("actions.toggleLanguage", "Switch language");
                }
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
                    busyTextKey: "buttons.secondary.loading"
                    busy: true
                }
            }
        }
    }
}
