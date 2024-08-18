import QtQuick
import QtQuick.Controls 
import org.kde.kirigami as Kirigami

ListView {    
    id: todoList                                                                                                 
    anchors.topMargin: 10  
    spacing: 10
    clip: true 
    anchors.top: inputItem.bottom
    
    property var thisModel
    property bool details: false
    property int detailIndex: -1

    property bool itemDropped: false  
    
    delegate: Item {
        id: itemWrapper
        width: parent.width * 0.9                                                                                                                                                                                                                                                                                                                     
        height: todoText.contentHeight + 12                                                                                                           
        anchors.horizontalCenter: parent.horizontalCenter   

        property int dragItemIndex: index
        property double originalY: itemWrapper.y

        Drag.active: itemMouseArea.drag.active
        Drag.hotSpot: Qt.point(itemWrapper.width/2, itemWrapper.height/2)
        MouseArea {                                                            
            id: itemMouseArea                                                  
            anchors.fill: parent                                               
            drag.target: itemWrapper                                           
                                                                            
            drag.onActiveChanged: {                                            
                if (itemMouseArea.drag.active) {                               
                    itemWrapper.dragItemIndex = index                          
                    itemWrapper.originalY = itemWrapper.y 
                }                                                              
            }                                                                  
            onReleased: {   
                itemWrapper.Drag.drop()                                    
                if (!itemDropped) {                                                                                  
                    itemWrapper.y = itemWrapper.originalY                                                                           
                }                 
                itemDropped = false                                                                                                                                      
            }                                                                  
        } 
        DropArea {
            id: itemDropArea
            anchors.fill: parent
            onDropped: {
                itemWrapper.dragItemIndex = index 
                thisModel.move(drag.source.dragItemIndex, itemWrapper.dragItemIndex, 1)
                
                if (details == true) {
                    var sublist = todoListModel.get(detailIndex).sublist;                                                 
                    sublist.clear();                                                                                      
                    for (var i = 0; i < thisModel.count; i++) {                                                           
                        sublist.append(thisModel.get(i))                                                               
                    }  
                }  
                itemDropped = true
            }
        }
        
        Rectangle {
            anchors.fill: parent                                                 
            radius: 10                                                           
            opacity: 0.3                                                         
            color: "black"                                                   
        }                                                                                                                                                                                                                  
        Item {                                                                                                                           
            anchors.fill: parent
            height: parent.height * 0.9  
            anchors.margins: 20
            Button {                                                                 
                id: dropdownButton                                                   
                text: "Dropdown"                                                     
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right                                            
                onClicked: dropdownMenu.popup()    
                background: Kirigami.Icon {
                    id: menuIcon
                    source: "usermenu-down"
                    width: Kirigami.Units.iconSizes.small
                    height: width 
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    HoverHandler {
                        id: dropdownButtonHoverHandler
                        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                        cursorShape: Qt.PointingHandCursor
                    }                                                                                
                    states: [                                                                                     
                        State {                                                                                                                                                   
                            when: dropdownButtonHoverHandler.hovered                                                                  
                            PropertyChanges {                                                                     
                                target: menuIcon                                                                 
                                opacity: 0.4                                                                 
                            }                                                                                     
                        }                                                                                      
                    ] 
                }                                                                                                    
            }

            Menu {
                id: dropdownMenu
                width: 100
                MenuItem {
                    visible: !todoList.details
                    contentItem: Button {
                        id: detailButton
                        text: "details"
                        onClicked: {
                            dropdownMenu.close()
                            mainViewWrapper.visible = false
                            detailsWrapper.visible = true
                            detailsWrapper.detailTitle = todoListModel.get(index).text
                            detailInputItem.detailIndex = index
                            detailTodoList.detailIndex = index
                            detailModel.clear()
                            var sublist = todoListModel.get(index).sublist
                            for (var i = sublist.count - 1; i >= 0; i--) {                                                                                                                                                                                                                                               
                                detailModel.insert(0, sublist.get(i))
                            }  
                        }
                    }
                }

                MenuItem { 
                    contentItem: Button {
                        id: delbutton
                        text: "remove"
                        onClicked: { 
                            dropdownMenu.close()
                            if (details == true) {
                                var sublist = todoListModel.get(detailIndex).sublist                                                                                        
                                sublist.remove(index)                                                          
                                thisModel.remove(index) 
                                saveModelToJson("todoListModel", todoListModel) 
                            } 
                            else { 
                                thisModel.remove(index) 
                            }
                        }
                    }   
                }                                                                                                                        
            }

            Text {   
                id: todoText  
                width: parent.width * 0.75                                                      
                text: model.text                                                                                                        
                font.pixelSize: 16                                                                                                      
                color: "white"                                                                           
                anchors.verticalCenter: parent.verticalCenter  
                anchors.horizontalCenter: parent.horizontalCenter                                                                                                              
                wrapMode: Text.Wrap                                                                                                                                                                                               
            }                                                                                                                           
            CheckBox {  
                id: checkbox 
                anchors.verticalCenter: parent.verticalCenter                                                                                                               
                checked: model.checked                                                                                                  
                onCheckedChanged: {
                    model.checked = checked  
                    saveModelToJson("todoListModel", todoListModel) 
                }
            } 
                                                                                                                                                                                                                                                            
        }                                                                                                                               
    } 
    displaced: Transition {                                                                                    
        NumberAnimation {                                                                                      
            properties: "y"                                                                                    
            duration: 200                                                                                      
        }                                                                                                      
    }
                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
}