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
    property var parentModelList: []
    property var parentModelTitleList: []

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
                saveModelToJson("todoListModel", todoListModel) 
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
            anchors.margins: 10
            Button {                                                                 
                id: detailButton                                                   
                text: "details"                                                     
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: dropdownButton.left 
                width: 10
                anchors.leftMargin: 10 
                anchors.rightMargin: 10                                            
                onClicked: {
                    root.subModelTitle = model.text
                    todoList.parentModelList.push(root.currentModel)
                    todoList.parentModelTitleList.push(model.text)
                    root.currentModel = thisModel.get(index).sublist
                }  
                background: Kirigami.Icon {
                    id: detailIcon
                    source: "application-menu-symbolic"
                    width: Kirigami.Units.iconSizes.small
                    height: width 
                    opacity: 0.7
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    HoverHandler {
                        id: detailButtonHoverHandler
                        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                        cursorShape: Qt.PointingHandCursor
                    }                                                                                
                    states: [                                                                                     
                        State {                                                                                                                                                   
                            when: detailButtonHoverHandler.hovered                                                                  
                            PropertyChanges {                                                                     
                                target: detailIcon                                                                 
                                opacity: 0.4                                                                 
                            }                                                                                     
                        }                                                                                      
                    ] 
                }                                                                                                    
            }
            Button {                                                                 
                id: dropdownButton                                                   
                text: "Dropdown"                                                     
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right  
                width: 10
                anchors.leftMargin: 10                             
                onClicked: dropdownMenu.popup()    
                background: Kirigami.Icon {
                    id: menuIcon
                    source: "usermenu-down-symbolic"
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
                    contentItem: Button {
                        id: delbutton
                        text: "remove"
                        onClicked: { 
                            dropdownMenu.close()
                            thisModel.remove(index) 
                            saveModelToJson("todoListModel", todoListModel)
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