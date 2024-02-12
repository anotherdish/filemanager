{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    outputs = { self, nixpkgs }: {
        
        nixosTests = {

            a = let 
                runTest = nixpkgs.lib.nixos.runTest;
            in
            runTest ({ pkgs, ... }: {
                imports = [
                    "${nixpkgs}/nixos/modules/misc/assertions.nix"
                    ./files.nix
                ];
                config = {
                    name = "hi";
                    nodes = {
                        m1 = {config, pkgs, ...}: {
                            users.users.plant = {
                                group = "plant";
                                password = "plant";
                                home = "/home/plant";
                                createHome = true;
                                isNormalUser = true;
                            };
                            users.groups.plant = {};
                            services.getty.autologinUser = "root";
                        };
                    };
                    hostPkgs = nixpkgs.legacyPackages.x86_64-linux;
                    testScript = ''
                        m1.wait_for_unit("default.target")
                    '';
                    home.file."/a/b".text = "faafasfsa";
                };
            });
        };
    };
}
