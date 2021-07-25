#!/bin/sh
echo "What you wanna do? Create a new ssh key or you have your own private ssh key?"
echo "Please type [have] or [new]"
echo ""
read NEW_HAVE
if [$NEW_HAVE = "new"]; then

echo "SSH file name?"
echo ""
read SSH_NAME
echo ""
echo "What is your email?"
echo ""
read EMAIL
echo ""
echo "These files will be created in ~/.ssh/ folder: [$SSH_NAME] and [$SSH_NAME.pub]."
echo "With this email address: $EMAIL ."
echo ""
ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/$SSH_NAME -C "$EMAIL" && 
eval "$(ssh-agent -s)" &&
ssh-add ~/.ssh/$SSH_NAME &&
echo "==========================================================" &&
echo "=----COPY THIS PUBLIC KEY AND PASTE INTO THE 42 INTRA----=" &&
echo "==========================================================" &&
echo ""
cat ~/.ssh/"$SSH_NAME".pub
echo ""
