# Kali-Tools-Installation

This script can be used in order to install all the tools below on Kali 2019 and Kali 2020.

This ones are available in command line:

- Dependencies: 
  - Git
  - Npm 
  - Pip
- Environnement: 
  - Fish
  - Terminator
  - Atom 
- Windows:
  - Evil-Winrm
- Reverse: 
  - Ropper
  - Gdb-peda
- Cracking:
  - Hexedit
  - Pdfcrack
  - Fcrackzip
  - Steghide
- RPC monitoring:
  - Rpcclient
  - Rpc-bind
  - Rpc-check
  
And the other ones are situed in the opt directorie:
```
├── opt
    ├── resources
    │   ├─────── malwares-samples
    │   └─────── seclists
    ├── windows
        ├─────── bloodhound
        ├─────── impacket
        ├─────── mremoteng-decrypt
        ├─────── neo4j-community-3.5.12
        └─────── sysinternalssuite
    ├── linux
    │   └─────── pspy
    │   └─────── linenum
    ├── web
    │   └─────── kadimus
    │   └─────── phpbash
    │   └─────── p0wny-shel
    │   └─────── wwwolf-php-webshell
    │   └─────── Ffuf
    │   └─────── Wall6e-Web-Scripts
    ├── osint
    │   └─────── teeth
    ├── reverse
    │   └─────── hopper
    └── cracking
        └─────── cisco_pwdecrypt

```

Moreover, it can also setups different firefox extensions :

  - Hackbar
  - Http-request-maker
  - Wappalyzer

Finnaly, it fetch the burp certificate in order to configure the proxie in firefox via a new profile. Of course, the burp certificate is also registred in the system's certificate store to be handled by other programs. 

Thus, three aliases are configured:

```fireprox``` launch a firefox window configured to work with burp.

```proxie``` change the current settings in order to work with curl or wget through the burp proxie.

```noproxie``` desactivate the proxie settings.

This script can also be used in order to setup i3wm by taking advantage of my personnal configuration with the following third parties: 

  - I3gaps
  - I3blocks
  - Compton
  - Feh
  - Rofi
  - Morc_menu
  - Wtfutil
  - Mc
  - Pureline
  - Powerline

To add new tools, only the "Tools.xml" file must be modified according to the following pattern :

```
<Category>
  <Tool>
    <cmd>   Install script   </cmd>
  </Tool>
</Category>
```

Feel free to introduce new tools in already existing categories, like creating new categories.

