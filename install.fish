#!/usr/bin/env fish

set OS_NAME (uname -s)

if test (basename $SHELL) != fish
  echo "Must be running fish"
  exit 1
end

set -l config_dir $HOME

if not test -d "$config_dir/src/cli_tools"
  if not test -d "$config_dir/src"
    mkdir "$config_dir/src"
  end
  cd "$config_dir/src"
  git clone https://github.com/jfilip/cli_tools.git
  cd -
end

if test "$OS_NAME" = "Darwin"
  set -l iterm_profile_path "$HOME/Library/Application Support/iTerm2/DynamicProfiles"
  set -l iterm_profile_file "iterm_profile-jkitty.json"
  if test -d "$iterm_profile_path"; and not test -f "$iterm_profile_path/$iterm_profile_file"
    ln -s "$PWD/$iterm_profile_file" "$iterm_profile_path/"
  end
end

for rcfile in $PWD/rcfiles/.*
  set -l basename (basename $rcfile)
  if test "$basename" != "."; and test "$basename" != ".."
    if not test -f "$HOME/.$basename"
      ln -s "$rcfile" "$HOME/.$basename"
    end
  end
end

for fish_config_file in $PWD/rcfiles/*.fish
  set -l basename (basename $fish_config_file)
  if not test -f "$HOME/.config/fish/$basename"
    ln -s "$fish_config_file" "$HOME/.config/fish/conf.d/$basename"
  end
end
