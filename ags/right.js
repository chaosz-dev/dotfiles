import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Battery from 'resource:///com/github/Aylur/ags/service/battery.js';
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import PopupWindow from './misc.js';

const warnIcon = App.configDir + '/warning.png';
const upIcon = App.configDir + '/up.png';
const moon = App.configDir + '/moon.png';
const volHover = Variable('false');

export const battery = () => Widget.Box({
  className: 'battery',
  children: [
    Widget.Icon({
      connections: [[Battery, self => {
        if (Battery.charging)
          self.icon = upIcon;
        else if (Battery.percent < 30 && Battery.percent > 0)
          self.icon = warnIcon;
        else self.icon = '';
      }]]
    }),
    Widget.Label({
      connections: [
        [Battery, self => {
          if (Battery.percent < 0) {
            self.label = '';
            return;
          }
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

// const menuContent = Widget.Box({
//   children: [
//     Widget.Label('Volume: ' + Math.floor(Audio.speaker.volume * 100)),
//     Widget.Button({
//       child: Widget.Label('+'),
//     }), Widget.Button({
//       child: Widget.Label('-'),
//     })
//   ]
// });

export default () => PopupWindow({
  name: 'menu',
  className: 'menu',
  transition: 'slide_down',
  child: Widget.Box({
    children: [
      Widget.Label('hi'),
    ]
  })
});

export function toggleMenu() {
  App.toggleWindow('menu');
}

export const menu = () => Widget.Button({
  child: Widget.Icon(moon),
  on_clicked: () => toggleMenu(),
});

// export const volume = () => Widget.Box({
//   className: 'volume',
//   css: 'min-width: 120px',
//   children: [Widget.Icon({
//     connections: [[Audio, icon => {
//       if (!Audio.speaker)
//         return;

//       const { muted, low, medium, high, overamplified } = icons.audio.volume;
//       if (Audio.speaker.is_muted)
//         return icon.icon = muted;


//       const cons = [[101, overamplified], [67, high], [34, medium], [1, low], [0, muted]];
//       icon.icon = cons.find(([n]) => n <= Audio.speaker.volume * 100)?.[1] || '';
//     }, 'speaker-changed']],
//   }),
//   Widget.Slider({
//     hexpand: true,
//     drawValue: false,
//     onChange: ({ value }) => Audio.speaker.volume = value,
//     connections: [[Audio, self => {
//       self.value = Audio.speaker?.volume || 0;
//     }, 'speaker-changed']],
//   }),
//   ]
// });