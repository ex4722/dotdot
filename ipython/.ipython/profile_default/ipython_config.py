import sys
import IPython
from prompt_toolkit.key_binding.vi_state import InputMode, ViState
c.TerminalInteractiveShell.emacs_bindings_in_vi_insert_mode = False
c.TerminalInteractiveShell.timeoutlen = 0.25

from IPython.utils.PyColorize import linux_theme, theme_table, Theme, Token
from copy import deepcopy

_sd = deepcopy(linux_theme)
_sd.name = "solarized-dark"
_sd.extra_style = {
    **linux_theme.extra_style,
    Token.Prompt:              'ansiblue bold',
    Token.PromptNum:           'ansibrightblue bold',
    Token.OutPrompt:           'ansiyellow',
    Token.OutPromptNum:        'ansiyellow bold',
    Token.Header:              'ansibrightred',
    Token.ExcName:             'ansibrightred',
    Token.Filename:            'ansicyan',
    Token.FilenameEm:          'ansibrightcyan',
    Token.Lineno:              'ansigreen',
    Token.LinenoEm:            'ansibrightgreen',
    Token.TbHighlight:         'ansiblack bg:ansiyellow',
}
theme_table["solarized-dark"] = _sd

c.TerminalInteractiveShell.colors = "solarized-dark"
c.TerminalInteractiveShell.editing_mode = 'vi'
