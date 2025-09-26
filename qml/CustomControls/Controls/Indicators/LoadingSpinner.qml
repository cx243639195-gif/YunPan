import QtQuick 2.15
import QtQuick.Shapes 1.15
import QtGraphicalEffects 1.15
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
    readonly property real _baseRotation: -90
    readonly property real _startAngle: -sweepAngle / 2
    readonly property real _startRadians: _startAngle * Math.PI / 180
    readonly property bool _hasArc: _radius > 0 && _strokeWidth > 0

    width: implicitWidth
    height: implicitHeight

    antialiasing: true

    transform: Rotation {
        id: spinTransform
        origin.x: spinner.width / 2
        origin.y: spinner.height / 2
        angle: spinner._baseRotation
    }

    Shape {
        id: arcShape
        anchors.fill: parent
        visible: spinner._hasArc
        smooth: true
        opacity: 1.0

        ShapePath {
            strokeWidth: spinner._strokeWidth
            strokeColor: spinner.color
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            fillColor: "transparent"
            startX: spinner.width / 2 + spinner._radius * Math.cos(spinner._startRadians)
            startY: spinner.height / 2 + spinner._radius * Math.sin(spinner._startRadians)

            PathAngleArc {
                centerX: spinner.width / 2
                centerY: spinner.height / 2
                radiusX: spinner._radius
                radiusY: spinner._radius
                startAngle: spinner._startAngle
                sweepAngle: spinner.sweepAngle
            }
        }
    }

    ColorOverlay {
        id: colorOverlay
        anchors.fill: parent
        source: arcShape
        color: spinner.color
        cached: false
        visible: spinner._hasArc
        opacity: 1.0
    }

    RotationAnimator {
        id: spinAnimation
        target: spinTransform
        from: spinner._baseRotation
        to: spinner._baseRotation + 360
        duration: spinner.rotationDuration
        loops: Animation.Infinite
        running: false
    }

    SequentialAnimation {
        id: pulseAnimation
        loops: Animation.Infinite
        running: false

        OpacityAnimator {
            target: colorOverlay
            to: spinner.minOpacity
            duration: spinner.pulseDuration / 2
            easing.type: Easing.InOutQuad
        }
        OpacityAnimator {
            target: colorOverlay
            to: 1.0
            duration: spinner.pulseDuration / 2
            easing.type: Easing.InOutQuad
        }
    }

    function updateAnimations() {
        var shouldRun = spinner._active;
        if (shouldRun && !spinAnimation.running)
            spinTransform.angle = spinner._baseRotation;
        spinAnimation.running = shouldRun;
        pulseAnimation.running = shouldRun;
        if (!shouldRun) {
            spinTransform.angle = spinner._baseRotation;
            colorOverlay.opacity = 1.0;
        }
    }

    onRunningChanged: updateAnimations()
    onVisibleChanged: updateAnimations()
    onWindowChanged: updateAnimations()

    Component.onCompleted: {
        spinTransform.angle = spinner._baseRotation;
        updateAnimations();
    }
}
