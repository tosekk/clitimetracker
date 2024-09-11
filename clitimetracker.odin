package clitimetracker

import "core:fmt"
import "core:log"
import "core:mem"
import "core:os"


main :: proc() {
  // Setting up allocator
  tracking_allocator: mem.Tracking_Allocator
  mem.tracking_allocator_init(&tracking_allocator, context.allocator)
  defer mem.tracking_allocator_destroy(&tracking_allocator)
  context.allocator = mem.tracking_allocator(&tracking_allocator)

  // Setting up a logger
  logger, log_file := create_logger()
  defer os.close(log_file)

  context.logger = logger
  defer {
    log.destroy_multi_logger(context.logger)
    log.destroy_multi_logger(logger)
  }

  // Main logic
  curr_timer := new_timer()

  timer_main(curr_timer)

  // Checking for leaks and bad frees!
  for _, leak in tracking_allocator.allocation_map {
    log.debugf("%v: Leaked %m bytes.\n", leak.location, leak.size)
  }

  for bad_free in tracking_allocator.bad_free_array {
    log.debugf("%v allocation %p was freed badly!\n", bad_free.location, bad_free.memory)
  }

  fmt.println("Closing the app!")
}
