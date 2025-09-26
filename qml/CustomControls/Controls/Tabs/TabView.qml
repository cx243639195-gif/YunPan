import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../.." as Custom
import "TabViewLogic.js" as Logic

Item {
    id: control

    property var tabs: []
    property int currentIndex: 0
    readonly property int tabCount: Logic.tabCount(control.tabs)
    readonly property string currentTitle: currentIndex >= 0 ? Logic.tabTitle(control.tabs, currentIndex) : ""
    property alias currentItem: contentLoader.item

    property int themeRevision: Custom.ThemeManager.revision
    property var themePalette: Custom.ThemeManager.palette

    property color backgroundColor: {
        themeRevision;
        return Custom.ThemeManager.token("surface.backgroundRaised");
    }
    property color borderColor: {
        themeRevision;
        return Custom.ThemeManager.token("surface.border");
    }
    property color activeTabForegroundColor: {
        themeRevision;
        return Custom.ThemeManager.token("primary.foreground");
    }
    property color inactiveTabForegroundColor: {
        themeRevision;
        return Custom.ThemeManager.token("surface.subtle");
    }
    property color indicatorColor: {
        themeRevision;
        return Custom.ThemeManager.token("primary.background");
    }
    property color inactiveTabBackgroundColor: "transparent"

    property real leftPadding: 16
    property real rightPadding: 16
    property real topPadding: 16
    property real bottomPadding: 16
    property real tabSpacing: 8
    property real tabBarHeight: 40
    property real contentSpacing: 16

    signal tabActivated(int index)

    implicitWidth: Math.max(320, leftPadding + rightPadding + tabRow.implicitWidth)
    implicitHeight: Math.max(200, topPadding + bottomPadding + tabBar.height + contentArea.implicitHeight)

    property var _currentContent: ({ component: null, source: "" })
    property bool _initialized: false

    function updateContent() {
        var clamped = Logic.clampIndex(control.currentIndex, control.tabCount);
        if (clamped !== control.currentIndex) {
            control.currentIndex = clamped;
            return;
        }

        if (clamped < 0) {
            _currentContent = { component: null, source: "" };
            return;
        }

        _currentContent = Logic.contentDefinition(control.tabs, clamped);
    }

    onTabsChanged: updateContent()
    onTabCountChanged: updateContent()
    onCurrentIndexChanged: {
        var clamped = Logic.clampIndex(control.currentIndex, control.tabCount);
        if (clamped !== control.currentIndex) {
            control.currentIndex = clamped;
            return;
        }
        updateContent();
        if (_initialized && clamped >= 0)
            control.tabActivated(clamped);
    }

    Component.onCompleted: {
        _initialized = true;
        updateContent();
        if (control.tabCount > 0 && control.currentIndex >= 0)
            control.tabActivated(control.currentIndex);
    }

    Rectangle {
        id: frame
        anchors.fill: parent
        radius: 8
        color: control.backgroundColor
        border.color: control.borderColor
        border.width: 1
    }

    Column {
        id: layout
        anchors {
            fill: parent
            leftMargin: control.leftPadding
            rightMargin: control.rightPadding
            topMargin: control.topPadding
            bottomMargin: control.bottomPadding
        }
        spacing: control.contentSpacing

        Item {
            id: tabBar
            width: parent.width
            height: control.tabBarHeight

            Row {
                id: tabRow
                anchors.fill: parent
                anchors.bottomMargin: 3
                spacing: control.tabSpacing
                clip: false

                Repeater {
                    id: tabRepeater
                    model: control.tabCount

                    delegate: Button {
                        id: tabButton
                        required property int index

                        text: Logic.tabTitle(control.tabs, index)
                        enabled: Logic.tabEnabled(control.tabs, index)
                        implicitHeight: tabBar.height - 3
                        implicitWidth: Math.max(textMetrics.width + 24, 72)
                        padding: 12
                        hoverEnabled: true
                        focusPolicy: Qt.TabFocus
                        onClicked: control.currentIndex = index

                        contentItem: Text {
                            id: label
                            text: tabButton.text
                            color: tabButton.enabled && control.currentIndex === index
                                   ? control.activeTabForegroundColor
                                   : control.inactiveTabForegroundColor
                            font.bold: control.currentIndex === index
                            elide: Text.ElideRight
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            anchors.fill: parent
                            anchors.leftMargin: 0
                            anchors.rightMargin: 0
                        }

                        background: Rectangle {
                            radius: 6
                            color: control.currentIndex === index
                                   ? control.indicatorColor
                                   : control.inactiveTabBackgroundColor
                            opacity: tabButton.enabled ? 1.0 : 0.5
                        }

                        Keys.onLeftPressed: {
                            if (control.currentIndex > 0) {
                                control.currentIndex = control.currentIndex - 1;
                                event.accepted = true;
                            }
                        }

                        Keys.onRightPressed: {
                            if (control.currentIndex < control.tabCount - 1) {
                                control.currentIndex = control.currentIndex + 1;
                                event.accepted = true;
                            }
                        }

                        Accessible.role: Accessible.PageTab
                        Accessible.name: tabButton.text

                        TextMetrics {
                            id: textMetrics
                            text: tabButton.text
                            font: label.font
                        }
                    }
                }
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 3
                color: control.borderColor
                opacity: 0.5
            }

            Rectangle {
                id: indicator
                anchors.bottom: parent.bottom
                height: 3
                width: {
                    var item = tabRepeater.itemAt(control.currentIndex);
                    return item ? item.width : 0;
                }
                x: {
                    var item = tabRepeater.itemAt(control.currentIndex);
                    return item ? item.x : 0;
                }
                visible: control.tabCount > 0 && width > 0
                color: control.indicatorColor
                radius: height / 2
            }
        }

        Item {
            id: contentArea
            width: parent.width
            implicitHeight: contentLoader.item && contentLoader.item.implicitHeight ? contentLoader.item.implicitHeight : 0

            Loader {
                id: contentLoader
                anchors.fill: parent
                active: control.tabCount > 0 && control._currentContent
                        && (control._currentContent.component || (control._currentContent.source && control._currentContent.source !== ""))
                sourceComponent: control._currentContent.component
                source: control._currentContent.source
            }
        }
    }
}
