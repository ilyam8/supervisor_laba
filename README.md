### supervisor_laba

**Testing supervisor monitoring with netdata**

#### Description

This laboratory container has netdata installed by default script and supervisord with 3 jobs configured

Build this container ```docker-compose up --build```. Once started, direcory "./logs" will contain supervisor log (combined, in debug mode) and individual job logs. In addition, supervisor log is printed to container console. This also forces supervisord executable to stay in foreground (otherwise process daemonize and contained exits).

*Notes*.
While building container, script replaces default supervisorctl with one shipped to bring additional options.
- One of these options is supervisor control shell accessing supervisor through unix socket instead of TCP port (section ```[supervisorctl]``` in file supervisord.conf). See details in [official manual](http://supervisord.org/configuration.html#supervisorctl-section-settings). Unix socket is configured in ```[unix_http_server]``` section;
- Another difference is logging. Normally, supervisor jobs log into separate files. With ```loglevel=debug``` logging is also duplicated into global supervisor log file; 
- Finally, difference is that individual jobs (sections "program:...") configured in main config file. By default they are included from ```/etc/supervisor/conf.d```. These sections configure [supervised jobs](http://supervisord.org/configuration.html#program-x-section-settings).

#### Usage

To investigate behavior of supervisor, you'll have to enter contained with ```docker exec -it <container_id> /bin/bash```. In container, run `supervisorctl` for interactive controlling shell or `supervisorctl status` to see process state. Output will look like following:

```
# supervisorctl status
proc1:00                         FATAL     Exited too quickly (process log may have details)
proc2:00                         RUNNING   pid 9020, uptime 0:00:07
proc2:01                         RUNNING   pid 10934, uptime 0:00:02
proc2:02                         RUNNING   pid 10592, uptime 0:00:03
proc3:00                         RUNNING   pid 14, uptime 0:00:39
```

This testing set contains 3 shell scripts and correspondively 3 jobs configured and their behavior is reflected with staus output.
- Job `proc1` sleeps 2 seconds, prints short phrase and exits (see `process1.sh`). However, as in section ```[program:proc1]``` it's configured that job considered started after 3 seconds only, this job always fail (regardless of exiting cleanly) and enters `FAILED` state.
- Job `proc2` sleeps random number of seconds, prints short phrase and exits. However, as this job configured to be considered running immediately, after exit it will be restarted. Moreover, this job has 3 instances running in parallel, they can start and exit asynchronously and displayed as `proc2:00`...`proc2:02`.
- Finally, job `proc3` has infinit loop. It's started and remains up until stopped (either by stopping supervisord daemon or by stopping single job with bash command `supervisorctl stop proc3:`

