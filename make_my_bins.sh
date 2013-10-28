clean_link() 
{
  rm $2
  ln -s $1 $2
}

curl -s "https://raw.github.com/nkpart/selecta/master/selecta" -o selecta
clean_link selecta produca
