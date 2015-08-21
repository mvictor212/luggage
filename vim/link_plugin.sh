
find src -type d -depth 1 | while read plugin; do
  for dir in doc autoload ftdetect ftplugin plugin syntax; do
    if [ -d "$plugin/$dir" ]; then
      pushd "$dir" > /dev/null
      ls -w1 "../$plugin/$dir" | while read file; do ln -sf "../$plugin/$dir/$file"; echo "../$plugin/$dir/$file"; done
      popd > /dev/null
    fi
  done
done


# cd $1
# 

