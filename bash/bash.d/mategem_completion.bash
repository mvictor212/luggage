cdgem()
{
  local path="$(gem environment gemdir)/gems/$1"
  if [ -d "$path" ]; then
    cd "$path"
  else
    echo "No such gem: $path"
  fi
}

_cdgem()
{
    local curw
    COMPREPLY=()
    curw=${COMP_WORDS[COMP_CWORD]}
    local gems="$(gem environment gemdir)/gems"
    COMPREPLY=($(compgen -W '$(ls $gems)' -- $curw));
    return 0
}
complete -F _cdgem -o dirnames cdgem

mategem()
{
  local path="$(gem environment gemdir)/gems/$1"
  if [ -d "$path" ]; then
    mate "$path"
  else
    echo "No such gem: $path"
  fi
}

_mategem()
{
    local curw
    COMPREPLY=()
    curw=${COMP_WORDS[COMP_CWORD]}
    local gems="$(gem environment gemdir)/gems"
    COMPREPLY=($(compgen -W '$(ls $gems)' -- $curw));
    return 0
}
complete -F _mategem -o dirnames mategem
