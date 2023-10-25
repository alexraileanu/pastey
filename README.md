# pastey

**Forked from cesura/pastey**

A lightweight, self-hosted paste platform

## Features
* Self-contained system without external database dependencies
* Optional on-disk encryption
* Optional single use pastes
* Optional expiration date
* QR code generation
* IP/network whitelisting and blocking
* Endpoint rate limiting
* JSON API
* Fully configurable via environment variables

## Changes:

- Removed config page
- Removed recent pastes from the index page
- Removed theme selector (default is Dark but can be changed in the config)
- Removed guess code language. This had a dependency on tensorflow which took forever to build the docker image and imo
not hugely important
- Changed the base docker image to be python3.10-slim
- Set default expiry of pastes to 6h

## Installation
### Docker
It is highly recommended that you use the official Docker image to run Pastey. To do so, simply run:
```
$ docker run -d -p 5000:5000 -v /path/to/local/dir:/app/data arcscloud/pastey:latest
```
Change **/path/to/local/dir** to a local folder you would like to use for persistent paste storage. It will be mounted in the container at **/app/data**.

Pastey will then be accessible at *http://localhost:5000*

### docker-compose
If you prefer to use docker-compose:
```
$ wget https://raw.githubusercontent.com/alexraileanu/pastey/main/docker-compose.yml && docker-compose up -d
```
Note that this must be modified if you wish to use a local directory for storage, rather than a Docker volume.

### Local
Requirements:
* Python 3.8

```
$ git clone https://github.com/alexraileanu/pastey.git && cd pastey && mkdir ./data
$ pip3 install -r requirements.txt
$ python3 app.py 
```

## Configuration
Here is a list of the available configuration options:
| Environment Variable        | config.py Variable   | Description                                                                                                                                                                                      | Default Value                                                             |
|-----------------------------|----------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------|
| PASTEY_DATA_DIRECTORY       | data_directory       | Local directory for paste storage                                                                                                                                                                | ./data                                                                    |
| PASTEY_LISTEN_ADDRESS       | listen_address       | Address to listen on                                                                                                                                                                             | 0.0.0.0                                                                   |
| PASTEY_LISTEN_PORT          | listen_port          | Port to listen on                                                                                                                                                                                | 5000                                                                      |
| PASTEY_USE_WHITELIST        | use_whitelist        | Enable/disable whitelisting for admin tasks (view recent, delete, config)                                                                                                                        | True                                                                      |
| PASTEY_WHITELIST_CIDR       | whitelist_cidr       | List of whitelisted IP addresses or networks (in CIDR format). When passed as an environment variable, it should be a comma-separated list.                                                      | [ '127.0.0.1/32' ,  '10.0.0.0/8' ,  '172.16.0.0/12' ,  '192.168.0.0/16' ] |
| PASTEY_BLACKLIST_CIDR       | blacklist_cidr       | List of blocked IP addresses or networks (in CIDR format). When passed as an environment variable, it should be a comma-separated list.                                                          | []                                                                        |
| PASTEY_RESTRICT_PASTING     | restrict_pasting     | Enable/disable restricting of pasting to whitelisted users                                                                                                                                       | False                                                                     |
| PASTEY_RATE_LIMIT           | rate_limit           | Rate limit for pasting, for non-whitelisted users                                                                                                                                                | 5/hour                                                                    |
| PASTEY_RECENT_PASTES        | recent_pastes        | Number of recent pastes to show on the home page                                                                                                                                                 | 10                                                                        |
| PASTEY_BEHIND_PROXY         | behind_proxy         | Inform Pastey if it is behind a reverse proxy (nginx, etc.). If this is the case, it will rely on HTTP headers X-Real-IP or X-Forwarded-For. NOTE: Make sure your proxy config sets these values | False                                                                     |
| PASTEY_DEFAULT_THEME        | default_theme        | Select which theme Pastey should use by default. This is overridden by client options.                                                                                                           | Light                                                                     |
| PASTEY_PURGE_INTERVAL       | purge_interval       | Purge interval (in seconds) for checking expired pastes in background thread                                                                                                                     | 3600                                                                      |
| PASTEY_FORCE_SHOW_RECENT    | force_show_recent    | Show recent pastes on the home page, even to non-whitelisted users (without delete button)                                                                                                       | False                                                                     |
| PASTEY_IGNORE_GUESS         | ignore_guess         | Ignore these classifications for language detection                                                                                                                                              | ['TeX', 'SQL']                                                            |
| PASTEY_SHOW_CLI_BUTTON      | show_cli_button      | Enable/disabling showing of CLI button on home page                                                                                                                                              | True                                                                      |
| PASTEY_DEFAULT_PASTE_EXPIRY | default_paste_expiry | Set preselected value (in hours) in the expire paste dropdown so that no paste lives forever (one of: -1, 1, 6, 24, 72, 168, 672, 8760). If invalid value, the first option will be selected     | -1                                                                        |

### Docker configuration
For Docker environments, it is recommended that the options be passed to the container on startup: 
```
$ docker run -d -p 5000:5000 -e PASTEY_LISTEN_PORT=80 -e PASTEY_BEHIND_PROXY="True" arcscloud/pastey:latest
```
