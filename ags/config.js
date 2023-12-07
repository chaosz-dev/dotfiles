import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { battery, menu, } from './right.js';
import { time } from './center.js';
import { network_indicator, workspace_num } from './left.js'

const left = () => Widget.Box({
  children: [
    workspace_num(),
    network_indicator(),
  ]
})

const center = () => Widget.Box({
  children: [
    time()
  ],
})

const right = () => Widget.Box({
  hpack: 'end',
  children: [
    battery(),
    menu(),
  ],
})

const widgets = (monitor = 1) => Widget.Window({
  name: 'bar-${monitor}',
  className: 'bar',
  monitor,
  anchor: ['left', 'top', 'right'],
  exclusive: true,
  child: Widget.CenterBox({
    startWidget: left(),
    centerWidget: center(),
    endWidget: right(),
  })
})

export default {
  style: '/home/chaosz/.config/ags/style.css',
  windows: [
    widgets(),
  ]
}
