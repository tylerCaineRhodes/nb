# basic ssh

## mac settings for ssh connections
System Preferences -> Sharing -> enable 'Remote Login' and 'Remote Management'

## connection syntax
ssh <username>@<serverhost>
ssh dev@192.168.1.189

## generate a new ssh key
ssh-keygen

## copy local ssh public key
pbcopy ~/.ssh/id_rsa.pub

## copy remote ssh public key
ssh-copy-id <username>@<serverhost>
ssh-copy-id dev@1.tcp.ngrok.io -p 23140

## add a local key to remote authorized keys
cat ~/.ssh/id_rsa.pub | ssh <username>@<hostname> 'cat >> .ssh/authorized_keys && echo "Key copied"'

## copy a file from a local file to a remote machine
scp <path_to_file> <username>@<serverhost>:<path_to_destination>
scp example.html dev@192.168.1.189:~/projects/example.html