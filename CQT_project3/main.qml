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
    AppHeader {
        id: headerItem
        width: parent.width
        height: 141
        playlistButtonStatus: 0
        onClickPlaylistButton: {
            if (playlistButtonStatus == 1){
                mediaInfoControl.anchors.leftMargin = 500
                mediaInfoControl.pathViewMargin = 60
                mediaInfoControl.sliderWidth = 650
                playlist.open()
            }
            else {
                mediaInfoControl.anchors.leftMargin = 0
                mediaInfoControl.pathViewMargin = 300
                mediaInfoControl.sliderWidth = 1000
                playlist.close()
            }
        }
    }

    //Playlist
    PlaylistView {
        id: playlist
        y: headerItem.height
        width: 400
        height: parent.height - headerItem.height
    }

    //Media Info
    MediaInfoControl {
        id: mediaInfoControl
        anchors.top: headerItem.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
    }

}


















