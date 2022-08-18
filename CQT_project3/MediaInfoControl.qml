import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtMultimedia 5.9

Item {
    property int pathViewMargin: 300
    property int sliderWidth: 1000
    Text {
        id: audioTitle
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        text: album_art_view.currentItem.myData.title
        color: "white"
        font.pixelSize: 36
        onTextChanged: {
            textChangeAni.targets = [audioTitle,audioSinger]
            textChangeAni.restart()
        }
    }
    Text {
        id: audioSinger
        anchors.top: audioTitle.bottom
        anchors.left: audioTitle.left
        text: album_art_view.currentItem.myData.singer
        color: "white"
        font.pixelSize: 32
    }

    NumberAnimation {
        id: textChangeAni
        property: "opacity"
        from: 0
        to: 1
        duration: 400
        easing.type: Easing.InOutQuad
    }
    Text {
        id: audioCount
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        text: album_art_view.count
        color: "white"
        font.pixelSize: 36
    }
    Image {
        anchors.top: parent.top
        anchors.topMargin: 23
        anchors.right: audioCount.left
        anchors.rightMargin: 10
        source: "Image/music.png"
    }

    Component {
        id: appDelegate
        Item {
            property variant myData: model
            width: 400; height: 400
            scale: PathView.iconScale

            Image {
                id: myIcon
                width: parent.width
                height: parent.height
                y: 20; anchors.horizontalCenter: parent.horizontalCenter
                source: albumArt

            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    album_art_view.currentIndex = index
                    player.playlist.currentIndex = index
                    player.play()
                }
            }
        }
    }

    PathView {
        id: album_art_view
        anchors.left: parent.left
//        anchors.leftMargin: 60
        anchors.leftMargin: pathViewMargin
        anchors.top: audioSinger.bottom
        anchors.topMargin: 100
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        pathItemCount: 3
        focus: true
        model: MyModel
        delegate: appDelegate
        path: Path {
            startX: 10
            startY: 50
            PathAttribute { name: "iconScale"; value: 0.28 }
            PathLine { x: 390; y: 50 }
            PathAttribute { name: "iconScale"; value: 0.56 }
            PathLine { x: 780; y: 50 }
            PathAttribute { name: "iconScale"; value: 0.28 }
        }
        onCurrentIndexChanged: {
            album_art_view.currentIndex = currentIndex
            player.playlist.currentIndex = currentIndex
        }
    }
    //Progress
    Text {
        id: currentTime
        font.bold: true
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 158
        anchors.right: progressBar.left
        anchors.rightMargin: 5
        text: utility.getTimeInfo(player.position)
        color: "white"
        font.pixelSize: 15
    }
    Slider{
        id: progressBar
//        width: 650
        width: sliderWidth
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 145
        anchors.horizontalCenter: parent.horizontalCenter
        from: 0
        to: player.duration
        value: player.position
        background: Rectangle {
            x: progressBar.leftPadding
            y: progressBar.topPadding + progressBar.availableHeight / 2 - height / 2
            implicitWidth: 200
            implicitHeight: 4
            width: progressBar.availableWidth
            height: implicitHeight
            radius: 2
            color: "gray"

            Rectangle {
                width: progressBar.visualPosition * parent.width
                height: parent.height
                color: "white"
                radius: 2
            }
        }
        handle: Image {
            anchors.verticalCenter: parent.verticalCenter
            x: progressBar.leftPadding + progressBar.visualPosition * (progressBar.availableWidth - width)
            y: progressBar.topPadding + progressBar.availableHeight / 2 - height / 2
            source: "qrc:/Image/point.png"
            Image {
                anchors.centerIn: parent
                source: "qrc:/Image/center_point.png"
            }
        }
        onMoved: {
            if (player.seekable){
                player.setPosition(value)
            }
        }
    }
    Text {
        id: totalTime
        font.bold: true
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 158
        anchors.left: progressBar.right
        anchors.leftMargin: 5
        text: utility.getTimeInfo(player.duration)
        color: "white"
        font.pixelSize: 15
    }
    //Media control
    SwitchButton {
        id: shuffer
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 60
        anchors.left: currentTime.left
        icon_off: "Image/shuffle.png"
        icon_on: "Image/shuffle-1.png"
        onClicked: {
            if (shuffer.status == 1){
                shuffer.status = 0
            }
            else {
                shuffer.status = 1
                player.playlist.playbackMode = Playlist.Random
            }
        }
    }
    ButtonControl {
        id: prev
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 60
        anchors.right: play.left
        icon_default: "Image/prev.png"
        icon_pressed: "Image/hold-prev.png"
        icon_released: "Image/prev.png"
        onClicked: {
            if (shuffer.status == 1){
                player.playlist.playbackMode = Playlist.Random
                player.playlist.previous()
            }
            else {
                player.playlist.playbackMode = Playlist.Sequential
                if (player.playlist.currentIndex > 0){
                    player.playlist.previous()
                }
                else player.playlist.setCurrentIndex(album_art_view.count - 1)
            }
            player.play()
        }
    }

    ButtonControl {
        id: play
        anchors.verticalCenter: prev.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        icon_default: player.state === MediaPlayer.PlayingState ?  "Image/pause.png" : "Image/play.png"
        icon_pressed: player.state === MediaPlayer.PlayingState ?  "Image/hold-pause.png" : "Image/hold-play.png"
        icon_released: player.state === MediaPlayer.PlayingState ?  "Image/play.png" : "Image/pause.png"
        onClicked: {
            player.state === MediaPlayer.PlayingState ? player.pause() : player.play()
        }
        Connections {
            target: player
            function onStateChanged() {
                play.imgSource = player.state === MediaPlayer.PlayingState ?  "qrc:/Image/pause.png" : "qrc:/Image/play.png"
            }
        }
    }
    ButtonControl {
        id: next
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 60
        anchors.left: play.right
        icon_default: "qrc:/Image/next.png"
        icon_pressed: "qrc:/Image/hold-next.png"
        icon_released: "qrc:/Image/next.png"
        onClicked: {
            if (shuffer.status == 1){
                player.playlist.playbackMode = Playlist.Random
                player.playlist.next()
            }
            else {
                player.playlist.playbackMode = Playlist.Sequential
                if (player.playlist.currentIndex < album_art_view.count - 1){
                    player.playlist.next()
                }
                else player.playlist.setCurrentIndex(0)
            }
            player.play()
        }
    }
    SwitchButton {
        id: repeater
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 60
        anchors.right: totalTime.right
        icon_on: "qrc:/Image/repeat1_hold.png"
        icon_off: "qrc:/Image/repeat.png"
        onClicked: {
            if (repeater.status == 1){
                repeater.status = 0
            }
            else {
                repeater.status = 1
                player.playlist.playbackMode = Playlist.CurrentItemInLoop
            }
        }
    }
    Connections{
        target: player.playlist
        function onCurrentIndexChanged() {
            if (shuffer.status == 1)
                player.playlist.playbackMode = Playlist.Random
            else if (repeater.status == 1)
                player.playlist.playbackMode = Playlist.CurrentItemInLoop
            else player.playlist.playbackMode = Playlist.Sequential
            album_art_view.currentIndex = player.playlist.currentIndex
            playlist.mediaPlaylist.currentIndex = player.playlist.currentIndex
            player.play()
        }
    }
}
