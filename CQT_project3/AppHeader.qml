import QtQuick 2.15

Item {
    property alias playlistButtonStatus: playlist_button.status
    signal clickPlaylistButton

    Image {
        id: headerItem
        source: "Image/title.png"
        SwitchButton {
            id: playlist_button
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            icon_off: "qrc:/Image/drawer.png"
            icon_on: "qrc:/Image/back.png"
            onClicked: {
                if (playlistButtonStatus == 0){
                    playlistButtonStatus = 1
                }
                else playlistButtonStatus = 0
                clickPlaylistButton()
            }     
        }
        Text {
            anchors.left: playlist_button.right
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("Playlist") + translator.getEmptyString
            color: "white"
            font.pixelSize: 32
        }
        Text {
            id: headerTitleText
            text: qsTr("Media Player") + translator.getEmptyString
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.leftMargin: 500
            color: "white"
            font.pixelSize: 46
        }
        Image {
            id: vn_flag
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            width: 50
            height: 50
            source: "qrc:/Image/vn.png"
            Rectangle {
                width: 50
                height: 30
                anchors.verticalCenter: parent.verticalCenter
                border.color: "gray"
                border.width: 3
                color: "transparent"
                visible: translator.currentLanguage === "vn" ? 1 : 0
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    translator.selectLanguage("vn")
                }
            }
        }
        Image {
            id: us_flag
            anchors.right: vn_flag.left
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            width: 50
            height: 50
            source: "qrc:/Image/us.png"
            Rectangle {
                width: 50
                height: 30
                anchors.verticalCenter: parent.verticalCenter
                border.color: "gray"
                border.width: 3
                color: "transparent"
                visible: translator.currentLanguage === "us" ? 1 : 0
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    translator.selectLanguage("us")
                }
            }
        }
    }
}
























