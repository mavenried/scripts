import QtQuick
import Quickshell
pragma Singleton

Singleton {
    readonly property color bgnd: $[qs-bgnd]
    readonly property color cpuc: "$[qs-cpuc]"
    readonly property color mmry: "$[qs-mmry]"
    readonly property color disk: "$[qs-disk]"
    readonly property color wksp: "$[qs-wksp]"
    readonly property color idle: "$[qs-idle]"
    readonly property color bglt: "$[qs-bglt]"
    readonly property color wifi: "$[qs-wifi]"
    readonly property color dstr: "$[qs-dstr]"
    readonly property color name: "$[qs-name]"
    readonly property color uptm: "$[qs-uptm]"
    readonly property color clck: "$[qs-clck]"
    readonly property color sptr: "$[qs-sptr]"
    readonly property color powr: "$[qs-powr]"
    readonly property color pfle: "$[qs-pfle]"
    readonly property color bat1: "$[qs-bat1]"
    readonly property color bat2: "$[qs-bat2]"
    readonly property color bat3: "$[qs-bat3]"
    readonly property color bat4: "$[qs-bat4]"
    readonly property color bat5: "$[qs-bat5]"
    readonly property color acct: "#$[accent-color]"
    readonly property int radius: 15
}
