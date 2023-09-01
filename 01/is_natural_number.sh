
function is_natural_number() {
  if [[ "$1" =~ ^[[:space:]]*[+]?[0]*[1-9]+[0-9]*[[:space:]]*$ ]]; then
    return 0
  else
    return 1
  fi
}

