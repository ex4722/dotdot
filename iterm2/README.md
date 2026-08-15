# iTerm2

iTerm2 keeps its settings in a single prefs domain, not in `~/.config`.
(`~/.config/iterm2` only holds a runtime socket and a symlink — nothing to save.)

`com.googlecode.iterm2.plist` here is the exported prefs, converted from
Apple's binary plist to XML so it diffs in git.

## Restore

Either import it into the prefs domain:

    defaults import com.googlecode.iterm2 ~/.config/iterm2/com.googlecode.iterm2.plist
    killall cfprefsd

...or, after `make` has stowed this package, point iTerm at it directly:
Settings -> General -> Preferences -> "Load preferences from a custom folder or
URL" -> `~/.config/iterm2`.

## Re-export after changing settings

    plutil -convert xml1 -o iterm2/.config/iterm2/com.googlecode.iterm2.plist \
        ~/Library/Preferences/com.googlecode.iterm2.plist

Note that iTerm writes prefs on quit, so quit it first or the export will be stale.
