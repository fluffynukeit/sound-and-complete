let 
  rien = import /home/danielaustin/Desktop/rien/rien.nix {
    packageName = "sound-and-complete";
    packagePath = ./.;

    # Instead of using <nixpkgs>, use a lock-file to stick to
    # a particular `nixpkgs` commit.
    nixpkgsLock = ./nixpkgs.json;

    ghcVersion = "ghc865";

    overrides = rec {
      jailbreak = [ "cabal-helper" "liquidhaskell" ];
      skipHaddock = justStaticExecutables;
      justStaticExecutables = [ 
        "brittany" 
        "hpack"
        "ghcid"
      ];
    };
  };

in
  (rien.shell {
    # Generate Hoogle documentation?
    wantHoogle = true;

    # Haskell dependencies
    deps = hsPkgs: with hsPkgs; [
      brittany
      cabal-helper

      hpack
      ghcid
      hlint
      adjunctions
      exceptions
      hashable
      hspec
      lens
      mtl
      prettyprinter
      prettyprinter-ansi-terminal
      profunctors
      safe
      text
      uniplate
      unordered-containers
      QuickCheck
    ];

    # Optionally, also add sets of related packages that are
    # commonly used together.
    depSets = hsPkgs: with (rien.package-sets hsPkgs); [
      development-servers
    ];

    # Native dependencies
    nativeDeps = pkgs: with pkgs; [ 
      z3 # for liquidhaskell
    ];
  }) //{ shellHook = "source setup-ghcmod.sh";allowBroken = true; } 
