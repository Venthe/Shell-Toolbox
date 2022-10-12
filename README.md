# Shell Toolbox

## Usage

1. Clone the Toolbox  
   `git clone https://github.com/Venthe/Shell-Toolbox ~/.shell-toolbox`
2. Install ansible
   1. Linux
      ```bash
      sudo apt install python3 python3-pip --assume-yes
      python3 -m pip install --user ansible==6.4.0
      # echo 'PATH=$HOME/.local/bin:$PATH' >> ~/.bashrc
      ```
   2. Windows  
      `N/A`
3. Install ansible dependencies
   ```bash
   ansible-galaxy collection install community.crypto community.general
   ```

## Development

1. Install
   ```bash
   sudo apt install shellcheck --assume-yes
   ```
