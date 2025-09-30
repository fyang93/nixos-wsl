# Nushell Config File
#
# version = 0.81.1

# let's define some colors

# https://github.com/catppuccin/i3/blob/main/themes/catppuccin-mocha
let rosewater = "#f5e0dc"
let flamingo  = "#f2cdcd"
let pink      = "#f5c2e7"
let mauve     = "#cba6f7"
let red       = "#f38ba8"
let maroon    = "#eba0ac"
let peach     = "#fab387"
let green     = "#a6e3a1"
let teal      = "#94e2d5"
let sky       = "#89dceb"
let sapphire  = "#74c7ec"
let blue      = "#89b4fa"
let lavender  = "#b4befe"
let text      = "#cdd6f4"
let subtext1  = "#bac2de"
let subtext0  = "#a6adc8"
let overlay2  = "#9399b2"
let overlay1  = "#7f849c"
let overlay0  = "#6c7086"
let surface2  = "#585b70"
let surface1  = "#45475a"
let surface0  = "#313244"
let base      = "#1e1e2e"
let mantle    = "#181825"
let crust     = "#11111b"

# we're creating a theme here that uses the colors we defined above.

let catppuccin_theme = {
    separator: $overlay2
    leading_trailing_space_bg: $surface2
    header: $red
    date: $pink
    filesize: $green
    row_index: $text
    bool: $peach
    int: $red
    duration: $sky
    range: $sapphire
    float: $lavender
    string: $text
    nothing: $overlay1
    binary: $subtext1
    cellpath: $subtext0
    hints: dark_gray

    shape_garbage: { fg: $overlay2 bg: $red attr: b}
    shape_bool: $maroon
    shape_int: { fg: $pink attr: b}
    shape_float: { fg: $pink attr: b}
    shape_range: { fg: $overlay0 attr: b}
    shape_internalcall: { fg: $maroon attr: b}
    shape_external: $mauve
    shape_externalarg: { fg: $red attr: b}
    shape_literal: $flamingo
    shape_operator: $rosewater
    shape_signature: { fg: $red attr: b}
    shape_string: $red
    shape_filepath: $peach
    shape_globpattern: { fg: $teal attr: b}
    shape_variable: $pink
    shape_flag: { fg: $mauve attr: b}
    shape_custom: {attr: b}
}

# The default config record. This is where much of your global configuration is setup.
$env.config = {
  color_config: $catppuccin_theme
  use_ansi_coloring: true
  show_banner: false

  table: {
    mode: rounded
    index_mode: always
    show_empty: true
    trim: {
      methodology: wrapping
      wrapping_try_keep_words: true
      truncating_suffix: "..."
    }
  }

  completions: {
    case_sensitive: false
    quick: true
    partial: true
    algorithm: "prefix"
    external: {
      enable: true
      max_results: 100
      completer: null
    }
  }

  cursor_shape: {
    emacs: line
    vi_insert: block
    vi_normal: underscore
  }

  footer_mode: "auto"
  float_precision: 2
  bracketed_paste: true
  edit_mode: emacs
  shell_integration: {
    osc2: true        # Enables OSC 2 for prompt
    osc7: true        # Enables OSC 7 for directory tracking
    osc8: true        # Enables OSC 8 for hyperlinks
    osc9_9: true      # Enables OSC 9;9 for notifications
    osc133: true      # Enables OSC 133 for prompt marks
    reset_application_mode: true  # Resets application mode
  }
  render_right_prompt_on_last_line: false

  keybindings: [
    {
      name: fuzzy_history
      modifier: control
      keycode: char_r
      mode: [emacs, vi_normal, vi_insert]
      event: [
        {
          send: ExecuteHostCommand
          cmd: "commandline edit -r (
            history
              | each { |it| $it.command }
              | uniq
              | reverse
              | str join (char -i 0)
              | fzf --read0 --layout=reverse --height=40% -q (commandline)
              | decode utf-8
              | str trim
          )"
        }
      ]
    }
  ]
}