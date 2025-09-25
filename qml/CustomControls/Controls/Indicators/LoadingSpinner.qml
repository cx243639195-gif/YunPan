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

    width: implicitWidth
    height: implicitHeight
    transformOrigin: Item.Center
    layer.enabled: true
    layer.smooth: true
    layer.mipmap: true

    function scheduleRepaint() {
        if (arcCanvas.available)
            arcCanvas.requestPaint();
    }

    Canvas {
        id: arcCanvas
        anchors.fill: parent
        smooth: true
        opacity: 1.0
        renderTarget: Canvas.FramebufferObject

        onPaint: {
            var ctx = getContext("2d");
            ctx.save();
            ctx.clearRect(0, 0, width, height);
            ctx.translate(width / 2, height / 2);
            ctx.rotate(-Math.PI / 2);
            ctx.beginPath();
            ctx.lineWidth = spinner._strokeWidth;
            ctx.lineCap = "round";
            ctx.strokeStyle = spinner.color;
            var endAngle = Math.max(0, spinner.sweepAngle) * Math.PI / 180;
            ctx.arc(0, 0, spinner._radius, 0, endAngle, false);
            ctx.stroke();
            ctx.restore();
        }

        onAvailableChanged: scheduleRepaint()

        Connections {
            target: spinner
            function onColorChanged() { spinner.scheduleRepaint(); }
            function onWidthChanged() { spinner.scheduleRepaint(); }
            function onHeightChanged() { spinner.scheduleRepaint(); }
            function onSweepAngleChanged() { spinner.scheduleRepaint(); }
            function onStrokeRatioChanged() { spinner.scheduleRepaint(); }
        }
    }

    RotationAnimator {
        id: spinAnimation
        target: spinner
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

    function updateAnimations() {
        var shouldRun = spinner._active;
        spinAnimation.running = shouldRun;
        pulseAnimation.running = shouldRun;
        if (!shouldRun) {
            spinner.rotation = 0;
            arcCanvas.opacity = 1.0;
        }
    }

    onRunningChanged: updateAnimations()
    onVisibleChanged: updateAnimations()
    onWindowChanged: updateAnimations()
    onActiveFocusChanged: updateAnimations()

    Component.onCompleted: {
        scheduleRepaint();
        updateAnimations();
    }
}
