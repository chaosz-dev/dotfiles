import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Network from 'resource:///com/github/Aylur/ags/service/network.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

export const workspace_num = () => Widget.Label({
  label: `[ ${Hyprland.active.workspace.id} ]`,
  connections: [[
    Hyprland.active.workspace, self => {
      self.label = `[${Hyprland.active.workspace.id - 1}]`;
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

const network_opened = Variable('closed');

export const network_button = () => Widget.Button({
  child: Widget.Stack({
    items: [
      ['wifi', wifi()],
      ['wired', wired()],
    ],
    binds: [['shown', Network, 'primary', p => p || 'wifi']],
  }),
  on_clicked: () => {
    App.toggleWindow('network-menu');
    network_opened.value = 'opened';
  },
});

export const network_menu = Widget.Window({
  name: 'network-menu',
  className: 'settings',
  popup: true,
  visible: false,
  focusable: true,
  css: 'min-width: 200px',
  anchor: ['top', 'left'],
  child: Widget.Box({
    className: 'menu_box',
    css: 'min-width: 100px; margin-left: 0px; margin-right: 1px',
    vertical: true,
    homogeneous: false,
    children: [],
    setup: self => self.hook(
      network_opened, self => {
        execAsync(['nmcli', 'device', 'wifi', 'list']).then(
          out => {
            self.children = [
              Widget.Box({
                vertical: false,
                homogeneous: false,
                children: [
                  Widget.Label({
                    label: '\tSSID',
                    justification: 'left',
                    max_width_chars: 30,
                    xalign: 0,
                    css: 'min-width: 290px;',
                  }),
                  Widget.Label('Strength')
                ]
              }),
            ];
            //out.split('\n')[1].replace(/\s+/g, ' ').split(' ')[0]; 
            let list = [];
            for (let i = 1; i < out.split('\n').length; i++) {
              let box = Widget.Box({
                vertical: false,
                homogeneous: false,
                children: [],
              });

              if (out.split('\n')[i].replace(/\s+/g, ' ').split(' ')[0] == '*') {
                continue;
              }

              let bssid = out.split('\n')[i].replace(/\s+/g, ' ').split(' ')[1];
              let ssid = out.split('\n')[i].replace(/\s+/g, ' ').split(' ')[2];
              let strength = out.split('\n')[i].replace(/\s+/g, ' ').split(' ')[8];
              let rate = Number(out.split('\n')[i].replace(/\s+/g, ' ').split(' ')[6]);

              let revealer = Widget.Revealer({
                reveal_child: false,
                transition: 'slide_down',
                transition_duration: 500,
                child: Widget.Box({
                  vertical: false,
                  homogeneous: false,
                  children: [
                    Widget.Label({
                      label: 'Password:',
                      css: 'margin-left: 20px',
                    }),
                    Widget.Entry({
                      visibility: false,
                      placeholder_text: 'enter password',
                      text: '',
                      on_accept: ({ text }) => {
                        execAsync(['nmcli', 'dev', 'wifi', 'connect', `${ssid}`, 'password', `${text}`]).then(
                          App.toggleWindow('network-menu')
                        ).catch();
                      },
                    }),
                  ],
                }),
              });

              box.add(Widget.Button({
                className: 'wifi_button',
                child: Widget.Label({
                  label: `${ssid}`,
                  justification: 'left',
                  max_width_chars: 30,
                  xalign: 0,
                  css: 'min-width: 300px;',
                }),
                on_clicked: (self) => {
                  revealer.set_reveal_child(!revealer.get_reveal_child());
                },
              }));
              box.add(Widget.Label(`${strength}`));
              self.add(box);
              self.add(revealer);
              self.show_all();
            }
          },
        ).catch(
          err => print(err)
        );
      }
    )
  }),
});
