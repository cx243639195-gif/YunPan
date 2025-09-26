import QtQuick 2.15
import QtGraphicalEffects 1.15
import "LoadingSpinnerLogic.js" as Logic

Item {
    id: spinner

    property bool running: true
    property color color: "#ffffff"
    property url source: ""
    property real playbackRate: 1.0

    implicitWidth: image.status === Image.Ready && image.sourceSize.width > 0
                   ? image.sourceSize.width : Logic.defaultDiameter()
    implicitHeight: image.status === Image.Ready && image.sourceSize.height > 0
                    ? image.sourceSize.height : Logic.defaultDiameter()

    readonly property bool _shouldPlay: running && visible && window !== null

    AnimatedImage {
        id: image
        anchors.centerIn: parent
        width: spinner.width
        height: spinner.height
        asynchronous: false
        source: spinner.source
        fillMode: Image.PreserveAspectFit
        playing: spinner._shouldPlay
        cache: true
        speed: spinner.playbackRate
        visible: false
    }

    ColorOverlay {
        anchors.fill: image
        visible: image.status === Image.Ready
        source: image
        color: spinner.color
        cached: true
    }
}
