import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import qs.Ui
import qs.Commons

BarWidget {
  id: root
  moduleName: "local.keyboard-layout"


  property string layoutLabel: ""
  property string layoutFull: ""

  function refresh() {
    if (!queryProc.running) queryProc.running = true
  }

  function cycleLayout() {
    Hyprland.dispatch("switchxkblayout current next")
    refreshTimer.restart()
  }

  Component.onCompleted: refresh()

  Connections {
    target: Hyprland
    function onRawEvent(event) {
      if (!event || !event.name) return
      if (String(event.name).indexOf("activelayout") !== -1) root.refresh()
    }
  }

  Process {
    id: queryProc
    command: ["bash", "-c", "hyprctl -j devices 2>/dev/null | jq -r '(.keyboards[] | select(.main==true) | .active_keymap) // (.keyboards[-1].active_keymap) // empty'"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        var full = String(text || "").trim()
        if (!full) return
        root.layoutFull = full
        var token = full.split(/\s+/)[0]
        var map = { "English": "EN", "Russian": "RU" }
        root.layoutLabel = map[token] || token.substring(0, 2).toUpperCase()
      }
    }
  }

  Timer {
    id: refreshTimer
    interval: 600
    onTriggered: root.refresh()
  }

  Timer {
    interval: 10000
    running: true
    repeat: true
    onTriggered: root.refresh()
  }

  visible: layoutLabel !== ""
  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.layoutLabel
    fontSize: Style.font.caption
    horizontalMargin: 6
    tooltipText: root.layoutFull
    onPressed: function() { root.cycleLayout() }
  }
}
