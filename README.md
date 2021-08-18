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
./listening/major/DbM_b6(Bbb2)_5(Ab5).mid
./listening/major/BbM_7(A4)_2(C6).mid
./listening/major/EM_b6(C2)_3(G#2).mid
./listening/major/GbM_6(Eb4)_3(Bb5).mid
./listening/major/FM_6(D4)_3(A5).mid
...
./listening/minor/Dm_b7(C3)_1(D4).mid
./listening/minor/F#m_b2(G2)_3(A#4).mid
./listening/minor/G#m_b6(E1)_b2(A2).mid
./listening/minor/Dm_6(B0)_7(C#3).mid
./listening/minor/C#m_5(G#4)_6(A#4).mid
...
```
The file name contains all the information required for the answer. For example, `EM_b6(C2)_3(G#2).mid`:

`EM`: the chord progression is in E Major.

`b6`: the bottom note will be the b6 degree

`(C2)`: the [scientific pitch notation](https://en.wikipedia.org/wiki/Scientific_pitch_notation) of which is C2

`3`: the next note from the bottom will be the 3 degree

`(G#2)`: the [scientific pitch notation](https://en.wikipedia.org/wiki/Scientific_pitch_notation) of which is G#2

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
