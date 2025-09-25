import QtQuick 2.15
import "LoadingSpinnerLogic.js" as Logic

Item {
    id: spinner

    property bool running: true
    property color color: "#ffffff"
    property real minOpacity: Logic.minOpacity()
    property real strokeRatio: Logic.strokeRatio()
    property real sweepRatio: Logic.sweepRatio()
    property int segmentCount: Logic.segmentCount()
    property int stepInterval: Logic.stepInterval()

    property int _phase: 0

    implicitWidth: Logic.defaultDiameter()
    implicitHeight: Logic.defaultDiameter()
    width: implicitWidth
    height: implicitHeight

    Canvas {
        id: canvas
        anchors.fill: parent
        renderTarget: Canvas.FramebufferObject

        onPaint: {
            var count = spinner.segmentCount > 0 ? spinner.segmentCount : 1;
            var ctx = getContext("2d");
            Logic.paint(ctx, width, height, spinner.color, count, spinner._phase,
                        spinner.minOpacity, spinner.strokeRatio, spinner.sweepRatio);
        }
    }

    Timer {
        id: ticker
        interval: spinner.stepInterval
        repeat: true
        running: false

        onTriggered: {
            var count = spinner.segmentCount > 0 ? spinner.segmentCount : 1;
            spinner._phase = Logic.nextPhase(spinner._phase, count);
            canvas.requestPaint();
        }
    }

    function updateTicker() {
        ticker.running = spinner.running && spinner.visible && spinner.window !== null;
    }

    onRunningChanged: updateTicker()
    onVisibleChanged: {
        updateTicker();
        if (spinner.visible)
            canvas.requestPaint();
    }
    onWindowChanged: updateTicker()

    onWidthChanged: canvas.requestPaint()
    onHeightChanged: canvas.requestPaint()
    onColorChanged: canvas.requestPaint()
    onMinOpacityChanged: canvas.requestPaint()
    onStrokeRatioChanged: canvas.requestPaint()
    onSweepRatioChanged: canvas.requestPaint()
    onSegmentCountChanged: {
        if (spinner.segmentCount <= 0) {
            spinner._phase = 0;
        } else if (spinner._phase >= spinner.segmentCount) {
            spinner._phase = spinner._phase % spinner.segmentCount;
        }
        canvas.requestPaint();
        updateTicker();
    }

    Component.onCompleted: {
        canvas.requestPaint();
        updateTicker();
    }
}
