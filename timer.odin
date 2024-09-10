package clitimetracker

import "core:fmt"
import "core:time"
import "core:os"

/*
No args && timer !running -> start timer else pause timer.

--deadline <-> -d <deadline>                        The deadline at which the timer will stop.
--pause <-> -p                                      Pause current running timer.
--preport <project_name> <-> -pr                    Shows timers and total time for the passed project.
--project <-> -P <project_name>                    The project name that this timer belongs to.
--projects <-> -lp                                  Show list of projects.
--report <-> -r                                     Shows the total for each project and tag.
--stop <-> -s                                       Resets current running timer and saves the data.
--tag <-> -t <tag_name>                             The tag that is attributed to the current timer.
--tags <-> -lt                                      Show list of tags.
--timer <timer_title> <-> -ti <timer_title>         Gets the timer with specified timer title
--treport <tag_name> <-> -tr                        Shows timers and total time for the passed tag.
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
  stopwatch: ^time.Stopwatch,
  deadline: time.Duration,
}


timer_main :: proc(curr_timer: ^Timer) {
  handle_arguments(curr_timer)
}

handle_arguments :: proc(curr_timer: ^Timer) {
  passed_arguments: []string = os.args

  // Skip the running application from arguments list to only have app arguments in the list
  passed_arguments = passed_arguments[1:]
  
  // Check if we ran application without arguments and if the timer is running or not
  if len(passed_arguments) == 0 && !curr_timer.stopwatch.running {
    time.stopwatch_start(curr_timer.stopwatch)
    return
  } else {
    time.stopwatch_stop(curr_timer.stopwatch)
    return
  }

  for arg in passed_arguments {
    arg_identifier: string = "-"

    if arg[0] == arg_identifier[0] {
      switch arg {
        case "--deadline", "-d":
          // set_deadline(&timer, deadline)
        case "--preport", "-pr":
          // show_report(project_name)
        case "--project", "-P":
          // set_project(&timer, project_name)
        case "--report", "-r":
          // show_report()
        case "--tag", "-t":
          // set_tag(&timer, tag)
        case "--treport", "-tr":
          // show_report(tag)
        case "--pause", "-p":
          // time.stopwatch_stop(&timer)
        case "--stop", "-s":
          // save_and_stop_timer(&timer)
        case "--timer", "-ti":
          // get_timer(&timer)
      }
    }
  }

  fmt.println(passed_arguments)
}
