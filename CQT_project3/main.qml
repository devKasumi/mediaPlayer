import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import QtMultimedia 5.9

ApplicationWindow {
    id: root
    width: 1366
    height: 768
    visible: true
    //visibility: "FullScreen"
    title: qsTr("Media Player")



    //Backgroud of Application
    Image {
        id: backgroud
        anchors.fill: parent
        source: "qrc:/Image/background.png"
    }
    //Header
    Image {
        id: imageHeader
        source: "Image/title.png"
        width: parent.width
        height: 100
        Text {
            id: textHeader
            text: "Media Player"
            font.pointSize: 30
            font.bold: true
            color: "white"
            anchors.centerIn: parent
        }
    }
    //Playlist
    Image {
        id: playlist
        source: "Image/playlist.png"
        width: 400
        height: parent.height - imageHeader.height
        anchors.top: imageHeader.bottom
    }
    ListView {
        id: mediaPlaylist
        anchors.fill: playlist
        model: MyModel
        clip: true
        spacing: 2
        currentIndex: 0
        delegate: MouseArea {
            property var myData: model
            implicitWidth: playlistItem.width
            implicitHeight: playlistItem.height
            Image {
                id: playlistItem
                width: 400
                height: 100
                source: "Image/playlist.png"
                opacity: 0.5
            }
            Text {
                text: model.title
                anchors.fill: parent
                anchors.leftMargin: 70
                verticalAlignment: Text.AlignVCenter
                color: "white"
                font.pixelSize: 32
            }
            onClicked: {
                player.playlist.currentIndex = index
                album_art_view.currentIndex = index
                player.play()
            }
            onPressed: {
                playlistItem.source = "Image/hold.png"
            }
            onReleased: {
                playlistItem.source = "Image/playlist_item.png"
            }
        }
        highlight: Image {
            source: "qrc:/Image/playlist_item.png"
            Image {
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/Image/playing.png"
            }
        }
        ScrollBar.vertical: ScrollBar {
            parent: mediaPlaylist.parent
            anchors.top: mediaPlaylist.top
            anchors.left: mediaPlaylist.right
            anchors.bottom: mediaPlaylist.bottom
        }
    }
    //Media Info
    Text {
        id: audioTitle
        text: mediaPlaylist.currentItem.myData.title
        width: 300
        font.pointSize: 20
        font.bold: true
        anchors.left: playlist.right
        anchors.top: imageHeader.bottom
        color: "white"
        leftPadding: 15
        topPadding: 10
        onTextChanged: {
            textChangeAni.targets = [audioTitle,audioSinger]
            textChangeAni.restart()
        }
    }
    Text {
        id: audioSinger
        text: mediaPlaylist.currentItem.myData.singer
        width: 300
        font.pointSize: 17
        font.bold: true
        anchors.top: audioTitle.bottom
        anchors.left: playlist.right
        color: "white"
        leftPadding: 15
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
        text: mediaPlaylist.count
        font.pointSize: 30
        font.bold: true
        color: "white"
        anchors.top: imageHeader.bottom
        anchors.left: audioTitle.right
        topPadding: 10
        leftPadding: 600
    }
    Image {
        anchors.top: imageHeader.bottom
        anchors.left: audioTitle.right
        anchors.topMargin: 20
        anchors.leftMargin: 550
        source: "Image/music.png"
    }

    Component {
        id: appDelegate
        Item {
            width: 290; height: 290
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
                    mediaPlaylist.currentIndex = index
                    player.playlist.currentIndex = index
                    player.play()
                }
            }
        }
    }

    PathView {
        id: album_art_view
        anchors.left: mediaPlaylist.right
        anchors.leftMargin: 60
        anchors.top: imageHeader.bottom
        anchors.topMargin: 180
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        pathItemCount: 3
        focus: true
        model: MyModel
        delegate: appDelegate
        path: Path {
            startX: 10
            startY: 50
            PathAttribute { name: "iconScale"; value: 0.5 }
            PathLine { x: 390; y: 50 }
            PathAttribute { name: "iconScale"; value: 1.0 }
            PathLine { x: 780; y: 50 }
            PathAttribute { name: "iconScale"; value: 0.5 }
        }
        onCurrentIndexChanged: {
            mediaPlaylist.currentIndex = currentIndex
            album_art_view.currentIndex = currentIndex
        }
    }
    //Progress
    Text {
        id: currentTime
        font.bold: true
        anchors.bottom: parent.bottom
        anchors.left: playlist.right
        bottomPadding: 188
        leftPadding: 100
        text: utility.getTimeInfo(player.position)
        color: "white"
        font.pixelSize: 15
    }
    Slider{
        id: progressBar
        width: 650
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 175
        anchors.left: currentTime.right
        anchors.leftMargin: 5
        from: 0
        to: player.duration
        value: player.position
        enabled: player.seekable
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
            width: 20; height: 20
            anchors.verticalCenter: parent.verticalCenter
            x: progressBar.leftPadding + progressBar.visualPosition * (progressBar.availableWidth - width)
            y: progressBar.topPadding + progressBar.availableHeight / 2 - height / 2
            source: "Image/point.png"
            Image {
                width: 15; height:15
                anchors.centerIn: parent
                source: "Image/center_point.png"
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
        font.pixelSize: 15
        font.bold: true
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 188
        anchors.left: progressBar.right
        anchors.leftMargin: 5
        text: utility.getTimeInfo(player.duration)
        color: "white"
    }
    //Media control
    SwitchButton {
        id: shuffer
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 100
        anchors.left: playlist.right
        anchors.leftMargin: 100
        icon_off: "Image/shuffle.png"
        icon_on: "Image/shuffle-1.png"
        onClicked: {
            if (shuffer.status == 1){
                shuffer.status = 0
            }
            else shuffer.status = 1
        }
    }
    ButtonControl {
        id: prev
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 100
        anchors.left: shuffer.right
        anchors.leftMargin: 210
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
                else player.playlist.setCurrentIndex(mediaPlaylist.count - 1)
            }
            player.play()
        }
    }

    ButtonControl {
        id: play
        anchors.verticalCenter: prev.verticalCenter
        anchors.left: prev.right
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
        anchors.bottomMargin: 100
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
                if (player.playlist.currentIndex < mediaPlaylist.count - 1){
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
        anchors.bottomMargin: 100
        anchors.right: totalTime.right
        icon_on: "qrc:/Image/repeat1_hold.png"
        icon_off: "qrc:/Image/repeat.png"
        onClicked: {
            if (repeater.status == 1){
                repeater.status = 0
            }
            else repeater.status = 1
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
            mediaPlaylist.currentIndex = player.playlist.currentIndex
            album_art_view.currentIndex = player.playlist.currentIndex
            player.play()
        }
    }
}
