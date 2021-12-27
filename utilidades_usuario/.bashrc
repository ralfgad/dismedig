# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

export LM_LICENSE_FILE=5280@lic-cadence2.upv.es:1717@lic-mentor.upv.es

export http_proxy=http://proxy.upv.es:8080/

source /home/dismedig/cadence_ic.sh

source /home/dismedig/mentor.sh


# export PATH="/home/dismedig/miniconda3/bin:$PATH"

# <<< conda initialize <<<

