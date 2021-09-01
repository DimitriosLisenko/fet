[![codecov](https://codecov.io/gh/DimitriosLisenko/fet/branch/master/graph/badge.svg?token=6W2B0Z4E4S)](https://codecov.io/gh/DimitriosLisenko/fet)

# FET (Functional Ear Trainer)
Create MIDI files for functional ear training. Each file will contain a major/minor chord progression, followed by note(s) that you should identify the scale degree of by ear.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'fet'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install fet

## Usage
Refer to [https://github.com/DimitriosLisenko/fet/blob/master/fet.rdoc](the rdoc) for detailed usage instructions and descriptions of commands.

## Filename Format
The generators will currently create MIDI files. The correct answer is included in the filename.

### Listening exercises
For listening exercises, here is a potential list of generated MIDI files (for 2 degrees):
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

### Singing exercises
The singing exercises will generate all possible combinations for keys and degrees as follows:
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

### Single Note Listening exercises
For single note listening exercises, the same note is played across all possible keys:
```sh
$ find .
...
./listening_single_note/major/CM_1.mid
./listening_single_note/major/BM_b2.mid
./listening_single_note/major/F#M_b5.mid
...
./listening_single_note/minor/Am_b3.mid
./listening_single_note/minor/G#m_3.mid
./listening_single_note/minor/Cm_1.mid
...
```
The file name contains all the information required for the answer. For example, `G#m_3.mid`:

`G#m`: the chord progression is in G# Minor.

`3`: the note that is played is the 3rd degree in this key.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/DimitriosLisenko/fet.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
