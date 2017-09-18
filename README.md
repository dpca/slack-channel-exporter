[![Build Status](https://travis-ci.org/dpca/slack-channel-exporter.svg?branch=master)](https://travis-ci.org/dpca/slack-channel-exporter)
[![Code Climate](https://codeclimate.com/github/dpca/slack-channel-exporter/badges/gpa.svg)](https://codeclimate.com/github/dpca/slack-channel-exporter)
[![Coverage Status](https://coveralls.io/repos/github/dpca/slack-channel-exporter/badge.svg?branch=master)](https://coveralls.io/github/dpca/slack-channel-exporter?branch=master)

* * *

# slack-channel-exporter

Export slack user data for evacuation attendance sheets. Available as a docker
image [here](https://hub.docker.com/r/dpca/slack-channel-exporter/).

## Setup

Set the following in your environment

* `SLACK_API_TOKEN`
* `DEFAULT_CHANNELS` - space separated list of channels to show as links

## Run with Docker

To run with docker at port 4567:

```
docker run --rm -it -p 4567:80 -e SLACK_API_TOKEN="$SLACK_API_TOKEN" -e DEFAULT_CHANNELS="$DEFAULT_CHANNELS" dpca/slack-channel-exporter
```

## Development

```
bundle install
bundle exec rackup
```
