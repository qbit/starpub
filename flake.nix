{
  description = "starpub: star anything";

  inputs.nixpkgs.url = "nixpkgs/nixos-23.11";

  outputs =
    { self
    , nixpkgs
    ,
    }:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      overlay = _: prev: { inherit (self.packages.${prev.system}) starpub; };

      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          starpub = pkgs.buildGoModule {
            pname = "starpub";
            version = "v0.0.0";
            src = ./.;

            vendorHash = pkgs.lib.fakeSha256;
          };
        });

      defaultPackage = forAllSystems (system: self.packages.${system}.starpub);
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          default = pkgs.mkShell {
            shellHook = ''
              PS1='\u@\h:\@; '
              echo "Go `${pkgs.go}/bin/go version`"
            '';
            nativeBuildInputs = with pkgs; [
              git
              go
              gopls
              go-tools
              sqlc

              (pkgs.callPackage (import ./ogen.nix) { })
              (postgresql.withPackages (p: [ p.postgis ]))
            ];
          };
        });
    };
}