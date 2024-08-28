import QtQuick
import QtQuick.Controls 
import org.kde.kirigami as Kirigami

ListView {    
    id: todoList                                                                                                 
    anchors.topMargin: 10  
    spacing: 10
    clip: true
    anchors.top: inputItem.bottom + 10
    // fix the scrolling issue
    anchors.bottom: parent.bottom
    
    property var thisModel
    property var parentModelList: []
    property var parentModelTitleList: []

    property bool itemDropped: false  
    
    delegate: Item {
        id: itemWrapper
        width: parent.width * 0.95                                                                                                                                                                                                                                                                                                                     
        height: todoText.contentHeight + 20                                                                                                     
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
            Column {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                Row {
                    spacing: 10

                    Text {
                        id: remainingText
                        text: getCheckedItemCount(thisModel.get(index).sublist) + "/" + thisModel.get(index).sublist.count
                        width: 30
                        visible: thisModel.get(index).sublist.count != 0
                        color: "yellow" 
                        font.pixelSize: 16
                        anchors.verticalCenter: parent.verticalCenter
                        // anchors.horizontalCenter: parent.left
                    }

                    Button {                                                                 
                        id: detailButton                                                   
                        text: "details"                                                     
                        width: 10                          
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
                            color: "blue"
                            opacity: 0.7
                            anchors.verticalCenter: parent.verticalCenter
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
                        id: editButton
                        text: "edit"
                        width: 10
                        onClicked: { 
                            editPopup.open() 
                        }
                        background: Kirigami.Icon {
                            id: editIcon
                            source: "document-edit-symbolic"
                            width: Kirigami.Units.iconSizes.small
                            height: width
                            color: "green"
                            opacity: 0.7
                            
                            anchors.verticalCenter: parent.verticalCenter
                            HoverHandler {
                                id: editButtonHoverHandler
                                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                                cursorShape: Qt.PointingHandCursor
                            }                                                                                
                            states: [                                                                                     
                                State {                                                                                                                                                   
                                    when: editButtonHoverHandler.hovered                                                                  
                                    PropertyChanges {                                                                     
                                        target: editIcon                                                                 
                                        opacity: 0.4                                                                 
                                    }                                                                                     
                                }                                                                                      
                            ] 
                        }
                    }

                    Button {
                        id: deleteButton
                        text: "remove"
                        width: 10
                        onClicked: { 
                            thisModel.remove(index) 
                            saveModelToJson("todoListModel", todoListModel)
                        }
                        background: Kirigami.Icon {
                            id: deleteIcon
                            source: "edit-delete-symbolic"
                            width: Kirigami.Units.iconSizes.small
                            height: width
                            color: "red"
                            opacity: 0.7
                            anchors.verticalCenter: parent.verticalCenter
                            HoverHandler {
                                id: deleteButtonHoverHandler
                                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                                cursorShape: Qt.PointingHandCursor
                            }                                                                                
                            states: [                                                                                     
                                State {                                                                                                                                                   
                                    when: deleteButtonHoverHandler.hovered                                                                  
                                    PropertyChanges {                                                                     
                                        target: deleteIcon                                                                 
                                        opacity: 0.4                                                                 
                                    }                                                                                     
                                }                                                                                      
                            ] 
                        }
                    }
                }
            }                                                                                                                  

            // just use two buttons instead of a dropdown menu

            Popup {                                                                  
                id: editPopup                                                       
                modal: true                                                          
                focus: true                                                          
                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside | Popup.CloseOnEnter      
                                                                                                          
                width: root.width + 10                                                                                    
                height: editTextArea.contentHeight + 35

                TextArea {                                                                                                                      
                    id: editTextArea                                                                                                               
                    anchors.fill: parent                                                                                                        
                    font.pixelSize: 18                                                                                                   
                    color: "white" 
                    horizontalAlignment: TextArea.AlignHCenter                                                                                  
                    verticalAlignment: TextArea.AlignVCenter                                                                                    
                    wrapMode: TextArea.Wrap 
                    text: model.text                                                                                                                                                                                                                                                                                                                   
                    
                    background: Rectangle {
                        anchors.fill: parent  
                        height: parent.height + 30                                           
                        radius: 10                                                           
                        opacity: 0.3                                                         
                        color: "green"                                                        
                    }                                                                                                                                                                                                                                                                                                                            

                    Keys.onReturnPressed: {  
                        model.text = editTextArea.text
                        model.checked = false
                        thisModel.move(index, 0, 1)
                        saveModelToJson("todoListModel", todoListModel)    
                        editPopup.close()                                                                                                                                                          
                    }                                                                                                                                                                                                                                                                                                               
                }                                                                                                                         
            }
                                                                                                           
            Text {   
                id: todoText  
                width: parent.width * 0.75
                anchors.left: checkbox.right  
                anchors.verticalCenter: parent.verticalCenter
                text: model.text                                                                                                        
                font.pixelSize: 16                                                                                                      
                color: "white"                                                                           
                wrapMode: Text.Wrap                                                                                                                                                                                               
            }        
            CheckBox {  
                id: checkbox 
                anchors.verticalCenter: parent.verticalCenter    
                anchors.left: parent.left                                                                                                           
                checked: model.checked  
                // use onClicked instead of onCheckedChanged to avoid binding loop
                onClicked: {                                                                                                                    
                    model.checked = checked  
                    // move the checked item to the bottom of the list
                    if (thisModel.get(index).checked) {
                        thisModel.move(index, thisModel.count-1, 1)
                    } else {
                        thisModel.move(index, 0, 1)
                    }
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

    function getCheckedItemCount(model) {                                        
        var count = 0;                                                           
        for (var i = 0; i < model.count; i++) {                                  
            if (model.get(i).checked) {                                  
                count++;                                                         
            }                                                                    
        }                                                                        
        return count;                                                            
    }  
                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
}
