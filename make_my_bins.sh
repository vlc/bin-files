clean_link() 
{
  rm $2
  ln -s $1 $2
}

curl -s "https://raw.github.com/nkpart/selecta/master/selecta" -o selecta
chmod +x selecta
clean_link selecta produca

curl -s "https://raw.github.com/ghc-ios/ghc-ios-scripts/master/clang-xcode5-wrapper.hs" -o clang-xcode5-wrapper.hs
ghc --make clang-xcode5-wrapper.hs -hidir /tmp -odir /tmp

curl -s "https://gist.github.com/nkpart/7002846/raw/de797d32fb313386dc2f4bb065e84ff631279a0a/bijecta" -o bijecta
chmod +x bijecta

