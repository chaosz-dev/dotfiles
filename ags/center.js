import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

export const time = () =>
  Widget.Box({
    className: 'clock',
    children: [
      Widget.Label({
        connections: [
          [1000, self => { execAsync(['date']).then(date => self.label = " " + date + " ") }],
        ]
      }),
    ]
  });
