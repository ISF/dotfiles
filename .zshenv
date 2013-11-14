# Environment settings

export SHELL_ENV_PATH=$HOME/.env/shell

#### PATH

source $SHELL_ENV_PATH/prefix_path
source $SHELL_ENV_PATH/local_path

#### Daemons

# ssh-agent
source $SHELL_ENV_PATH/ssh

# gpg-agent
source $SHELL_ENV_PATH/gpg

#### Variables

# CFLAGS and CXXFLAGS
source $SHELL_ENV_PATH/cflags

# locale
source $SHELL_ENV_PATH/locale

# NNTP servers
export NNTPSERVER="localhost"

# virsh default connection (local)
export VIRSH_DEFAULT_CONNECT_URI="qemu:///system"

source ~/.zshenv
