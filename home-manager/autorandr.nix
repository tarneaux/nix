{...}: let
  postswitch-hook = ''
    #!/usr/bin/env bash
    echo "Running autorandr postswitch hook"

    # If the profile changed since last time, run the profile hook
    if [[ "$AUTORANDR_CURRENT_PROFILE" != "$(cat /tmp/autorandr-current-profile)" ]]; then
      echo "Profile changed, restarting awesomewm and qutebrowser"
      pgrep awesome | xargs kill -s HUP
      pgrep -q qutebrowser && qutebrowser :config-source
    fi

    echo "$AUTORANDR_CURRENT_PROFILE" > /tmp/autorandr-current-profile
  '';
in {
  programs.autorandr = {
    enable = true;
    profiles = {
      default = {
        fingerprint = {
          eDP-1 = "00ffffffffffff0009e5ca0b000000002f200104a51c137803de50a3544c99260f505400000001010101010101010101010101010101115cd01881e02d50302036001dbe1000001aa749d01881e02d50302036001dbe1000001a000000fe00424f452043510a202020202020000000fe004e4531333546424d2d4e34310a0073";
        };
        config = {
          eDP-1 = {
            enable = true;
            position = "0x0";
            mode = "2256x1504";
            primary = true;
            rate = "60.00";
          };
          DP-3.enable = false;
        };
        hooks.postswitch = postswitch-hook;
      };
      home = {
        fingerprint = {
          eDP-1 = "00ffffffffffff0009e5ca0b000000002f200104a51c137803de50a3544c99260f505400000001010101010101010101010101010101115cd01881e02d50302036001dbe1000001aa749d01881e02d50302036001dbe1000001a000000fe00424f452043510a202020202020000000fe004e4531333546424d2d4e34310a0073";
          DP-3 = "00ffffffffffff001e6df25926380400021b010380502278eaca95a6554ea1260f5054a54b80714f818081c0a9c0b3000101010101017e4800e0a0381f4040403a001e4e31000018023a801871382d40582c45001e4e3100001e000000fc004c4720554c545241574944450a000000fd00384b1e5a18000a20202020202001a402031df14a900403222212121f0113230907078301000065030c001000023a801871382d40582c450056512100001e023a801871382d40582c450056512100001e011d007251d01e206e28550056512100001e8c0ad08a20e02d10103e9600565121000018000000ff003730324e54524c38343531380a000000000000000060";
        };
        config = {
          eDP-1.enable = false;
          DP-3 = {
            enable = true;
            position = "0x0";
            mode = "2560x1080";
            primary = true;
            rate = "60.00";
          };
        };
        hooks.postswitch = postswitch-hook;
      };
      home-lid-closed = {
        fingerprint = {
          DP-3 = "00ffffffffffff001e6df25926380400021b010380502278eaca95a6554ea1260f5054a54b80714f818081c0a9c0b3000101010101017e4800e0a0381f4040403a001e4e31000018023a801871382d40582c45001e4e3100001e000000fc004c4720554c545241574944450a000000fd00384b1e5a18000a20202020202001a402031df14a900403222212121f0113230907078301000065030c001000023a801871382d40582c450056512100001e023a801871382d40582c450056512100001e011d007251d01e206e28550056512100001e8c0ad08a20e02d10103e9600565121000018000000ff003730324e54524c38343531380a000000000000000060";
        };
        config = {
          eDP-1.enable = false;
          DP-3 = {
            enable = true;
            position = "0x0";
            mode = "2560x1080";
            primary = true;
            rate = "60.00";
          };
        };
        hooks.postswitch = postswitch-hook;
      };
    };
  };
}
