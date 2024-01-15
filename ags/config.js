import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { battery, menu, settings_menu } from './right.js';
import { time } from './center.js';
import { network_button, network_menu, workspace_num } from './left.js'

const left = () => Widget.Box({
  children: [
    workspace_num(),
    network_button(),
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

const widgets = (monitor = 0) => Widget.Window({
  name: 'bar-${monitor}',
  className: 'bar',
  monitor,
  anchor: ['left', 'top', 'right'],
  exclusivity: 'exclusive',
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
    settings_menu,
    network_menu,
  ]
}
