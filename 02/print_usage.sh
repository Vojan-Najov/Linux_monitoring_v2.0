
function print_usage() {
  echo
  echo "Usage:"
  echo "The script is run with 3 parameters."
  echo "An example of running a script:"
  echo "$> ./main.sh az az.az 3Mb"
  echo
  echo "Parameter 1 is a list of English alphabet letters used in folder names "`
       `"(no more than 7 characters)."
  echo "Parameter 2 the list of English alphabet letters used in the file name "`
       `"and extension (no more than 7 characters for the name, no more than 3 "`
       `"characters for the extension)."
  echo "Parameter 3 - is the file size (in Megabytes, but not more than 100)."
}

