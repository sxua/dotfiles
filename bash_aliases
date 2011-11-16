if [ $(uname) == 'Darwin' ]; then
  alias ll="ls -l"
  alias la="ls -A"
  alias ports="cd /opt/local/var/macports/sources/rsync.macports.org/release/tarballs/ports/"

  # nginx

  function ngs {
    echo "Starting nginx ..."
    sudo port load nginx
  }

  function ngq {
    echo "Stopping nginx ..."
    sudo port unload nginx
  }

  function ngr {
    echo "Reloading nginx config ..."
    sudo nginx -s reload
  }

  # postgresql

  function pgs {
    echo "Starting PostgreSQL server ..."
    sudo port load postgresql90-server
  }

  function pgq {
    echo "Stopping PostgreSQL server ..."
    sudo port unload postgresql90-server
  }

  function pgr {
    echo "Restarting PostgreSQL server ..."
    sudo /opt/local/etc/LaunchDaemons/org.macports.postgresql90-server/postgresql90-server.wrapper restart
  }

  function psg {
    ps wwwaux | egrep "($1|%CPU)" | grep -v grep
  }

fi

# cdgem

function cg {
  cd `gem env gemdir`/gems
  cd `ls | grep ^$1 | sort | tail -1`
}

# rails

function sc {
  if [ -f config/environment.rb ] && [ $(which pry) ]; then
    pry -r./config/environment.rb
  elif [ -x script/rails ]; then
    script/rails console
  elif [ -x script/console ]; then
    script/console
  else
    echo "cd to add directory first"
  fi
}

function ss {
  if [ -x unicorn_rails ]; then
    echo "Starting Unicorn ..."
    unicorn_rails -E development -c unicorn.conf.rb -D
  elif [ -x script/server ]; then
    echo "Starting Rails 2 server ..."
    script/server
  elif [ -x script/rails ]; then
    echo "Starting Rails 3 server ..."
    script/rails server
  else
    echo "cd to app directory first"
  fi
}

function sq {
  if [ -f tmp/pids/unicorn.pid ]; then
    echo "Stopping Unicorn ..."
    kill `cat tmp/pids/unicorn.pid`
  elif [ -f tmp/pids/server.pid ]; then
    echo "Stopping Rails server ..."
    kill `cat tmp/pids/server.pid`
  fi
}

function sr {
  if [ -f tmp/pids/unicorn.pid ]; then
    echo "Restarting Unicorn ..."
    kill -USR2 `cat tmp/pids/unicorn.pid`
  elif [ -f tmp/pids/server.pid ]; then
    echo "Restarting Rails server ..."
    kill -USR2 `cat tmp/pids/server.pid`
  elif [ -d tmp ]; then
    echo "Restarting Passenger instances ..."
    touch tmp/restart.txt
  else
    echo "cd to app directory first"
  fi
}