{inputs, ... }@attrs: let
  inherit (inputs) nixpkgs; # <-- nixpkgs = inputs.nixpkgsSomething;
  inherit (inputs.nixCats) utils;
  luaPath = "${./extra}";

  plugins-oh-lucy-nvim = {
    url = "github:Yazeed1s/oh-lucy.nvim";
    flake = false;
  };

  plugins-ascii-nvim = {
          url = "github:MaximilianLloyd/ascii.nvim";
          flake = false;
  };

  plugins-vim-rest-console = {
          url = "github:diepm/vim-rest-console";
          flake = false;
  };

  plugins-format-on-save = {
          url = "github:elentok/format-on-save.nvim";
          flake = false;
  };

  plugins-prettier-nvim = {
          url = "github:MunifTanjim/prettier.nvim";
          flake = false;
  };

  plugins-render-markdown-nvim = {
          url = "github:MeanderingProgrammer/render-markdown.nvim";
          flake = false;
  };


  forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
  extra_pkg_config = {
    allowUnfree = true;
  };
  inherit (forEachSystem (system: let
    dependencyOverlays = /* (import ./overlays inputs) ++ */ [
      (utils.standardPluginOverlay inputs)
    ];
  in { inherit dependencyOverlays; })) dependencyOverlays;

  categoryDefinitions = { pkgs, settings, categories, name, ... }@packageDef: {

    lspsAndRuntimeDeps = {
      general = with pkgs; [
	        emmet-language-server
          lua-language-server
          gopls
          xclip
          wl-clipboard
          fd
          rust-analyzer
          luajitPackages.lua-lsp
          nodePackages.bash-language-server
          yaml-language-server
          typescript-language-server
          pyright
          marksman
          black
          stylua
          prettierd
          nodePackages.prettier
          mypy
          pylint
          nixfmt-classic
          statix
          deadnix
          nil
          biome

      ];
    };

    startupPlugins = {
      gitPlugins = with pkgs.neovimPlugins = [
 	  oh-lucy-nvim 		  # Default theme
 	  ascii-nvim 		    # Dep for dashboard
 	  vim-rest-console	# Rest Client
          prettier-nvim     # Formatting
          format-on-save
          render-markdown-nvim
      ];
      general = [
      	        # TODO: organize this stuff
	        nvim-lspconfig
	        lsp-zero-nvim
          cmp-nvim-lsp
          cmp-buffer
          cmp-path
          nvim-cmp
          luasnip

	        nvim-treesitter.withAllGrammars
	        nvim-treesitter-context
          nvim-colorizer-lua
	        plenary-nvim
	        nvim-web-devicons
	        nui-nvim
	        neo-tree-nvim
	        nvim-notify
	        noice-nvim
	        playground
	        luasnip
	        nvim-ts-autotag
	        harpoon
	        oil-nvim
	        telescope-nvim
	        undotree
	        yazi-nvim
	        rainbow-delimiters-nvim
	        mini-indentscope
	        transparent-nvim
	        tabline-nvim
	        lualine-nvim
	        fugitive-gitlab-vim
	        gitsigns-nvim
	        oxocarbon-nvim
	        poimandres-nvim
	        dashboard-nvim
	        autoclose-nvim
	        vim-closetag

      ] ++ pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
    };

    optionalPlugins = {
      gitPlugins = with pkgs.neovimPlugins; [ ];
      general = with pkgs.vimPlugins; [ ];
    };

    # shared libraries to be added to LD_LIBRARY_PATH
    # variable available to nvim runtime
    sharedLibraries = {
      general = with pkgs; [
        # libgit2
      ];
    };

    environmentVariables = {
      test = {
        CATTESTVAR = "It worked!";
      };
    };

    extraWrapperArgs = {
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
      test = [
        '' --set CATTESTVAR2 "It worked again!"''
      ];
    };

    # lists of the functions you would have passed to
    # python.withPackages or lua.withPackages

    # get the path to this python environment
    # in your lua config via
    # vim.g.python3_host_prog
    # or run from nvim terminal via :!<packagename>-python3
    extraPython3Packages = {
      test = (_:[]);
    };
    # populates $LUA_PATH and $LUA_CPATH
    extraLuaPackages = {
      test = [ (_:[]) ];
    };

  };

  packageDefinitions = {
    nixCats = {pkgs , ... }: {
      # they contain a settings set defined above
      # see :help nixCats.flake.outputs.settings
      settings = {
        wrapRc = true;
        # IMPORTANT:
        # your alias may not conflict with your other packages.
        aliases = [ "vim" ];
        # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
      };
      # and a set of categories that you want
      # (and other information to pass to lua)
      categories = {
        general = true;
        test = true;
        example = {
          youCan = "add more than just booleans";
          toThisSet = [
            "and the contents of this categories set"
            "will be accessible to your lua with"
            "nixCats('path.to.value')"
            "see :help nixCats"
          ];
        };
      };
    };
  };
  # In this section, the main thing you will need to do is change the default package name
  # to the name of the packageDefinitions entry you wish to use as the default.
    defaultPackageName = "nixCats";
in
  # see :help nixCats.flake.outputs.exports
  forEachSystem (system: let
    nixCatsBuilder = utils.baseBuilder luaPath {
      inherit system dependencyOverlays extra_pkg_config nixpkgs;
    } categoryDefinitions packageDefinitions;
    defaultPackage = nixCatsBuilder defaultPackageName;
    # this is just for using utils such as pkgs.mkShell
    # The one used to build neovim is resolved inside the builder
    # and is passed to our categoryDefinitions and packageDefinitions
    pkgs = import nixpkgs { inherit system; };
  in {
    # this will make a package out of each of the packageDefinitions defined above
    # and set the default package to the one passed in here.
    packages = utils.mkAllWithDefault defaultPackage;

    # choose your package for devShell
    # and add whatever else you want in it.
    devShells = {
      default = pkgs.mkShell {
        name = defaultPackageName;
        packages = [ defaultPackage ];
        inputsFrom = [ ];
        shellHook = ''
        '';
      };
    };

  }) // {

  # these outputs will be NOT wrapped with ${system}

  # this will make an overlay out of each of the packageDefinitions defined above
  # and set the default overlay to the one named here.
  overlays = utils.makeOverlays luaPath {
    # we pass in the things to make a pkgs variable to build nvim with later
    inherit nixpkgs dependencyOverlays extra_pkg_config;
    # and also our categoryDefinitions
  } categoryDefinitions packageDefinitions defaultPackageName;

  # we also export a nixos module to allow reconfiguration from configuration.nix
  nixosModules.default = utils.mkNixosModules {
    inherit defaultPackageName dependencyOverlays luaPath
      categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
  };
  # and the same for home manager
  homeModule = utils.mkHomeModules {
    inherit defaultPackageName dependencyOverlays luaPath
      categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
  };
  inherit utils;
  inherit (utils) templates;
}
