
function is_alphabet() {
  if [[ "$1" =~ ^[A-Za-z]+$ ]]; then
    return 0
  else
    return 1
  fi
}

