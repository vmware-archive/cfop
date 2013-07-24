if [[ ! -o interactive ]]; then
    return
fi

compctl -K _cfop cfop

_cfop() {
  local word words completions
  read -cA words
  word="${words[2]}"

  if [ "${#words}" -eq 2 ]; then
    completions="$(cfop commands)"
  else
    completions="$(cfop completions "${word}")"
  fi

  reply=("${(ps:\n:)completions}")
}
