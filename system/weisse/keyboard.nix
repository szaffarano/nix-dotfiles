{pkgs, ...}: {
  services.keyd = {
    enable = true;
    keyboards.internal = {
      ids = [
        "k:18d1:5061"
        "k:18d1:505b"
        "k:18d1:5030"
        "k:18d1:503c"
        "k:18d1:5050"
        "k:0000:0000"
        "k:18d1:5057"
        "k:18d1:5044"
        "k:18d1:504c"
        "k:18d1:502b"
        "k:18d1:503d"
        "k:0001:0001"
        "k:18d1:5052"
      ];
      settings = {
        main = {
          f1 = "f1";
          f2 = "f2";
          f3 = "f3";
          f4 = "f4";
          f5 = "f5";
          f6 = "f6";
          f7 = "f7";
          f8 = "f8";
          f9 = "f9";
          f10 = "f10";
          back = "f1";
          forward = "f2";
          refresh = "f3";
          zoom = "f4";
          scale = "f5";
          brightnessdown = "f6";
          brightnessup = "f7";
          mute = "f8";
          volumedown = "f9";
          volumeup = "f10";
        };
        meta = {
          f1 = "back";
          f2 = "forward";
          f3 = "refresh";
          f4 = "f11";
          f5 = "scale";
          f6 = "brightnessdown";
          f7 = "brightnessup";
          f8 = "mute";
          f9 = "volumedown";
          f10 = "volumeup";
          back = "back";
          forward = "forward";
          refresh = "refresh";
          zoom = "f11";
          scale = "scale";
          brightnessdown = "brightnessdown";
          brightnessup = "brightnessup";
          mute = "mute";
          volumedown = "volumedown";
          volumeup = "volumeup";
        };
        alt = {
          backspace = "delete";
          brightnessdown = "kbdillumdown";
          brightnessup = "kbdillumup";
          f6 = "kbdillumdown";
          f7 = "kbdillumup";
        };
        control = {
          f5 = "print";
          scale = "print";
        };
        "control+alt" = {
          backspace = "C-A-delete";
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [maliit-keyboard];
}
