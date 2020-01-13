# Kali-Tools-Installation-V2

This script can be used in order to install all the tools below on Kali.

This ones are available in command line:

- Dependencies: 
  - git
  - npm 
- Ide: 
  - Atom 
- Windows:
  - Evil-Winrm
- Reverse: 
  - Ropper
  - Hexedit
- Blockchain monitoring:
  - rpc-bind
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
    │   └─────── p0wny-shell
    │   └─────── Wall6e-Web-Scripts

    ├── osint
    │   └─────── teeth
    ├── reverse
    │   └─────── peda
    └── cracking
        └─────── cisco_pwdecrypt
```

Moreover, it fetch the burp certificate in order to configure the proxie in firefox via a new profile. Of course, the burp certificate is also registred in the system's certificate store to be handled by other programs. 

Thus, three aliases are configured:

```fireprox``` launch a firefox window configured to work with burp.

```proxie``` change the current settings in order to work with curl or wget through the burp proxie.

```noproxie``` desactivate the proxie settings.

To add new tools, only the "Tools.xml" file must be modified according to the following pattern :

```
<Category>
  <Tool>
    <cmd>   Install script   </cmd>
  </Tool>
</Category>
```

Feel free to introduce new tools in already existing categories, like creating new categories.

