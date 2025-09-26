import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../.." as Custom
import "ExpandableTableLogic.js" as Logic

Item {
    id: control

    property var model: null
    property var columns: []
    property bool expandColumnsToFill: true
    property int rowHeight: 40
    property int headerHeight: 44
    property int visibleRowCountHint: 6
    property real cellPadding: 12
    property real columnSpacing: 12
    property bool alternatingRowColors: true

    property real leftPadding: 16
    property real rightPadding: 16
    property real topPadding: 16
    property real bottomPadding: 16

    property int themeRevision: Custom.ThemeManager.revision
    property var themePalette: Custom.ThemeManager.palette

    property color backgroundColor: Logic.surfaceBackground(themePalette)
    property color headerBackgroundColor: Logic.headerBackground(themePalette)
    property color headerForegroundColor: Logic.headerForeground(themePalette)
    property color rowForegroundColor: Logic.rowForeground(themePalette)
    property color gridColor: Logic.gridColor(themePalette)

    readonly property int columnCount: Array.isArray(columns) ? columns.length : 0
    readonly property int rowCount: Logic.rowCount(model)

    property var _computedColumnWidths: []
    property real _totalColumnWidth: 0

    implicitWidth: leftPadding + rightPadding + _totalColumnWidth
    implicitHeight: topPadding + bottomPadding + headerHeight + Math.max(visibleRowCountHint, 1) * rowHeight

    onWidthChanged: updateColumnWidths()
    onColumnsChanged: updateColumnWidths()
    onExpandColumnsToFillChanged: updateColumnWidths()
    onColumnSpacingChanged: updateColumnWidths()
    onLeftPaddingChanged: updateColumnWidths()
    onRightPaddingChanged: updateColumnWidths()

    function columnWidthAt(index) {
        if (!_computedColumnWidths || index < 0 || index >= _computedColumnWidths.length)
            return 0;
        return _computedColumnWidths[index];
    }

    function columnAlignment(index) {
        var column = columns && index >= 0 && index < columns.length ? columns[index] : null;
        var alignment = Logic.alignment(column);
        if (alignment === "center" || alignment === "middle")
            return Text.AlignHCenter;
        if (alignment === "right" || Logic.isNumericAlignment(alignment))
            return Text.AlignRight;
        return Text.AlignLeft;
    }

    function columnTitle(index) {
        return Logic.resolveColumnTitle(columns && columns[index], qsTr("Column %1").arg(index + 1));
    }

    function cellValue(rowObject, columnIndex) {
        var column = columns && columnIndex >= 0 && columnIndex < columns.length ? columns[columnIndex] : null;
        return Logic.cellValue(column, rowObject, columnIndex);
    }

    function updateColumnWidths() {
        var available = control.width > 0 ? control.width - leftPadding - rightPadding : -1;
        var recalculated = Logic.recalculateColumnWidths(available, columns, columnSpacing, expandColumnsToFill);
        _computedColumnWidths = recalculated.widths;
        _totalColumnWidth = recalculated.totalWidth;
    }

    Component.onCompleted: updateColumnWidths()

    Rectangle {
        id: frame
        anchors.fill: parent
        radius: 8
        color: control.backgroundColor
        border.color: control.gridColor
        border.width: 1
    }

    Item {
        id: contentArea
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            leftMargin: control.leftPadding
            rightMargin: control.rightPadding
            topMargin: control.topPadding
            bottomMargin: control.bottomPadding
        }

        Rectangle {
            id: header
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }
            height: control.headerHeight
            color: control.headerBackgroundColor
            border.color: "transparent"

            Row {
                id: headerRow
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                }
                spacing: control.columnSpacing

                Repeater {
                    model: control.columnCount

                    delegate: Item {
                        width: control.columnWidthAt(index)
                        height: header.height

                        Text {
                            anchors.fill: parent
                            anchors.leftMargin: control.cellPadding
                            anchors.rightMargin: control.cellPadding
                            anchors.verticalCenter: parent.verticalCenter
                            text: control.columnTitle(index)
                            color: control.headerForegroundColor
                            font.bold: true
                            elide: Text.ElideRight
                            horizontalAlignment: control.columnAlignment(index)
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 1
                color: control.gridColor
            }
        }

        Rectangle {
            id: body
            anchors {
                left: parent.left
                right: parent.right
                top: header.bottom
                bottom: parent.bottom
            }
            color: "transparent"
            clip: true

            ListView {
                id: listView
                anchors.fill: parent
                model: control.model
                spacing: 0
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                flickableDirection: Flickable.AutoFlickIfNeeded
                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                }

                delegate: Item {
                    width: Math.max(control._totalColumnWidth, 0)
                    height: control.rowHeight
                    property var rowObject: Logic.rowData(control.model, index, modelData)

                    Rectangle {
                        anchors.fill: parent
                        color: Logic.rowBackgroundForIndex(control.themePalette, index, control.alternatingRowColors)
                    }

                    Row {
                        anchors.fill: parent
                        spacing: control.columnSpacing

                        Repeater {
                            model: control.columnCount

                            delegate: Item {
                                width: control.columnWidthAt(index)
                                height: parent.height

                                Text {
                                    anchors.fill: parent
                                    anchors.leftMargin: control.cellPadding
                                    anchors.rightMargin: control.cellPadding
                                    text: control.cellValue(rowObject, index)
                                    color: control.rowForegroundColor
                                    elide: Text.ElideRight
                                    horizontalAlignment: control.columnAlignment(index)
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }
                        }
                    }

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        height: 1
                        color: control.gridColor
                    }
                }
            }
        }
    }
}
