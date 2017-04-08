# Environment settings

export SHELL_ENV_PATH=$HOME/.env/shell

#### PATH

source $SHELL_ENV_PATH/prefix_path
source $SHELL_ENV_PATH/local_path

#### Daemons

# ssh-agent
source $SHELL_ENV_PATH/ssh

#### Variables

# CFLAGS and CXXFLAGS
source $SHELL_ENV_PATH/cflags

# locale
source $SHELL_ENV_PATH/locale

# NNTP servers
export NNTPSERVER="localhost"

# virsh default connection (local)
export VIRSH_DEFAULT_CONNECT_URI="qemu:///system"

# Go programming language
# TODO: review if it's still needed
source $SHELL_ENV_PATH/go

# Custom home installation of packer
source $SHELL_ENV_PATH/packer

# Project manager
source $SHELL_ENV_PATH/projects

# source env for taskd if taskddata exists
if [[ -d $HOME/.taskddata ]]; then
    source $SHELL_ENV_PATH/taskd
fi

### SDF

if [[ $(hostname) =~ sdf ]]; then
    source $SHELL_ENV_PATH/sdf
fi
