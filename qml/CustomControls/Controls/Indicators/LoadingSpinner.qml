import QtQuick 2.15
import QtQuick.Shapes 1.15
import "LoadingSpinnerLogic.js" as Logic

Item {
    id: spinner

    property bool running: true
    property color color: "#ffffff"
    property real minOpacity: Logic.minOpacity()
    property real strokeRatio: Logic.strokeRatio()
    property real sweepAngle: Logic.sweepAngle()
    property int rotationDuration: Logic.rotationDuration()
    property int pulseDuration: Logic.pulseDuration()

    implicitWidth: Logic.defaultDiameter()
    implicitHeight: Logic.defaultDiameter()

    readonly property bool _active: running && visible && window !== null
    readonly property real _diameter: Math.min(width, height)
    readonly property real _strokeWidth: Logic.strokeWidthFor(_diameter, strokeRatio)
    readonly property real _radius: Math.max(0, (_diameter - _strokeWidth) / 2)

    width: implicitWidth
    height: implicitHeight

    Shape {
        id: arcShape
        anchors.fill: parent
        antialiasing: true
        opacity: 1.0
        transformOrigin: Item.Center

        ShapePath {
            strokeWidth: spinner._strokeWidth
            strokeColor: spinner.color
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            startX: arcShape.width / 2 + spinner._radius
            startY: arcShape.height / 2

            PathAngleArc {
                centerX: arcShape.width / 2
                centerY: arcShape.height / 2
                radiusX: spinner._radius
                radiusY: spinner._radius
                startAngle: -90
                sweepAngle: spinner.sweepAngle
            }
        }
    }

    NumberAnimation {
        id: spinAnimation
        target: arcShape
        property: "rotation"
        from: 0
        to: 360
        duration: spinner.rotationDuration
        loops: Animation.Infinite
        running: false
    }

    SequentialAnimation {
        id: pulseAnimation
        loops: Animation.Infinite
        running: false

        PropertyAnimation {
            target: arcShape
            property: "opacity"
            to: spinner.minOpacity
            duration: spinner.pulseDuration / 2
            easing.type: Easing.InOutQuad
        }
        PropertyAnimation {
            target: arcShape
            property: "opacity"
            to: 1.0
            duration: spinner.pulseDuration / 2
            easing.type: Easing.InOutQuad
        }
    }

    function updateAnimations() {
        var shouldRun = spinner._active;
        spinAnimation.running = shouldRun;
        pulseAnimation.running = shouldRun;
        if (!shouldRun) {
            arcShape.rotation = 0;
            arcShape.opacity = 1.0;
        }
    }

    onRunningChanged: updateAnimations()
    onVisibleChanged: updateAnimations()
    onWindowChanged: updateAnimations()

    Component.onCompleted: updateAnimations()
}
