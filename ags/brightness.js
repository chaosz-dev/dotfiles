import Service from 'resource:///com/github/Aylur/ags/service.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js';

class Brightness extends Service {
  static {
    Service.register(this,
      {
        'screen-changed': ['float'],
      },
      {
        'screen': ['float', 'rw'],
      });
  }

  #screen = 100;

  get screen() { return this.#screen; }

  set screen(percent) {
    if (Utils.exec('which brithnessctl')) {
      return;
    }

    if (percent < 0) {
      percent = 0.1;
    }

    if (percent > 1) {
      percent = 1;
    }

    Utils.execAsync(`brightnessctl s ${percent * 100}% -q`)
      .then(() => {
        this.#screen = percent;
        this.changed('screen');
      }).catch(console.error);
  }

  constructor() {
    super();

    Utils.exec('brightnessctl s 100%')

    if (Utils.exec('which brithnessctl')) {
      this.#screen = Number(Utils.exec('brightnessctl g')) / Number(Utils.exec('brightnessctl m'));
    }
  }
}

export default new Brightness();
