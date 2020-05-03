FROM circleci/ruby:2.6-node-browsers

RUN sudo wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - \
 && sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
RUN sudo apt-get update; exit 0;
RUN sudo apt-get -y install postgresql-client

RUN sudo apt-get -y autoremove

ENV APPDIR /hyposka
RUN sudo mkdir $APPDIR
WORKDIR $APPDIR

ENV BUNDLE_JOBS=2 \
    BUNDLE_PATH=/gems \
    # gems folder must be added to GEM_PATHs
    GEM_PATH=$GEM_PATH:/gems \
    PATH=$PATH:/gems/bin

ADD . .
RUN sudo mkdir /gems
RUN sudo chown -R circleci /$APPDIR /gems