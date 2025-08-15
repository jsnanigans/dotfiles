# run lsof -ti :$argv[1] | grep LISTEN | awk '{print $2}' | xargs kill -9
function killport
    if test (count $argv) -ne 1
        echo "Usage: killport <port>"
        return 1
    end
    set port $argv[1]
    set pids (lsof -ti :$port)
    if test -z "$pids"
        echo "No process found listening on port $port"
        return 0
    end
    echo "Killing processes listening on port $port: $pids"
    for pid in $pids
        kill -9 $pid
        if test $status -eq 0
            echo "Killed process $pid"
        else
            echo "Failed to kill process $pid"
        end
    end
end
