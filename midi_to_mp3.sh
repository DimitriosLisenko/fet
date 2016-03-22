#!/bin/bash
for i in major/*.mid ; do 
	timidity -Ow -o - $i | lame - ${i/mid/mp3}
	# rm $i
done

for i in minor/*.mid ; do 
	timidity -Ow -o - $i | lame - ${i/mid/mp3}
	# rm $i
done

mv major/*.mp3 major/mp3
mv minor/*.mp3 minor/mp3
