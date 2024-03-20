# To learn more about how to use Nix to configure your environment
# see: https://developers.google.com/idx/guides/customize-idx-env
{ pkgs, ... }: {
  channel = "stable-23.11"; # "stable-23.11" or "unstable"
  # Use https://search.nixos.org/packages to  find packages
  packages = [
    pkgs.cargo
    pkgs.rustc
    pkgs.rustfmt
    pkgs.stdenv.cc
  ];
  # Sets environment variables in the workspace
  env = {
    RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
  };
  # search for the extension on https://open-vsx.org/ and use "publisher.id"
  idx.extensions = [
    "rust-lang.rust-analyzer"
    "tamasfe.even-better-toml"
    "serayuzgur.crates"
    "vadimcn.vscode-lldb"
  ];

  # NOTE: This is an excerpt of a complete Nix configuration example.
# For more information about the dev.nix file in IDX, see
# https://developers.google.com/idx/guides/customize-idx-env

# Enable previews and customize configuration
idx.previews = {
  enable = true;
  previews = [
    # The following object sets web previews
    {
      command = [
        "cargo"
        "run"
        "--bin"
        "web"
        "&&"
        "cargo"
        "run"
        "--bin"
        "docket-api"
      ];
      id = "web";
      manager = "web";
    }

  ];
};
}