{pkgs, ...}: {
  home.packages = with pkgs; [
    (dmenu.overrideAttrs {
      src = fetchFromGitHub {
        owner = "tarneaux";
        repo = "dmenu";
        rev = "bab46f0c9f1e8dfc9e19ad26d06bcf3db76f174a";
        sha256 = "sha256-mLViMJlTKw3UXuofFB9LLtVj/vUn+Wp+ZZivbB+Rifk=";
      };
    })
  ];
}
