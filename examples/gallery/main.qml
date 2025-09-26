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

    ListModel {
        id: accountTableModel

        ListElement { name: "Alice"; email: "alice@example.com"; storage: "15 GB"; status: "Active" }
        ListElement { name: "Bob"; email: "bob@example.com"; storage: "8 GB"; status: "Invited" }
        ListElement { name: "Charlie"; email: "charlie@example.com"; storage: "24 GB"; status: "Active" }
        ListElement { name: "Diana"; email: "diana@example.com"; storage: "4 GB"; status: "Suspended" }
        ListElement { name: "Evelyn"; email: "evelyn@example.com"; storage: "32 GB"; status: "Active" }
    }

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

            Component {
                id: actionsTab

                Item {
                    anchors.fill: parent

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 12

                        RowLayout {
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 12

                            Custom.PrimaryButton {
                                Layout.alignment: Qt.AlignHCenter
                                textKey: "buttons.primary.default"
                            }

                            Custom.PrimaryButton {
                                Layout.alignment: Qt.AlignHCenter
                                textKey: "buttons.secondary.default"
                                busyTextKey: "buttons.secondary.loading"
                                busy: true
                            }
                        }
                    }
                }
            }

            Component {
                id: accountsTab

                Item {
                    anchors.fill: parent

                    Custom.ExpandableTable {
                        anchors.fill: parent
                        model: accountTableModel
                        alternatingRowColors: true
                        columns: [
                            { title: qsTr("Name"), role: "name", flex: 2 },
                            { title: qsTr("Email"), role: "email", flex: 3 },
                            { title: qsTr("Storage"), role: "storage", alignment: "right", flex: 1 },
                            { title: qsTr("Status"), role: "status", flex: 1 }
                        ]
                    }
                }
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 16

                Custom.TabView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    tabs: [
                        { title: qsTr("Actions"), component: actionsTab },
                        { title: qsTr("Accounts"), component: accountsTab }
                    ]
                }
            }
        }
    }
}
