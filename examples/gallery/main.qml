import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import CustomControls 1.0 as Custom

ApplicationWindow {
    id: window
    visible: true
    width: 480
    height: 320

    title: {
        Custom.I18nManager.revision;
        return Custom.I18nManager.tr("labels.headline", "Custom Controls Library");
    }

    color: {
        Custom.ThemeManager.revision;
        return Custom.ThemeManager.token("surface.background");
    }

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
                text: {
                    Custom.I18nManager.revision;
                    return Custom.I18nManager.tr("actions.toggleTheme", "Toggle theme");
                }
                onClicked: Custom.ThemeManager.toggleTheme()
            }

            Button {
                text: {
                    Custom.I18nManager.revision;
                    return Custom.I18nManager.tr("actions.toggleLanguage", "Switch language");
                }
                onClicked: Custom.I18nManager.toggleLanguage()
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 12
            color: {
                Custom.ThemeManager.revision;
                return Custom.ThemeManager.token("surface.backgroundRaised");
            }
            border.color: {
                Custom.ThemeManager.revision;
                return Custom.ThemeManager.token("surface.border");
            }

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
