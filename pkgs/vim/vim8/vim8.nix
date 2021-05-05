#with import <nixpkgs> {};
{ vim_configurable, python3, pkgs, name ? "vim" }:
let
  common_vim_preferences = builtins.readFile ./common.vimrc;
  og_vim_preferences = builtins.readFile ./vim.vimrc;

  ale_preferences = ''
    set signcolumn=yes
    hi clear SignColumn
  '';

  my_vc = vim_configurable.override { python = python3; };

  my_vim = my_vc.customize {
    name = name;
    vimrcConfig = {
      customRC = ''
         " let g:LanguageClient_serverCommands = { 'python': ['pyls'] }
         nnoremap <F5> :call LanguageClient_contextMenu()<CR>
         nnoremap <silent> gh :call LanguageClient_textDocument_hover()<CR>
         nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
         nnoremap <silent> gr :call LanguageClient_textDocument_references()<CR>
         nnoremap <silent> gs :call LanguageClient_textDocument_documentSymbol()<CR>
         " nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
         nnoremap <silent> gf :call LanguageClient_textDocument_formatting()<CR>
      '' + common_vim_preferences + og_vim_preferences + ale_preferences;

      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [ ale LanguageClient-neovim fzf-vim fzfWrapper ];
      };
    };
  };
in my_vim
