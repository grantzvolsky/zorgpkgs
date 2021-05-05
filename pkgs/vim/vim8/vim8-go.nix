{ vim_configurable, python3, pkgs, name ? "vim-go" }:
let
  my_vim_preferences = ''
    " Use <c-space> to trigger completion.
    inoremap <silent><expr> <c-space> coc#refresh()
    nmap <leader>qf  <Plug>(coc-fix-current)
    " Remap keys for gotos
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)
    " fix purple text on purple background
    hi link CocFloating markdown
  '' + builtins.readFile ./common.vimrc;

  my_vc = vim_configurable.override { python = python3; };

  my_vim = my_vc.customize {
    name = name;
    vimrcConfig = {
      customRC = ''
      '' + my_vim_preferences;

      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [ coc-nvim coc-go fzf-vim fzfWrapper ];
      };
    };
  };
in my_vim
