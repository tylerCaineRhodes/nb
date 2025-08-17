pid = :c.pid(0, 208, 0)
# => #PID<0.208.0>

pid = :erlang.list_to_pid('<0.208.0>')
#=> #PID<0.208.0>


# give it a name
pid = spawn(fn -> IO.puts "some process" end)
Process.register(pid, :some_job)
Process.whereis(:some_job)
# => #PID<0.208.0>
