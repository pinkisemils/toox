{ nixvim, pkgs, lib, ... }:
let



  kotlin-vim = pkgs.vimUtils.buildVimPlugin {
    name = "kotlin-vim";
    src = pkgs.fetchFromGitHub {
      owner = "udalov";
      repo = "kotlin-vim";
      rev = "f338707b2aa658aef4c0d98fd9748240859cf2a9";
      sha256 = "0wm9bkykvm89f966a8wxm5vvg9kjayy5iziahnch35hrmscs5x4b";
    };
  };
  nvim-bqf = pkgs.vimUtils.buildVimPlugin {
    name = "nvim-bqf";
    src = pkgs.fetchFromGitHub {
      owner = "kevinhwang91";
      repo = "nvim-bqf";
      rev = "30bdaa97748795ae533f1ed1ab0bd11306a79dc7";
      sha256 = "sha256-LbdTulnNuZZejw+OT6Ih4QslQAAiLUGgpSHz0OcuYCE=";
    };
  };

  plantuml-previewer-vim = pkgs.vimUtils.buildVimPlugin {
    name = "plantuml-previewer.vim";
    src = pkgs.fetchFromGitHub {
      owner = "weirongxu";
      repo = "plantuml-previewer.vim";
      rev = "f97c2ec5ab492ecfdb9c702b0252ed7e790b2193";
      sha256 = "sha256-EWTZj0m9wmHnnFqbWJPjbCDGv3qq/s6FLiPuVW/bWkY=";
    };
    propagatedBuildInputs = [ pkgs.openjdk ];
    preFixup = ''
      substituteInPlace "$out"/autoload/plantuml_previewer.vim \
        --replace "executable('java')" "executable('${pkgs.openjdk}/bin/java')";

      substituteInPlace "$out"/script/save-as.sh \
        --replace 'java -Dapple.awt.UIElement=true -jar "$jar_path" ' "\"${pkgs.plantuml}/bin/plantuml\" ";

      substituteInPlace "$out"/script/update-viewer.sh \
        --replace 'java -Dapple.awt.UIElement=true -jar "$jar_path" ' "\"${pkgs.plantuml}/bin/plantuml\" ";

      substituteInPlace "$out"/script/update-viewer.cmd \
        --replace 'java -Dapple.awt.UIElement=true -jar "$jar_path" ' "\"${pkgs.plantuml}/bin/plantuml\" ";

      substituteInPlace "$out"/script/save-as.cmd \
        --replace 'java -Dapple.awt.UIElement=true -jar "$jar_path" ' "\"${pkgs.plantuml}/bin/plantuml\" ";

      substituteInPlace "$out"/script/save-as.sh \
        --replace 'java -Dapple.awt.UIElement=true -jar "$jar_path" ' "\"${pkgs.plantuml}/bin/plantuml\" ";
    '';
  };




in
nixvim.legacyPackages."${pkgs.stdenv.hostPlatform.system}".makeNixvim {

  editorconfig.enable = true;
  plugins = {
    # Some bs changes require this to be enabled now.
    web-devicons.enable = true;

    gitlinker.enable = true;
    fugitive.enable = true;
    nvim-autopairs.enable = true;
    trouble.enable = true;


    # Some AI bs
    avante = {
      enable = true;
      settings = {
        provider = "gemini";
        gemini = {
          # @see https://ai.google.dev/gemini-api/docs/models/gemini
          model = "gemini-1.5-flash-latest";
          # model = "gemini-1.5-flash",
          temperature = 0;
          max_tokens = 4096;
        };
      };
    };
    dressing.enable = true;

    telescope = {
      enable = true;
      keymaps = {
        "<leader>r" = "live_grep";
        "<C-p>" = {
          action = "git_files";
        };
        "<C-\\>" = {
          action = "buffers";
        };
      };
      extensions = {
        ui-select = {
          enable = true;
          settings.codeactions = true;
          # specific_opts.codeactions = true;
        };
      };

    };

    treesitter.enable = true;


    lsp = {
      enable = true;
      keymaps = {
        diagnostic = {
          "<leader>cd" = {
            action = "open_float";
            desc = "Line Diagnostics";
          };
          "[d" = {
            action = "goto_next";
            desc = "Next Diagnostic";
          };
          "]d" = {
            action = "goto_prev";
            desc = "Previous Diagnostic";
          };
        };

        lspBuf = {
          "gra" = "code_action";
          "grd" = "definition";
          "grr" = "references";
          "grt" = "type_definition";
          "gri" = "implementation";
          "K" = "hover";
          "<leader>f" = {
            action = "format";
          };
          "grs" = {
            action = "signature_help";
          };
          "grS" = {
            action = "workspace_symbol";
            desc = "Workspace Symbol";
          };
          "<leader>cr" = {
            action = "rename";
            desc = "Rename";
          };
          "<F2>" = {
            action = "rename";
            desc = "Rename";
          };
        };
      };

      servers = {
        # Average webdev LSPs
        ts_ls.enable = true; # TS/JS
        cssls.enable = true; # CSS
        tailwindcss.enable = true; # TailwindCSS
        html.enable = true; # HTML
        astro.enable = true; # AstroJS
        phpactor.enable = true; # PHP
        pylsp.enable = true; # Python
        marksman.enable = true; # Markdown
        nil_ls = {
          enable = true;
          settings = {
            formatting.command = [ "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt" ];
            nix = {
              flake = {
                autoArchive = true;
              };
            };
          };

        };
        bashls.enable = true; # Bash
        clangd.enable = true; # C/C++
        yamlls.enable = true; # YAML
        gopls.enable = true;

        lua_ls = {
          # Lua
          enable = true;
          settings.telemetry.enable = false;
        };
        nixd = {
          enable = false;
          settings = {
            options.nixvim.expr = ''(builtins.getFlake "/path/to/flake").packages.${pkgs.system}.neovimNixvim.options'';
            formatting.command = [ "nixpkgs-fmt" ];
          };
        };

        # rustaceanvim handles this for me
        # rust-analyzer = {
        #   enable = true;
        #   installRustc = false;
        #   installCargo = false;
        # };
      };

    };
    plantuml-syntax.enable = true;


    airline = {
      enable = true;
      settings = {
        powerline_fonts = 1;
        theme = lib.mkForce "dark";
      };
    };
    commentary.enable = true;
    gitgutter.enable = true;
    markdown-preview.enable = true;
    nix.enable = true;
    vim-surround.enable = true;
    zig.enable = true;
    rustaceanvim = {
      enable = true;
    };

    conform-nvim.enable = true;

  };

  opts = {
    spell = true;
    autoread = true;
    autowrite = true;
    ruler = true;
    incsearch = true;
    hlsearch = true;
    ignorecase = true;
    smartcase = true;
    syntax = "enable";
    showcmd = true;
    hidden = true;

    # start scrolling 10 lines before hitting the bottom of a screen
    scrolloff = 10;
    relativenumber = true;
    number = true;

    tabstop = 2;
    shiftwidth = 2;
    smarttab = true;
    expandtab = true;

  };

  globals.mapleader = "\\";

  keymaps = [
    # escapes insert mode
    {
      mode = "i";
      key = "jj";
      options.silent = true;
      action = "<Esc>";
    }
    # moves right from terminal pane
    {
      mode = "t";
      key = "<C-w>h";
      action = "<C-\\><C-n><C-w>h";
      options.silent = true;
    }
    # moves down from terminal pane
    {
      mode = "t";
      key = "<C-w>j";
      action = "<C-\\><C-n><C-w>j";
      options.silent = true;
    }
    # moves up from terminal pane
    {
      mode = "t";
      key = "<C-w>k";
      action = "<C-\\><C-n><C-w>k";
      options.silent = true;
    }
    # moves to left of terminal pane
    {
      mode = "t";
      key = "<C-w>l";
      action = "<C-\\><C-n><C-w>l";
      options.silent = true;
    }
    # exits terminal mode
    {
      mode = "t";
      key = "<Esc>";
      action = "<C-\\><C-n>";
      options.silent = true;
    }

    # Runs the previous command in a given terminal
    {
      mode = "n";
      key = "<Leader>v";
      action = "i!!<Enter><Enter><C-\\><C-n>";
    }

    # Forces a new line
    {
      mode = "n";
      key = "š";
      action = ":set paste<CR>i<CR><ESC>:set nopaste<CR>";
    }

    # Clears search
    {
      mode = "n";
      key = "<C-l>";
      action = ":nohlsearch<CR>";
    }

    # Highlight last insert
    {
      mode = "n";
      key = "ž";
      action = "`[v`]";
    }

    # Open quickfix buffer
    {
      mode = "n";
      key = "<Leader>e";
      action = ":copen<CR>";
    }

    # Close quickfix buffer
    {
      mode = "n";
      key = "<Leader>E";
      action = ":copen<CR>";
    }

    # Open telescope menu
    {
      mode = "n";
      key = "<Leader>T";
      action = ":Telescope<CR>";
    }

    # Open terminal
    {
      mode = "n";
      key = "<Leader>t";
      action = ":term<CR>";
    }

    # Open fugitive
    {
      mode = "n";
      key = "<Leader>G";
      action = ":Git<CR>";
    }

    # Open Git diff
    {
      mode = "n";
      key = "<Leader>D";
      action = ":Gdiffsplit<CR>";
    }

    # Telsecope open dignostics
    {
      mode = "n";
      key = "<leader>sd";
      action = "<cmd>Telescope diagnostics bufnr=0<cr>";
      options = {
        desc = "Document diagnostics";
      };
    }

    # Telescope open file browser
    {
      mode = "n";
      key = "<leader>fe";
      action = "<cmd>Telescope file_browser<cr>";
      options = {
        desc = "File browser";
      };
    }

    # Telescope open file browser at current path
    {
      mode = "n";
      key = "<leader>fE";
      action = "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>";
      options = {
        desc = "File browser";
      };
    }
  ];


  extraPlugins = with pkgs.vimPlugins; [
    NeoSolarized
    kotlin-vim
    plantuml-previewer-vim
    vim-abolish
    vim-indent-guides
    vim-speeddating
    vim-surround
    vim-toml
    vim-unimpaired
    vim-airline-themes
    vim-sleuth
    registers-nvim
    nvim-bqf
  ];

  colorschemes.base16.enable = true;
  colorschemes.base16.colorscheme = "solarized-light";
  enableMan = true;
  imports = [
    ./ai.nix
    ./completion/cmp.nix
    #   ./nvim/completion/copilot-cmp.nix
    #   ./nvim/completion/lspkind.nix
  ];

  extraConfigLua = ''
    -- Set up airline
    vim.g['airline#extensions#tabline#enabled'] =1
    vim.g['airline#extensions#tabline#show_buffers'] = 1
    vim.g['airline_theme'] = 'solarized'
    vim.g['airline_solarized_bg'] = 'light'

    -- Set up indent guides
    vim.g['indent_guides_start_level'] = 2
    vim.g['indent_guides_guide_size']  = 1
    vim.g['indent_guides_enable_on_vim_startup'] = 1
    vim.g['indent_guides_auto_colors'] = 0
    vim.cmd('colorscheme base16-solarized-light')
  '';
}
