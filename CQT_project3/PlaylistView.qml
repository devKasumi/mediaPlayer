import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Drawer {
    id: drawer
    property alias mediaPlaylist: mediaPlaylist
    interactive: false
    modal: false
    background: Rectangle {
        id: playlist_bg
        anchors.fill: parent
        color: "transparent"
    }
    ListView {
        id: mediaPlaylist
        anchors.fill: parent
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
                mediaPlaylist.currentIndex = index
                player.playlist.currentIndex = index
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
//    Connections{
//        target: player.playlist
//        function onCurrentIndexChanged() {
//            mediaPlaylist.currentIndex = index;
//        }
//    }
}
