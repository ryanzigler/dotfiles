#!/bin/sh

echo "Generating a new SSH key for GitHub..."

# Generate a new SSH key
ssh-keygen -t ed25519 -C "$1" -f ~/.ssh/id_ed25519

# Adding the SSH key to the `ssh-agent`
eval "$(ssh-agent -s)"

# Never overwrite an existing config
if [ -e "$HOME/.ssh/config" ]; then
	echo "$HOME/.ssh/config already exists; leaving it untouched. Make sure 'Host *' sets AddKeysToAgent yes, UseKeychain yes and IdentityFile ~/.ssh/id_ed25519."
else
	printf 'Host *\n  AddKeysToAgent yes\n  UseKeychain yes\n  IdentityFile ~/.ssh/id_ed25519\n' | tee "$HOME/.ssh/config"
fi

ssh-add --apple-use-keychain ~/.ssh/id_ed25519

# Copy the SSH key to the clipboard
echo "run 'pbcopy < ~/.ssh/id_ed25519.pub' and paste that into GitHub"
