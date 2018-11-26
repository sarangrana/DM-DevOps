#declare -a instances=$3
declare -a instances=("18.218.225.103" "13.59.102.201")

if [ -z "$1" ]
  then
    AWS_KEY="key.pem"
  else
    AWS_KEY=$1
fi

if [ -z "$2" ]
  then
    USERNAME="sarang"
  else
    USERNAME=$2
fi


if [ -z "$instances" ]
  then
    echo "No IP supplied for passwordless authentication! Please supply valid IP address in array format"
    exit
  else
    yes y |ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
    chmod 600 $AWS_KEY
    for i in "${instances[@]}"
      do
        cat /.ssh/id_rsa.pub | ssh -i $AWS_KEY $USERNAME@$i -o "StrictHostKeyChecking=no" "cat - >> /.ssh/authorized_keys2" < /dev/null
        if [ $? -eq 0 ]; then
           echo "ssh connection SUCCESSFUL for" $i
        else
           echo "ssh connection FAILED for" $i
        fi
      done
fi
