package clitimetracker

import "core:encoding/json"
import "core:log"
import "core:os"


DATA_FILEPATH : string : "data/data.json"


get_timers :: proc() -> []Timer {
  parsed_data: [dynamic]Timer = parse_data(read_data_file())
  return parsed_data[:]
}

write_timer :: proc(timer: ^Timer) {
  present_data: [dynamic]Timer = parse_data(read_data_file())
  append(&present_data, timer^)

  options: json.Marshal_Options
  options.pretty = true
  options.use_spaces = true
  options.spaces = 0
  
  bytes, marshal_err := json.marshal(present_data, opt=options)

  if marshal_err != nil {
    log.panicf("Couldn't marshal the timer: %v in to the array!", timer)
  }

  os.write_entire_file(DATA_FILEPATH, bytes[:])
}

@(private)
read_data_file :: proc() -> []u8 {
  data, read_success := os.read_entire_file_from_filename(DATA_FILEPATH)

  if !read_success {
    log.panicf("Could not open file at %s!", DATA_FILEPATH)
  }

  return data
}

@(private)
parse_data :: proc(data: []u8) -> [dynamic]Timer {
  array_of_timers: [dynamic]Timer
  parsed_data := json.unmarshal(data, &array_of_timers)

  return array_of_timers
}
