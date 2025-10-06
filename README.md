## Usage

1. Update macOS to the latest version through system preferences

2. Setup an SSH key by using one of the two following methods

   1. [1Password SSH agent](https://developer.1password.com/docs/ssh/get-started/#step-3-turn-on-the-1password-ssh-agent) and sync your SSH keys locally.

   2. [Generate a new public and private SSH key](https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent):

      1. ```zsh
         curl https://raw.githubusercontent.com/ryanzigler/dotfiles/HEAD/ssh.sh | sh -s "<EMAIL_ADDRESS>"
         ```

3. Clone this repo to `~/.dotfiles`:

   ```zsh
   git clone --recursive git@github.com:ryanzigler/dotfiles.git ~/.dotfiles
   ```

4. Run the installation:

   ```zsh
   cd ~/.dotfiles && ./fresh.sh
   ```

5. Restart to finalize the process

### Wipe & cleaning your old Mac

Follow [this article](https://support.apple.com/guide/mac-help/erase-and-reinstall-macos-mh27903/mac) to do that.
