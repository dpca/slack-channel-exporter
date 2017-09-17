FROM phusion/passenger-ruby24

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

EXPOSE 80

# Start Nginx / Passenger
RUN rm -f /etc/service/nginx/down

# Remove default site
RUN rm /etc/nginx/sites-enabled/default

# Add Nginx site and config
ADD nginx.conf /etc/nginx/sites-enabled/exporter.conf
ADD rack-env.conf /etc/nginx/main.d/rack-env.conf

ENV APP_HOME /home/app/exporter

# Prepare app folder
RUN mkdir -p $APP_HOME

# Install gems
WORKDIR /tmp
COPY Gemfile /tmp/
COPY Gemfile.lock /tmp/
RUN bundle install

# Add app
ADD . $APP_HOME
RUN chown -R app:app $APP_HOME
WORKDIR $APP_HOME

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
