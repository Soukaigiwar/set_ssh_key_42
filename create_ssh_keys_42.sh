# #!/bin/sh
item=$(whiptail \
      --title "SSH key pair Generator" \
      --menu "Chose if will create a new key pair, \n \
        or if will restore a public-key based on private-key file." 10 90 2 \
      "1" "Create a new SSH key pair." \
      "2" "Restore public key providing private key." 3>&1 1>&2 2>&3)
status=$? 
if [ $status = 0 ] && [ $item = "1" ]; then
  email=$(whiptail \
        --title "SSH key pair Generator" \
        --inputbox "\nEnter your email address:\n" \
        10 90 3>&1 1>&2 2>&3)
  input=$? 
  if [ $input=0 ] && [ ! -z $email ]; then
    file_name=$(whiptail \
              --title "SSH key pair Generator" \
              --inputbox "\nEnter desired file name:\n" \
              10 90 3>&1 1>&2 2>&3)
    input=$?
    if [ $input=0 ] && [ ! -z $file_name ]; then
      ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/$file_name -C "$email" &&
      eval "$(ssh-agent -s)" &&
      ssh-add ~/.ssh/$file_name
      pub_key=$(cat ~/.ssh/$file_name.pub)
      result=$(whiptail \
              --title "SSH key pair Generator" \
              --msgbox \
              "\nCopy and paste this public key into your 42 Intra SSH Settings:\n\n$pub_key" \
              12 90 3>&1 1>&2 2>&3)
    fi
  fi
elif [ $status = 0 ] && [ $item = "2" ]; then
  file_name=$(whiptail \
        --title "SSH key pair Generator" \
        --inputbox "\nInsert file name located at ~/.ssh/ :\n" \
        10 90 3>&1 1>&2 2>&3)
  input=$?
  # [[ ls -l ~/.ssh/$file_name | wc -l ] = 1 ]
  exist=$(ls -l ~/.ssh/$file_name | wc -l)
  if [ $input = 0 ] && [ ! -z $file_name ] && [ $exist = 1 ]; then
    pub_key=$(ssh-keygen -y -f ~/.ssh/$file_name > ~/.ssh/$file_name.pub)
    pub_key=$(cat ~/.ssh/$file_name.pub)
    whiptail \
    --title "SSH key pair Generator" \
    --msgbox \
    "\nCopy and paste this public key into your 42 Intra SSH Settings:\n\n$pub_key" \
    12 90 3>&1 1>&2 2>&3
  else
    whiptail \
    --title "SSH key pair Generator" \
    --msgbox \
    "\nInvalid file name ($file_name) or this file doesn't exist." \
    12 90 3>&1 1>&2 2>&3
  fi
fi   