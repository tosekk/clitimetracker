package clitimetracker

import "core:fmt"
import "core:log"
import "core:os"
import "core:time"


create_logger :: proc() -> (log.Logger, os.Handle) {
  // Setting up a logger
  date_buffer: [time.MIN_YY_DATE_LEN]byte
  curr_date := time.to_string_dd_mm_yy(time.now(), date_buffer[:])
  log_filename: string = fmt.tprintf("logs/%s.log", curr_date)
  
  log_file, log_file_open_err := os.open(log_filename, os.O_CREATE | os.O_WRONLY, 0o665)
  if log_file_open_err != os.ERROR_NONE {
    log.panicf("Could not open file - %s!", log_filename)
  }
  
  logger := log.create_multi_logger(
    log.create_console_logger(),
    log.create_file_logger(log_file)
  )

  return logger, log_file
}
