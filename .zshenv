# Set up terminal experience.
export LESS="-iMSx4 -F"
export TERM=rxvt-unicode-256color

export PROMPT_TOOLKIT_BELL=false

# Set up default paths to config dirs and config files.
export GOPATH=$HOME/proj
export PATH=$PATH:$GOPATH/bin:/opt/intel/bin
export XDG_CONFIG_HOME=$HOME/.config

export KAGGLE_CONFIG_DIR=$XDG_CONFIG_HOME/kaggle
export MYSQL_HOME=$XDG_CONFIG_HOME/mysql
export NLTK_DATA=$HOME/data/nltk

# Set up default credentials for development.
export PGHOST=127.0.0.1
export PGUSER=postgres
export PGPASSWORD=postgres

# Set up application options.
export JAX_PLATFORM_NAME=CPU
