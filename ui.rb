require "ruby2d"
require "./lib/fet"

set(title: "FET")

background_color = Fet::Ui::ColorScheme::BLACK
black_key_color = Fet::Ui::ColorScheme::GREY
white_key_color = Fet::Ui::ColorScheme::WHITE
red_key_color = Fet::Ui::ColorScheme::RED
green_key_color = Fet::Ui::ColorScheme::GREEN

set(background: background_color)
white_key_root = 60

@note_boxes = {
  ["1"] => Fet::Ui::NoteBox.new(x: (white_key_root + 75 * 0), y: 325, size: 70, correct: false, color: white_key_color, text: "1", midi_file: "./notes/CM_1(C4).mid"),
  ["2"] => Fet::Ui::NoteBox.new(x: (white_key_root + 75 * 1), y: 325, size: 70, correct: false, color: white_key_color, text: "2", midi_file: "./notes/CM_2(D4).mid"),
  ["3"] => Fet::Ui::NoteBox.new(x: (white_key_root + 75 * 2), y: 325, size: 70, correct: true, color: white_key_color, text: "3", midi_file: "./notes/CM_3(E4).mid"),
  ["4"] => Fet::Ui::NoteBox.new(x: (white_key_root + 75 * 3), y: 325, size: 70, correct: false, color: white_key_color, text: "4", midi_file: "./notes/CM_4(F4).mid"),
  ["5"] => Fet::Ui::NoteBox.new(x: (white_key_root + 75 * 4), y: 325, size: 70, correct: false, color: white_key_color, text: "5", midi_file: "./notes/CM_5(G4).mid"),
  ["6"] => Fet::Ui::NoteBox.new(x: (white_key_root + 75 * 5), y: 325, size: 70, correct: false, color: white_key_color, text: "6", midi_file: "./notes/CM_6(A4).mid"),
  ["7"] => Fet::Ui::NoteBox.new(x: (white_key_root + 75 * 6), y: 325, size: 70, correct: false, color: white_key_color, text: "7", midi_file: "./notes/CM_7(B4).mid"),

  ["#1", "b2"] => Fet::Ui::NoteBox.new(x: (white_key_root + (75 / 2.0) * 1), y: 250, correct: false, size: 70, color: black_key_color, text: "b2", midi_file: "./notes/CM_b2(Db4).mid"),
  ["#2", "b3"] => Fet::Ui::NoteBox.new(x: (white_key_root + (75 / 2.0) * 3), y: 250, correct: false, size: 70, color: black_key_color, text: "b3", midi_file: "./notes/CM_b3(Eb4).mid"),
  ["#4", "b5"] => Fet::Ui::NoteBox.new(x: (white_key_root + (75 / 2.0) * 7), y: 250, correct: false, size: 70, color: black_key_color, text: "b5", midi_file: "./notes/CM_b5(Gb4).mid"),
  ["#5", "b6"] => Fet::Ui::NoteBox.new(x: (white_key_root + (75 / 2.0) * 9), y: 250, correct: false, size: 70, color: black_key_color, text: "b6", midi_file: "./notes/CM_b6(Ab4).mid"),
  ["#6", "b7"] => Fet::Ui::NoteBox.new(x: (white_key_root + (75 / 2.0) * 11), y: 250, correct: false, size: 70, color: black_key_color, text: "b7", midi_file: "./notes/CM_b7(Bb4).mid"),
}

@note_boxes.values.each(&:draw)

Text.new(
  "1",
  x: 88, y: 337,
  font: "./assets/fonts/PTSans-Regular.ttf",
  size: 36,
  color: black_key_color,
)
Text.new(
  "2",
  x: 162, y: 337,
  font: "./assets/fonts/PTSans-Regular.ttf",
  size: 36,
  color: black_key_color,
)
Text.new(
  "3",
  x: 236, y: 337,
  font: "./assets/fonts/PTSans-Regular.ttf",
  size: 36,
  color: black_key_color,
)
Text.new(
  "4",
  x: 310, y: 337,
  font: "./assets/fonts/PTSans-Regular.ttf",
  size: 36,
  color: black_key_color,
)
Text.new(
  "5",
  x: 387, y: 337,
  font: "./assets/fonts/PTSans-Regular.ttf",
  size: 36,
  color: black_key_color,
)
Text.new(
  "6",
  x: 462, y: 337,
  font: "./assets/fonts/PTSans-Regular.ttf",
  size: 36,
  color: black_key_color,
)
Text.new(
  "7",
  x: 537, y: 337,
  font: "./assets/fonts/PTSans-Regular.ttf",
  size: 36,
  color: white_key_color,
)
Text.new(
  "b2",
  x: 114, y: 262,
  font: "./assets/fonts/PTSans-Regular.ttf",
  size: 36,
  color: white_key_color,
)
Text.new(
  "b3",
  x: 188, y: 262,
  font: "./assets/fonts/PTSans-Regular.ttf",
  size: 36,
  color: white_key_color,
)
Text.new(
  "b5",
  x: 338, y: 262,
  font: "./assets/fonts/PTSans-Regular.ttf",
  size: 36,
  color: white_key_color,
)
Text.new(
  "b6",
  x: 413, y: 262,
  font: "./assets/fonts/PTSans-Regular.ttf",
  size: 36,
  color: white_key_color,
)
Text.new(
  "b7",
  x: 488, y: 262,
  font: "./assets/fonts/PTSans-Regular.ttf",
  size: 36,
  color: white_key_color,
)

on :mouse_down do |event|
  @note_boxes.each_value { |note_box| note_box.handle_event(event) }
end

on :key_down do |event|
  @note_boxes.each_value { |note_box| note_box.handle_event(event) }
end

update do
end

show
