# Functional Ear Training
Create midi/mp3 files for functional ear training. Each file will contain a major/minor chord progression, followed by note(s) that you should identify the scale degree of by ear.

## Usage
```sh
ruby main.rb {number_of_degrees} {number_of_exercises} {tempo}
```

`number_of_degrees`: After the chord progression, how many distinct degrees to play. Values from 1 to 11 are allowed. Suggested value: 1.

`number_of_exercises`: How many exercises to generate per progression. Suggested value: 100.

`tempo`: How fast the chord progression + notes play - the faster, the harder. Suggested value: 120.

For example, running the following command:
```sh
ruby main.rb 2 5 120
```
could generate the following files in the root of the project:
```sh
$ find .
...
major/EM_b5(46)_b3(91).mid
major/CM_b2(37)_b5(54).mid
major/DbM_b6(33)_7(36).mid
major/CM_b6(44)_6(57).mid
major/BbM_6(79)_4(87).mid
...
minor/Gm_7(54)_3(95).mid
minor/Ebm_b2(52)_b7(73).mid
minor/Gm_b5(61)_1(79).mid
minor/Fm_7(52)_1(65).mid
minor/Em_6(49)_b2(77).mid
...
```
The file name contains all the information required for the answer. For example, `EM_b5(46)_b3(91).mid`:

`EM`: the chord progression is E Major.

`b5`: the bottom note will be the b5 degree

`(46)`: the MIDI value of the note played is 46 (not required for the answer, but it's there to avoid duplicate filenames)

`b3`: the next note from the bottom will be the b3 degree

`(91)`: the MIDI value of the note played is 91 (not required for the answer, but it's there to avoid duplicate filenames)

These midi files can then be converted to MP3 if required via the `midi_to_mp3.sh` script.

The midi/mp3 files can then be placed on shuffle in an audio player and drilled.

## Installing Dependencies
### OS X
```
brew install timidity lame
```
