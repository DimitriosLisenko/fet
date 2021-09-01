#!/bin/bash
for i in ${1}/major/*.mid ; do 
  timidity -Ow -o - $i | lame - ${i/mid/mp3}
  # rm $i
done

for i in ${1}/minor/*.mid ; do 
  timidity -Ow -o - $i | lame - ${i/mid/mp3}
  # rm $i
done

mv ${1}/major/*.mp3 ${1}/major/mp3
mv ${1}/minor/*.mp3 ${1}/minor/mp3
