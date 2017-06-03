[![Alt AIRAVANA](./airavana-logo.png?raw=true "Optional Title")](http://airavana.net)

# Bash-via-http

This project is dockerized web-server (nginx) which allow to run bash script as host machine (not docker!) after receiving
proper http request.

# How it works

When web-serwer reveive proper HTTP request, then information about this request are saved in `./share/event` file.

Host machine will detect hanges in that file, read value of `EVENT_NAME` and execute `run.sh` script in `./eventHandlesrs/event_name`.

# How to use it?

Let say our server is run in following sub-domain `http://events-handler.your-domain.com`

You should define your event name - e.g. `my-project-git-push`, this will be determine value of `name` parameter in following request:

`POST http://events-handler.your-domain.com/event?name=my-project-git-push`

(of course you can add as many new parameters to above request as you need). 

Then you should create file (and directory) `./eventHandlesrs/my-project-git-push/run.sh` with your script.


# Examples

## Example1 and Example2

In directory `./eventHandlesrs/` are already defined 2 examples which also shows how to use included bash tools to process
`./share/event` file to get more informations from request (eg. key with with password)

## Example 3

This example only show workflow: let assume that server received following request (with some json in body):

`POST http://events-handler.your-domain.com/event?name=your-event-name&key=secret_and_hard_password`

Then in `./share/event` file server will save following information:

```
EVENT_NAME:
your-event-name

EVENT_TIMESTAMP:
1495127455

EVENT_PARAMETERS: 
name=my-project&key=xxxxxxxxxxxxxxxxxxxxxx

EVENT_BODY: 
{"push":{"changes":[{"new":{"name":"master","type":"branch"}}]}}
```

On this step the processing on server is done.

The second steps belongs to host machine which detect changes on file `./share/event` and read value of `EVENT_NAME` from it. Then
the following script will be executed by host machine: `./eventsHandlers/your-event-name/run.sh`.

# Instalation

To run project you only need host machine with **operationg system** with installed **git** (to clone this repo and other projects) 
 [docker](https://www.docker.com/) and some tool to watch file changes.
 
## MacOs

### Instal file changes watcher

`brew install fswatch`

### Install docker

`brew cask install docker`

And run docker by Mac bottom menu> launchpad > docker (on first run docker will ask you about password)

## Ubuntu 16.04

### Instal file changes watcher

`sudo apt-get install inotify-tools`

### Install docker

```
sudo apt-get update
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main'
sudo apt-get update
apt-cache policy docker-engine
sudo apt-get install -y docker-engine
sudo systemctl status docker  # test:  shoud be ‘active’
```
And add your user to docker group (to avoid `sudo` before using `docker` command in future):
```
sudo usermod -aG docker $(whoami)
```

and lougout and login again.

Last step: turn on experimental docker functions (e.g. for generate small images by sqashing) 
we create file `sudo nano /etc/docker/daemon.json` and add to it:

```
{ 
    "experimental": true 
}
```

and save file and exit. In terminal type `sudo service docker restart` . When we run `docker viersion` we should see *Experimental: true*


## Run
 
### localshost
 
To run system on port 8080 execute following script:
 
 `./run.sh -p 8080:80` &
 
 (parameter `-p hostPort:containerPort` is parameter which will be send to `docker run` command)
 
### Sub-domain

For example to rune everything on sub-domain `events-handler.your-domain.com` first install and run reverse-proxy:

 ```
 docker pull jwilder/nginx-proxy:alpine
 docker run -d -p 80:80 --name nginx-proxy -v /var/run/docker.sock:/tmp/docker.sock:ro jwilder/nginx-proxy:alpine
 ```
 
 And in your `/etc/hosts` file (linux) add line: `127.0.0.1 events-handler.your-domain.com` or in yor hosting add
 folowing DNS record (wildchar `*` is handy because when you add new sub-domain in future, you don't need touch/add any DNS record)
  
 ```
 Type: CNAME 
 Hostname: *.your-domain.com
 Direct to: your-domain.com
 TTL(sec): 43200 
 ```

And run system by:

 `./run.sh -e VIRTUAL_HOST=events-handler.your-domain.com &`


### Debug: Login into docker container with web-server

`docker exec -t -i angular-starter /bin/bash`