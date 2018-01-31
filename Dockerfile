FROM ruby:2.3

# Create home folder (need 777 permision so the local user can access)
RUN mkdir /home/app && chmod +777 /home/app
ENV HOME /home/app

# Install gems to vendor/bundle (to avoid re-building images when Gemfile is changed)
RUN echo '---\nBUNDLE_PATH: "vendor/bundle"' > /usr/local/bundle/config

WORKDIR /app
