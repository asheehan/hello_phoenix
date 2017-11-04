#!/bin/bash

ssh $APP_USER@$APP_HOST <<ENDSSH
  echo "changing dir to ./apps/$APP_NAME"
  cd ./apps/$APP_NAME;
  date >> deploy-log.txt;

  echo "Symlinking static"
  ln -sfn lib/$APP_NAME-$APP_VERSION/priv/static static;

  echo "stopping app";
  ./bin/$APP_NAME stop >> deploy-log.txt || true;
ENDSSH

ssh $APP_USER@$APP_HOST <<ENDSSH
  cd ./apps/$APP_NAME;
  date >> deploy-log.txt;

  # You may want to use this if you are using Cowboy without proxy
  # echo "giving beam permission to start the webserver"
  # sudo setcap 'cap_net_bind_service=+ep' /home/$APP_USER/$APP_NAME/erts-9.1.2/bin/beam.smp;

  echo "starting app";
  PORT=4040 ./bin/$APP_NAME start >> deploy-log.txt;

  echo "Finished";
ENDSSH