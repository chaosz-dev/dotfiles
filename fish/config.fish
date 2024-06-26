if status is-interactive
    # Commands to run in interactive sessions can go here
end

function fish_prompt
  # git stuff
  set -g __fish_git_prompt_showdirtystate 1
  set -g __fish_git_prompt_showupstream auto
  set -g __fish_git_prompt_showuntrackedfiles 1
  set -g __fish_git_prompt_show_informative_status 0

  # vscode can use fish
  string match -q "$TERM_PROGRAM" "vscode"
  and . (code --locate-shell-integration-path fish)

  # my scripts

  set_color green; echo -n (whoami)
  set_color white; echo -n @
  set_color blue; echo -n (hostname)" "
  set_color white; echo -n (date '+%Y-%m-%d %H:%M:%S')" "
  set_color blue; echo -n (pwd)
  set_color magenta; echo (fish_git_prompt)
  set_color white; echo "\$ "
end

function fish_right_prompt -d "Write out the right prompt"
  echo \033[0;31m [ $status ]
  set_color white
end

# walrusGen <debug/release> <arch>
function walrusGen

  if test -z "$argv[1]"
    set MODE debug
  else
    set MODE $argv[1]
  end 

  if test -z "$argv[2]"
    set ARCH x64
  else
    set ARCH $argv[2]
  end

  cmake -H. -Bout/$ARCH -DWALRUS_ARCH=$ARCH -DWALRUS_HOST=linux -DWALRUS_MODE=$MODE -DWALRUS_OUTPUT=shell -GNinja
end

# walrusBuild <dir>
function walrusBuild

  if test -z "$argv[1]"
    set DIR out/x64
  else
    set DIR $argv[1]
  end

  ninja -C $DIR
end

function unset
  set -e $argv
end

# aliases

alias cat="bat"

alias ls="eza --color=always --git --no-filesize --icons=always --no-time --no-user --no-permissions"
