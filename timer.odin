package clitimetracker

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:time"

/*
No args && timer !running -> start timer else pause timer.

--deadline <-> -d <deadline>                        The deadline at which the timer will stop.
--pause <-> -p                                      Pause current running timer.
--preport <project_name> <-> -pr                    Shows timers and total time for the passed project.
--project <-> -P <project_name>                     The project name that this timer belongs to.
--projects <-> -lp                                  Show list of projects.
--report <-> -r                                     Shows the total for each project and tag.
--stop <-> -s                                       Resets current running timer and saves the data.
--tag <-> -t <tag_name>                             The tag that is attributed to the current timer.
--tags <-> -lt                                      Show list of tags.
--timer <timer_title> <-> -ti <timer_title>         Gets the timer with specified timer title
--treport <tag_name> <-> -tr                        Shows timers and total time for the passed tag.
--time <-> -T                                       Shows current running timer's time and additional info.
*/

Project :: struct {
  title: string,
  timers: []Timer,
}

Tag :: struct {
  title: string,
  timers: []Timer,
}

Timer :: struct {
  title: string,
  project: string,
  tag: string,
  running: bool,
  start_time: time.Time,
  end_time: time.Time,
  deadline: time.Duration,
}


new_timer :: proc() -> (timer: ^Timer) {
  timer = new(Timer)
  timer.title = ""
  timer.project = ""
  timer.tag = ""
  timer.running = false
  return
}

timer_main :: proc(curr_timer: ^Timer) {
  handle_arguments(curr_timer)
}

@(private)
handle_arguments :: proc(curr_timer: ^Timer) {
  passed_arguments: []string = os.args

  // Skip the running application from arguments list to only have app arguments in the list
  passed_arguments = passed_arguments[1:]
  
  // Check if we ran application without arguments and if the timer is running or not
  if len(passed_arguments) == 0 {
    if curr_timer.running {
      curr_timer.end_time = time.now()
      curr_timer.running = false
      return
    }
  }

  for arg, arg_id in passed_arguments {
    arg_identifier: string = "-"

    if arg[0] == arg_identifier[0] {
      // Value that fol lows after the arguments
      value: string = passed_arguments[arg_id + 1]

      switch arg {
        case "--deadline", "-d":
          set_deadline(curr_timer, value)
        case "--preport", "-pr":
          show_report(value, true)
        case "--project", "-P":
          set_project(curr_timer, value)
        case "--report", "-r":
          show_report()
        case "--tag", "-t":
          set_tag(curr_timer, value)
        case "--treport", "-tr":
          show_report(value, false)
        case "--pause", "-p":
          curr_timer.end_time = time.now()
        case "--stop", "-s":
          save_and_stop_timer(curr_timer)
        case "--timer", "-ti":
          get_timer(value)
      }
    }
  }

  curr_timer.start_time = time.now()
  curr_timer.running = true

  // Elapsed time is calculated in seconds
  elapsed_duration: time.Duration = 0
  timer_time: time.Time = time.from_nanoseconds(0)

  for curr_timer.running {
    timer_buf: [time.MIN_HMS_LEN]u8
    deadline_buf: [time.MIN_HMS_LEN]u8
  
    run_timer(&timer_time)
    elapsed_duration += 1e9
    
    elapsed_time: time.Time = time.time_add(curr_timer.start_time, elapsed_duration)
    deadline_time: time.Time = time.time_add(curr_timer.start_time, curr_timer.deadline)

    elapsed_time_string: string = time.to_string_hms(elapsed_time, timer_buf[:])
    deadline_time_string: string = time.to_string_hms(deadline_time, deadline_buf[:])

    if elapsed_time_string == deadline_time_string {
      fmt.printfln("/rTime has run out! You've reached the deadline!\t")
      curr_timer.running = false
      break
    }
  }
}

@(private)
run_timer :: proc(timer_time: ^time.Time) {
  time.sleep(1e9)

  time_buf: [time.MIN_HMS_LEN]u8
  timer_time^ = time.time_add(
    timer_time^, cast(time.Duration)1e9
  )
  timer_time_string: string = time.time_to_string_hms(timer_time^, time_buf[:]) 

  fmt.printf("\rTime: %s\t", timer_time_string)
}

@(private)
get_timer :: proc(timer_title: string) {

}

@(private)
save_and_stop_timer :: proc(timer: ^Timer) {

}

@(private)
set_deadline :: proc(timer: ^Timer, deadline: string) {
  minutes: i64 = i64(strconv.atoi(deadline))
  nsecs_from_minutes := minutes * 60 * 1e9
  timer.deadline = cast(time.Duration)nsecs_from_minutes
}

@(private)
set_project :: proc(timer: ^Timer, project_name: string) {
  timer.project = project_name
}

@(private)
set_tag :: proc(timer: ^Timer, tag_name: string) {
  timer.tag = tag_name
}

// Reports
@(private)
show_report :: proc {
  show_overall_report, show_report_by_project_or_tag
}

@(private)
show_overall_report :: proc() {

}

@(private)
show_report_by_project_or_tag :: proc(title: string, is_project: bool) {
  if is_project {
    show_report_by_project(title)
    return
  }

  show_report_by_tag(title)
}

@(private)
show_report_by_project :: proc(project_name: string) {

}

@(private)
show_report_by_tag :: proc(tag_name: string) {

}
