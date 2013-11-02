# Environment settings

export SHELL_ENV_PATH=$HOME/.env/shell

# PATH

source $SHELL_ENV_PATH/prefix_path
source $SHELL_ENV_PATH/local_path

# ssh-agent
source $SHELL_ENV_PATH/ssh

# gpg-agent
source $SHELL_ENV_PATH/gpg

# CFLAGS
source $SHELL_ENV_PATH/cflags

# locale
$SHELL_ENV_PATH/locale
