import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Battery from 'resource:///com/github/Aylur/ags/service/battery.js';
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import Service from 'resource:///com/github/Aylur/ags/service.js';
import Brightness from './brightness.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import { exec } from 'resource:///com/github/Aylur/ags/utils.js';

const offIcon = App.configDir + '/off.png';
const screenIcon = App.configDir + '/screen.png';
const micIcon = App.configDir + '/microphone.png';
const warnIcon = App.configDir + '/warning.png';
const upIcon = App.configDir + '/up.png';
const moon = App.configDir + '/moon.png';

export const battery = () => Widget.Box({
  className: 'battery',
  children: [
    Widget.Icon({
      connections: [[Battery, self => {
        if (Battery.charging)
          self.icon = upIcon;
        else if (Battery.percent < 30)
          self.icon = warnIcon;
        else self.icon = '';
      }]]
    }),
    Widget.Label({
      connections: [
        [Battery, self => {
          self.label = Battery.percent + '%';
        }]],
    }),
    Widget.Icon({
      connections: [[Battery, self => {
        self.icon = `battery-level-${Math.floor(Battery.percent / 10) * 10}-symbolic`;
      }]],
    }),
  ],
});

const NAME = 'settings';

export const settings_menu = Widget.Window({
  name: NAME,
  className: NAME,
  popup: true,
  visible: false,
  focusable: true,
  css: 'min-width: 200px',
  anchor: ['top', 'right'],
  child: Widget.Box({
    css: 'min-width: 160px; margin-left: 10px; margin-right: 10px',
    vertical: true,
    homogeneous: true,
    className: 'menu_box',
    children: [
      Widget.Box({
        css: 'font-size: 15px',
        children: [
          Widget.Icon({
            connections: [[Audio, self => {
              if (!Audio.speaker)
                return;

              const vol = Audio.speaker.volume * 100;
              const icon = [
                [80, 'high'],
                [50, 'medium'],
                [30, 'low'],
                [0, 'muted'],
              ].find(([threshold]) => threshold <= vol)[1];

              self.icon = `audio-volume-${icon}`;
              self.tooltipText = `Volume ${Math.floor(vol)}%`;
            }, 'speaker-changed']]
          }),
          Widget.Slider({
            className: 'slider',
            hexpand: true,
            min: 0,
            max: 1.2,
            vertical: false,
            drawValue: false,
            css: 'min-height: 5px;',
            onChange: ({ value }) => Audio.speaker.volume = value,
            connections: [[Audio, self => {
              self.value = Audio.speaker?.volume || 0;
            }, 'speaker-changed']]
          })
        ]
      }), // Volume Control
      Widget.Box({
        children: [
          Widget.Icon({
            css: 'font-size: 20px',
            connections: [[Audio, self => {
              if (!Audio.microphone)
                return;

              const vol = Audio.microphone.volume * 100;
              const icon = [
                [80, 'high'],
                [50, 'medium'],
                [30, 'low'],
                [0, 'muted'],
              ].find(([threshold]) => threshold <= vol)[1];

              self.icon = micIcon;
              self.tooltipText = `Microphone ${Math.floor(vol)}%`;
            }, 'microphone-changed']]
          }),
          Widget.Slider({
            className: 'slider',
            hexpand: true,
            min: 0,
            max: 1.2,
            vertical: false,
            drawValue: false,
            css: 'min-height: 5px;',
            onChange: ({ value }) => Audio.microphone.volume = value,
            connections: [[Audio, self => {
              self.value = Audio.microphone?.volume || 0;
            }, 'microphone-changed']]
          })
        ]
      }), // Microphone control
      Widget.Box({
        children: [
          Widget.Icon({
            icon: screenIcon,
            binds: [['tooltip-text', Brightness, 'screen', v =>
              `Brightness: ${Math.floor(v * 100)}%`
            ]]
          }),
          Widget.Slider({
            className: 'slider',
            hexpand: true,
            vertical: false,
            drawValue: false,
            min: 0.1,
            max: 1,
            css: 'min-height: 5px',
            onChange: ({ value }) => Brightness.screen = value,
            connections: [[Brightness, self => {
              self.value = Brightness.screen || 0;
            }, 'screen-changed']]
          })
        ]
      }), // Brightness control
      Widget.Button({
        className: 'sysbutton',
        child: Widget.Icon({
          className: 'sysicon',
          icon: offIcon,
        }),
        on_clicked: () => exec('wlogout')
      }),
    ]
  }),
})

export const menu = () => Widget.Button({
  child: Widget.Icon(moon),
  on_clicked: () => App.toggleWindow(NAME),
});
