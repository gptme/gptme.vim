# gptme.vim

A Vim plugin for [gptme][gptme] integration, allowing you to interact with gptme directly from your editor.

## Features

- Run gptme queries with context from your current buffer
- Automatically includes surrounding lines as context
- Results shown in a new buffer
- Configurable context size and key mappings

## Installation

The plugin assumes you have [gptme][gptme] installed and available in your PATH.

### Using a Plugin Manager

#### [vim-plug](https://github.com/junegunn/vim-plug)

Add this to your `.vimrc`:

    Plug 'ErikBjare/gptme.vim'

Then run:

    :PlugInstall

## Usage

The plugin provides both a command and a default mapping:

- `:Gptme` - Prompts for input and runs gptme with context
- `<Leader>g` - Same as `:Gptme`

When invoked, it will:
1. Prompt for your input
1. Get lines around cursor as context
1. Get file content as context
1. Run gptme with the prompt and context interactively in a new buffer

## Configuration

You can configure the following settings in your `.vimrc`:

### Context Lines

Set the number of context lines to include before and after cursor (default: 3):

    let g:gptme_context_lines = 5

### Terminal Window Position

Configure how the terminal window opens (default: auto-detected based on window width):

    let g:gptme_terminal_position = 'vertical'  " or 'horizontal'

### Terminal Window Size

Set the size of the terminal window in columns (vertical) or lines (horizontal):

    let g:gptme_terminal_size = 80  " default: 80 columns for vertical, 15 lines for horizontal

### Key Mappings

Disable default key mappings:

    let g:gptme_no_mappings = 1

If you disable the default mappings, you can set your own:

    nnoremap <Leader>G :Gptme<CR>

## Development

If you're working on improving this plugin, you can use your development version instead of the installed version:

### Option 1: Start Vim with the dev version

```shell
vim -c "set runtimepath+=/path/to/your/gptme.vim"
```

This adds the development directory to Vim's runtime path for that session only.

### Option 2: Modify your plugin manager configuration

If you're using vim-plug, you can temporarily modify your `.vimrc`:

```vim
" Comment out the GitHub version
" Plug 'ErikBjare/gptme.vim'
" Add the local version
Plug '~/path/to/your/gptme.vim'
```

Then run `:PlugUpdate` to use the local version.

## License

Same as Vim itself - see `:help license`

[gptme]: https://gptme.org
