import sys
import IPython
from prompt_toolkit.key_binding.vi_state import InputMode, ViState

c.TerminalInteractiveShell.emacs_bindings_in_vi_insert_mode = False
c.TerminalInteractiveShell.timeoutlen = 0.25
c.TerminalInteractiveShell.editing_mode = 'vi'

_ipython_major = int(IPython.__version__.split('.')[0])

if _ipython_major >= 9:
    # IPython 9+ (Python 3.14): pygments-based theme system
    from IPython.utils.PyColorize import linux_theme, theme_table, Theme, Token
    from copy import deepcopy

    _sd = deepcopy(linux_theme)
    _sd.name = "solarized-dark"
    _sd.base = "solarized-dark"
    _sd.extra_style = {
        **linux_theme.extra_style,
        Token.Prompt:        'ansiblue bold',
        Token.PromptNum:     'ansibrightblue bold',
        Token.OutPrompt:     'ansiyellow',
        Token.OutPromptNum:  'ansiyellow bold',
        Token.Header:        'ansibrightred',
        Token.ExcName:       'ansibrightred',
        Token.Filename:      'ansicyan',
        Token.FilenameEm:    'ansibrightcyan',
        Token.Lineno:        'ansigreen',
        Token.LinenoEm:      'ansibrightgreen',
        Token.TbHighlight:   'ansiblack bg:ansiyellow',
    }
    theme_table["solarized-dark"] = _sd
    c.TerminalInteractiveShell.colors = "solarized-dark"

else:
    # IPython 8.x (Python 3.10): legacy ANSI color scheme system
    import token as _token
    import tokenize as _tokenize
    from IPython.utils.PyColorize import ANSICodeColors, ColorScheme, Colors, InputTermColors

    _KEYWORD = _token.NT_OFFSET + 1
    _TEXT    = _token.NT_OFFSET + 2

    ANSICodeColors['Linux'] = ColorScheme(
        'Linux', {
        'header'          : Colors.LightRed,
        _token.NUMBER     : Colors.Purple,
        _token.OP         : Colors.Yellow,
        _token.STRING     : Colors.Cyan,
        _tokenize.COMMENT : Colors.DarkGray,
        _token.NAME       : Colors.Normal,
        _token.ERRORTOKEN : Colors.Red,
        _KEYWORD          : Colors.Blue,
        _TEXT             : Colors.Normal,
        'in_prompt'       : InputTermColors.Blue,
        'in_number'       : InputTermColors.LightBlue,
        'in_prompt2'      : InputTermColors.Blue,
        'in_normal'       : InputTermColors.Normal,
        'out_prompt'      : Colors.Yellow,
        'out_number'      : Colors.LightRed,
        'normal'          : Colors.Normal,
        }
    )
    c.TerminalInteractiveShell.colors = "Linux"
