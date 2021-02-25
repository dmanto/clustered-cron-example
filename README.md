# clustered cron example
![GitHub repo size](https://img.shields.io/github/repo-size/dmanto/clustered-cron-example)

clustered-cron-example is a proof of concept on how to execute a cron job in a multihost environment
without sacrifying availability or firing more than one job at a scheduled time.

It is based on the amazing real-time web framework [Mojolicious](https://metacpan.org/pod/Mojolicious),
and the resilient [etcd](https://etcd.io) distributed database system.

## Prerequisites

* Docker (v19+), Docker compose (1.27+)
* Haven't checked, but as the project runs 3 containers at the same time, you should have a generous
amount of RAM available (>= 8GB I guess)

## Installing

* git clone the project and cd to it, then run this command:

```shell
docker-compose up -d
```
* after downloading, building and starting, you should see that etcd initializes ok with 3 nodes.
* then you should receive 1 warn every 10 seconds, with the simulated Cron job results

## Testing
* the crontab is fired every 10 seconds, but this is only to show quick results. In practice, when
a node goes down, it is important that the rest of the etcd nodes stabilize as soon as possible. One
scheduled time while it is stabilizing should be fine, but I don't know if you lower this interval too much.
* to make any changes and restart, you need to stop the containers (^C), then run

```shell
docker-compose down
docker-compose up --build
```
* You should have 3 nodes running. The corresponding web services would be at localhost ports 9010, 9011 and 9012. They just show a "Hello World" message when you point a browser to them, just to show they are alive. (The actual interesting stuff is what you get into the logs).
* The nodes are: web_0, web_1, and web_2
* from other terminal, you can stop one of the modules (for instance web_2):
```shell
docker stop clustered-cron-example_web_2_1
```
* then you can start it again:
```shell
docker start clustered-cron-example_web_2_1
```
## which host runs the task?
* The first host that gets the exclusive lock of the next scheduled time runs the task.
* That doesn't change very often, but you will see changes after several minutes.

## how to enter (i.e. run an interactive shell) to any of the nodes?
* You should be able to enter to any of the nodes (for instance to web_0 node), from a different terminal:
```shell
docker exec -it clustered-cron-example_web_0_1 bash
```
