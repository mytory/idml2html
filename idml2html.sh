if [ ! $2 ]; then
  echo "ex) idml2html idmlfile.idml output.html"
  exit
fi

unzip "$1"

for f in Stories/* ; do idml2html.pl "$f" ; printf "\n\n<hr>\n\n" ; done >> "$2"

