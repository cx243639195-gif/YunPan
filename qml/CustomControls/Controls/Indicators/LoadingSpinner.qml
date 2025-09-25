import QtQuick 2.15
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
    readonly property real _sweepRadians: sweepAngle * Math.PI / 180
    readonly property real _baseRotation: -90

    width: implicitWidth
    height: implicitHeight
    layer.enabled: true
    layer.smooth: true
    layer.mipmap: false

    Canvas {
        id: arcCanvas
        anchors.fill: parent
        antialiasing: true
        smooth: true
        renderTarget: Canvas.Image
        opacity: 1.0
        transform: Rotation {
            id: spinTransform
            origin.x: width / 2
            origin.y: height / 2
            angle: spinner._baseRotation
        }

        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            ctx.clearRect(0, 0, width, height);

            if (spinner._radius <= 0 || spinner._strokeWidth <= 0)
                return;

            ctx.translate(width / 2, height / 2);
            ctx.beginPath();
            ctx.lineWidth = spinner._strokeWidth;
            ctx.lineCap = "round";
            ctx.strokeStyle = spinner.color;

            var startAngle = -spinner._sweepRadians / 2;
            var endAngle = spinner._sweepRadians / 2;
            ctx.arc(0, 0, spinner._radius, startAngle, endAngle, false);
            ctx.stroke();
        }
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
            target: arcCanvas
            to: spinner.minOpacity
            duration: spinner.pulseDuration / 2
            easing.type: Easing.InOutQuad
        }
        OpacityAnimator {
            target: arcCanvas
            to: 1.0
            duration: spinner.pulseDuration / 2
            easing.type: Easing.InOutQuad
        }
    }

    function requestRedraw() {
        arcCanvas.requestPaint();
    }

    function updateAnimations() {
        var shouldRun = spinner._active;
        if (shouldRun && !spinAnimation.running)
            spinTransform.angle = spinner._baseRotation;
        spinAnimation.running = shouldRun;
        pulseAnimation.running = shouldRun;
        if (!shouldRun) {
            spinTransform.angle = spinner._baseRotation;
            arcCanvas.opacity = 1.0;
        }
    }

    onRunningChanged: updateAnimations()
    onVisibleChanged: updateAnimations()
    onWindowChanged: updateAnimations()
    onColorChanged: requestRedraw()
    onWidthChanged: requestRedraw()
    onHeightChanged: requestRedraw()
    onSweepAngleChanged: requestRedraw()
    onStrokeRatioChanged: requestRedraw()

    Component.onCompleted: {
        spinTransform.angle = spinner._baseRotation;
        requestRedraw();
        updateAnimations();
    }
}
