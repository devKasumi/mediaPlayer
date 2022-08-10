import QtQuick 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5

MouseArea {
    property string icon_default: ""
    property string icon_pressed: ""
    property string icon_released: ""
    property alias imgSource: img.source
    implicitWidth: img.width
    implicitHeight: img.height
    Image {
        id: img
        source: icon_default
    }
    onPressed: {
        img.source = icon_pressed
    }
    onReleased: {
        img.source = icon_released
    }
}

