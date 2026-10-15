import QtQuick
import Quickshell
import Quickshell.Io

Item {
  id: root

  property var bar
  property string moduleName
  property var settings

  property string ipText: "…"
  property string ruIp: ""
  property string comIp: ""
  property string hosts: ""

  // On narrow screens (e.g. a portrait monitor) the left section runs into
  // the centered clock, so show only the ru address there.
  readonly property int compactBelow: settings && settings.compactBelow ? settings.compactBelow : 1300
  readonly property var hostWindow: root.QsWindow.window
  readonly property bool compact: hostWindow ? hostWindow.width < compactBelow : false
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
      bar.run("notify-send 'External IP' 'Update failed: no network or timeout'")
    } else {
      bar.run("notify-send 'External IP' 'Updated — ru: " + ru + "  com: " + com + "'")
    }
  }

  Process {
    id: ipProcess
    // Lookup hosts (IP_HOST_RU, IP_HOST_COM) come from the untracked
    // ~/.local/src/datagrip/private/configs/external-ip.env.
    command: ["bash", "-c", ". \"$HOME/.local/src/datagrip/private/configs/external-ip.env\" 2>/dev/null; echo \"hosts:${IP_HOST_RU} / ${IP_HOST_COM}\"; echo \"ru:$([ -n \"$IP_HOST_RU\" ] && curl -fs --max-time 3 \"$IP_HOST_RU\")\"; echo \"com:$([ -n \"$IP_HOST_COM\" ] && curl -fs --max-time 3 \"$IP_HOST_COM\")\""]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        var ru = "N/A"
        var com = "N/A"
        text.split("\n").forEach(function(line) {
          if (line.indexOf("ru:") === 0) ru = line.slice(3).trim() || "N/A"
          else if (line.indexOf("com:") === 0) com = line.slice(4).trim() || "N/A"
          else if (line.indexOf("hosts:") === 0) root.hosts = line.slice(6).trim()
        })
        root.ruIp = ru
        root.comIp = com
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
    text: root.compact && !root.fetching && root.ruIp ? root.ruIp : root.ipText
    color: bar ? bar.foreground : "white"
    font.family: bar ? bar.fontFamily : "monospace"
    font.pixelSize: 12
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: root.refresh(true)
    onEntered: if (bar) bar.showTooltip(root, (root.compact ? root.ipText + "\n" : "") + root.hosts + " — click to refresh")
    onExited: if (bar) bar.hideTooltip(root)
  }
}
