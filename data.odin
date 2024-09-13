package clitimetracker

import "core:encoding/json"
import "core:log"
import "core:os"


DATA_FILEPATH : string : "data/data.json"


open_data_file :: proc() {
  data_file, read_err := os.read_entire_file_from_filename(DATA_FILEPATH, os.O_CREATE | os.O_RDWR, 0o665)

  if read_err != os.ERROR_NONE {
    log.panicf("Could not open file at %s!", DATA_FILEPATH)
  }

  // Read data in data_file
}
