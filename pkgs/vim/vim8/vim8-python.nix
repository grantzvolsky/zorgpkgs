#with import <nixpkgs> {};
#let
#  #newpkgs = import (builtins.fetchTarball { # TODO either wait for nvim 0.5 to be released or build it
#  #  name = "nixpkgs-20-09";
#  #  url = "https://github.com/NixOS/nixpkgs/archive/f03649db6a1f2dc079004020c3287aa679769a75.tar.gz";
#  #  # Hash obtained using `nix-prefetch-url --unpack <url>`
#  #  sha256 = "1ryc565jyv70md0jn39psdsxsq3a205gh30y85f7x3z84v7ix1i4";
#  #}) {};
#
#  my_vim_preferences = ''
#    set background=dark
#  '';
#
#  my_pyls = (python3.withPackages(ps: [
#    ps.python-language-server
#    # the following plugins are optional, they provide type checking, import sorting and code formatting
#    ps.pyls-mypy ps.pyls-isort ps.pyls-black
#
#    #ps.cx_oracle
#    ps.numpy
#    ps.pandas
#    ps.lxml
#  ]));
#
#  my_vc = vim_configurable.override { python = python3; };
#
#  my_vim = my_vc.customize {
#    name = "ep";
#    vimrcConfig = {
#      customRC = ''
#        nmap <C-w>- :sp<CR>
#        nmap <C-w><Bar> :vsp<CR>
#        nmap <C-h> <C-w>h
#        nmap <C-j> <C-w>j
#        nmap <C-k> <C-w>k
#        nmap <C-l> <C-w>l
#        nmap <S-Tab> :b#<CR>
#        let g:LanguageClient_serverCommands = {
#          \ 'python': ['pyls']
#          \ }
#        nnoremap <F5> :call LanguageClient_contextMenu()<CR>
#        nnoremap <silent> gh :call LanguageClient_textDocument_hover()<CR>
#        nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
#        nnoremap <silent> gr :call LanguageClient_textDocument_references()<CR>
#        nnoremap <silent> gs :call LanguageClient_textDocument_documentSymbol()<CR>
#        nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
#        nnoremap <silent> gf :call LanguageClient_textDocument_formatting()<CR>
#      '' + my_vim_preferences;
#      packages.myVimPackage = with pkgs.vimPlugins; {
#        start = [ LanguageClient-neovim ];
#      };
#    };
#  };
#in pkgs.stdenv.mkDerivation {
#  name = "ep";
#  nativeBuildInputs = [ my_vim my_pyls ];
#  #shellHook = ''
#  #  set -o vi
#  #  #python -m venv .venv
#  #  #source .venv/bin/activate
#  #  #pip install -r requirements.txt
#  #'';
#}

with import <nixpkgs> {};
{ python3, pkgs, name ? "vim8-python" }:
let
  newpkgs = import (builtins.fetchTarball { # TODO either wait for nvim 0.5 to be released or build it
    name = "nixpkgs-20-09";
    url = "https://github.com/NixOS/nixpkgs/archive/f03649db6a1f2dc079004020c3287aa679769a75.tar.gz";
    # Hash obtained using `nix-prefetch-url --unpack <url>`
    sha256 = "1ryc565jyv70md0jn39psdsxsq3a205gh30y85f7x3z84v7ix1i4";
  }) {};
  ale_preferences = ''
    set signcolumn=yes
    hi clear SignColumn
  '';

  my_pyls = (python3.withPackages(ps: [
    ps.python-language-server
    # the following plugins are optional, they provide type checking, import sorting and code formatting
    ps.pyls-mypy ps.pyls-isort ps.pyls-black

    ps.numpy
    ps.pandas
  ]));

  common_vim_preferences = builtins.readFile ../common.vimrc;
  vim8_preferences = builtins.readFile ./vim8.vimrc;
  vim8_base = vim_configurable.override { python = python3; };

  my_vim8 = vim8_base.customize {
    name = name;
    vimrcConfig = {
      customRC = ''
        let g:LanguageClient_serverCommands = {
          \ 'python': ['pyls']
          \ }
         nnoremap <F5> :call LanguageClient_contextMenu()<CR>
         nnoremap <silent> gh :call LanguageClient_textDocument_hover()<CR>
         nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
         nnoremap <silent> gr :call LanguageClient_textDocument_references()<CR>
         nnoremap <silent> gs :call LanguageClient_textDocument_documentSymbol()<CR>
         nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
         nnoremap <silent> gf :call LanguageClient_textDocument_formatting()<CR>
      '' + common_vim_preferences + vim8_preferences;
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [ LanguageClient-neovim ];
      };
    };
  };
in pkgs.symlinkJoin {
  name = name;
  paths = [ ];
  buildInputs = [ my_vim8 my_pyls ];
  postBuild = ''
    mkdir $out/bin
    ln -s ${my_pyls}/bin/pyls $out/bin/pyls
    ln -s ${my_vim8}/bin/${name} $out/bin/${name}
  '';
}
#  my_neovim = newpkgs.neovim.override {
#    configure = {
#      customRC = ''
#         let g:LanguageClient_serverCommands = { 'python': ['pyls'] }
#         nnoremap <F5> :call LanguageClient_contextMenu()<CR>
#         nnoremap <silent> gh :call LanguageClient_textDocument_hover()<CR>
#         nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
#         nnoremap <silent> gr :call LanguageClient_textDocument_references()<CR>
#         nnoremap <silent> gs :call LanguageClient_textDocument_documentSymbol()<CR>
#         " nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
#         nnoremap <silent> gf :call LanguageClient_textDocument_formatting()<CR>
#      '' + common_vim_preferences + neovim_preferences + ale_preferences;
#
#      packages.myVimPackage = with newpkgs.vimPlugins; {
#        start = [ ale LanguageClient-neovim fzf-vim fzfWrapper ];
#      };
#    };
#  };
#in pkgs.linkFarmFromDrvs "${name}" [ my_vim8 my_pyls ]
#in pkgs.linkFarm "${name}" [
#  {
#    name = "${name}-vim8";
#    path = my_vim8;
#  }
#  {
#    name = "${name}-pyls";
#    path = my_pyls;
#  }
#]

#in pkgs.symlinkJoin { # https://nixos.wiki/wiki/Nix_Cookbook#Wrapping_packages
#  name = name;
#
##  nativeBuildInputs = [ my_vim8 my_pyls ];
#  paths = [ my_vim8 my_pyls ];
##  postBuild = ''ls -la $out'';
##  postBuild = ''ln -sf $out/bin/pyls $out/bin/pyls'';
#}

#in pkgs.mkShell {
#  name = "ep";
#  nativeBuildInputs = [ my_vim my_pyls ];
#  shellHook = ''
#    set -o vi
#    #python -m venv .venv
#    #source .venv/bin/activate
#    #pip install -r requirements.txt
#  '';
#}
