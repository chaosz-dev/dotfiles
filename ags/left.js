import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Network from 'resource:///com/github/Aylur/ags/service/network.js';

export const workspace_num = () => Widget.Label({
  label: `[ ${Hyprland.active.workspace.id} ]`,
  connections: [[
    Hyprland.active.workspace, self => {
      self.label = `[ ${Hyprland.active.workspace.id - 1} ]`;
    }
  ]]
});

const wifi = () => Widget.Box({
  children: [
    Widget.Icon({
      binds: [['icon', Network.wifi, 'icon-name']],
    }),
    Widget.Label({
      binds: [['label', Network.wifi, 'ssid']],
    }),
  ],
});

const wired = () => Widget.Icon({
  binds: [['icon', Network.wired, 'icon-name']],
});

export const network_indicator = () => Widget.Stack({
  items: [
    ['wifi', wifi()],
    ['wired', wired()],
  ],
  binds: [['shown', Network, 'primary', p => p || 'wifi']],
});
