# Functional Ear Training
Create midi/mp3 files for functional ear training. Each file will contain a major/minor chord progression, followed by note(s) that you should identify the scale degree of by ear.

## Usage
### Listening Exercises
```sh
ruby generate_listening_exercises.rb {number_of_degrees} {number_of_exercises} {tempo}
```

`number_of_degrees`: After the chord progression, how many distinct degrees to play. Values from 1 to 11 are allowed. Suggested value: 1.

`number_of_exercises`: How many exercises to generate per progression. Suggested value: 100.

`tempo`: How fast the chord progression + notes play - the faster, the harder the exercise is. Suggested value: 120.

For example, running the following command:
```sh
ruby generate_listening_exercises.rb 2 5 120
```
could generate the following files in the root of the project:
```sh
$ find .
...
listening/major/EM_b5(46)_b3(91).mid
listening/major/CM_b2(37)_b5(54).mid
listening/major/DbM_b6(33)_7(36).mid
listening/major/CM_b6(44)_6(57).mid
listening/major/BbM_6(79)_4(87).mid
...
listening/minor/Gm_7(54)_3(95).mid
listening/minor/Ebm_b2(52)_b7(73).mid
listening/minor/Gm_b5(61)_1(79).mid
listening/minor/Fm_7(52)_1(65).mid
listening/minor/Em_6(49)_b2(77).mid
...
```
The file name contains all the information required for the answer. For example, `EM_b5(46)_b3(91).mid`:

`EM`: the chord progression is in E Major.

`b5`: the bottom note will be the b5 degree

`(46)`: the MIDI value of the note played is 46 (not required for the answer, but it's there to avoid duplicate filenames)

`b3`: the next note from the bottom will be the b3 degree

`(91)`: the MIDI value of the note played is 91 (not required for the answer, but it's there to avoid duplicate filenames)

These midi files can then be converted to MP3 if required via:
```
midi_to_mp3.sh listening
```

The midi/mp3 files can then be placed on shuffle in an audio player and drilled.

### Singing Exercises
```sh
ruby generate_singing_exercises.rb {tempo} {sleep_duration}
```

`tempo`: How fast the chord progression + notes play - the faster, the harder the exercise is. Suggested value: 120.

`sleep_duration`: After the chord progression, how many seconds to wait before playing the answer so you can compare it with what you sang. Values from 1 to 60 are allowed. Suggested value: 3.


For example, running the following command:
```sh
ruby generate_singing_exercises.rb 120 3
```
will generate all possible combinations for keys and degrees in the root of the project:
```sh
$ find .
...
./singing/major/AM_1.mid
./singing/major/BbM_3.mid
./singing/major/CM_4.mid
./singing/major/CM_5.mid
./singing/major/BbM_2.mid
...
./singing/minor/Am_1.mid
./singing/minor/Bbm_3.mid
./singing/minor/Cm_4.mid
./singing/minor/G#m_4.mid
./singing/minor/F#m_1.mid
...
```
The file name contains all the information required for the answer. For example, `BbM_3.mid`:

`BbM`: the chord progression is in Bb Major.

`3`: you should sing the 3rd degree.

These midi files can then be converted to MP3 if required via:
```
midi_to_mp3.sh singing
```

The midi/mp3 files can then be placed on shuffle in an audio player and drilled.

## Installing Dependencies
### OS X
```
brew install timidity lame
```
