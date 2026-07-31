import QtQuick
import Quickshell.Io

Item {
  id: root

  property var bar
  property string moduleName
  property var settings

  property string ipText: "…"
  property bool fetching: false
  property bool notifyOnResult: false

  implicitWidth: label.implicitWidth + 16
  implicitHeight: bar ? bar.barSize : 26

  function refresh(notify) {
    if (fetching) return
    fetching = true
    notifyOnResult = !!notify
    ipText = "updating…"
    ipProcess.running = true
  }

  function notifyResult(ru, com) {
    if (!bar) return
    if (ru === "N/A" && com === "N/A") {
      bar.run("notify-send 'External IP' 'Не удалось обновить: нет сети или таймаут'")
    } else {
      bar.run("notify-send 'External IP' 'Обновлено — ru: " + ru + "  com: " + com + "'")
    }
  }

  Process {
    id: ipProcess
    command: ["bash", "-c", "echo \"ru:$(curl -fs --max-time 3 ip.flant.ru)\"; echo \"com:$(curl -fs --max-time 3 ip.flant.com)\""]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        var ru = "N/A"
        var com = "N/A"
        text.split("\n").forEach(function(line) {
          if (line.indexOf("ru:") === 0) ru = line.slice(3).trim() || "N/A"
          else if (line.indexOf("com:") === 0) com = line.slice(4).trim() || "N/A"
        })
        root.ipText = "ru: " + ru + " com: " + com
        root.fetching = false
        if (root.notifyOnResult) {
          root.notifyOnResult = false
          root.notifyResult(ru, com)
        }
      }
    }
    onExited: function(exitCode) {
      if (exitCode !== 0 && root.fetching) {
        root.ipText = "N/A"
        root.fetching = false
        if (root.notifyOnResult) {
          root.notifyOnResult = false
          root.notifyResult("N/A", "N/A")
        }
      }
    }
  }

  Timer {
    interval: 60000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.refresh()
  }

  Text {
    id: label
    anchors.centerIn: parent
    text: root.ipText
    color: bar ? bar.foreground : "white"
    font.family: bar ? bar.fontFamily : "monospace"
    font.pixelSize: 12
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: root.refresh(true)
    onEntered: if (bar) bar.showTooltip(root, "ip.flant.ru / ip.flant.com — click to refresh")
    onExited: if (bar) bar.hideTooltip(root)
  }
}
