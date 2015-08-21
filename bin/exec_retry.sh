exec_with_retry () {
  times="$1"
  seconds_between_retries="$2"
  command="$3"

  while true; do
    eval "$command"
    
    exit_status=$?
    [ $exit_status == 0 ] && return 0
    
    let "times = times - 1"
    [ $times -le 0 ] && return $exit_status
      
    sleep $seconds_between_retries
  done
  
  return $exit_status
}
