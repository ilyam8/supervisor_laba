### supervisor_laba

**Testing supervisor monitoring with netdata**

#### Description

This laboratory container has supervisord with 3 configured jobs.

Build this container ```docker-compose up --build```. Supervisor log is printed to container console. This also forces
supervisord executable to stay in the foreground (otherwise process daemonize and contained exits).

*Notes*. While building container, script replaces default `supervisorctl` with one shipped to bring additional options.

- One of these options is supervisor control shell accessing supervisor through unix socket instead of TCP port (
  section ```[supervisorctl]``` in file supervisord.conf). See details
  in [official manual](http://supervisord.org/configuration.html#supervisorctl-section-settings). Unix socket is
  configured in ```[unix_http_server]``` section;
- Individual jobs (sections "program:...") configured in main config file. By default, they are included
  from ```/etc/supervisor/conf.d```. These sections
  configure [supervised jobs](http://supervisord.org/configuration.html#program-x-section-settings).

This testing set contains 3 shell scripts and correspondingly 3 configured jobs, and their behavior is reflected with
status output.

- Job `proc1` sleeps 2 seconds, prints short phrase and exits (see `process1.sh`). However, as in
  section ```[program:proc1]``` it's configured that job considered started after 3 seconds only, this job always fail (
  regardless of exiting cleanly) and enters `FAILED` state.
- Job `proc2` sleeps random number of seconds, prints short phrase and exits. However, as this job configured to be
  considered running immediately, after exit it will be restarted. Moreover, this job has 3 instances running in
  parallel, they can start and exit asynchronously and displayed as `proc2:00`...`proc2:02`.
- Finally, job `proc3` has infinit loop. It's started and remains up until stopped (either by stopping supervisord
  daemon or by stopping single job with bash command `supervisorctl stop proc3:`

#### Start/Stop the lab

```cmd
git clone https://github.com/ilyam8/supervisor_laba
cd supervisor_laba

# start
docker-compose up --build

# stop
docker-compose down

# cleanup
docker rmi $(docker images -a --filter=dangling=true -q)
```

#### Get data from inside the container

Unix socket: `run/supervisor.sock`

```cmd
go build <program_name>.go
docker cp <program_name> <container_id>:/opt/
docker exec -it <container_id> /opt/<program_name>
```

Check using `supervisorctl`

```cmd
docker exec -it <container_id> supervisorctl status
```

#### Get data from outside the container

HTTP server endpoint: `http://localhost:9001/RPC2`
