{ stdenv
, lib
, rustPlatform
, nushell
, pkg-config
, IOKit
, Foundation
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "nushell_plugin_formats";
  inherit (nushell) version src;
  cargoHash = "sha256-WS8VRpJnn/VWS7GUkGowFf51ifUx0SbEZzcoTfx2dp0=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.optionals stdenv.isDarwin [ IOKit Foundation ];
  cargoBuildFlags = [ "--package nu_plugin_formats" ];

  checkPhase = ''
    cargo test --manifest-path crates/nu_plugin_formats/Cargo.toml
  '';

  passthru.updateScript = nix-update-script {
    # Skip the version check and only check the hash because we inherit version from nushell.
    extraArgs = [ "--version=skip" ];
  };

  meta = with lib; {
    description = "A formats plugin for Nushell";
    homepage = "https://github.com/nushell/nushell/tree/${version}/crates/nu_plugin_formats";
    license = licenses.mpl20;
    maintainers = with maintainers; [ viraptor aidalgol ];
    platforms = with platforms; all;
  };
}
