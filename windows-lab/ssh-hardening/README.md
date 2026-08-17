# Ticket #:  Security harden Windows

## Summary
Harden Windows hosts' SSH service to prevent unauthorized access, enforce strong authentication, and improve auditability.

## Environment
- Operating System: Windows 10
- TCP protocol: SSH


## Problem
The default SSH configuration on Windows may allow weak authentication methods, permit root login, and lack proper logging, making it vulnerable to unauthorized access and attacks.

## Solution
1. **Disable Weak Authentication Methods**: Configure the SSH server to disallow password-based authentication and only allow key-based authentication.
2. **Disable Root Login**: Modify the SSH configuration to prevent root login, ensuring that only authorized users can access the system.
3. **Enable Logging**: Configure the SSH server to log all authentication attempts and connections for auditing purposes.
4. **Enable fail2ban(win-version)**: Ban any IP of Unathorized users after attempts to login into the server



## Steps
- Ran powershell as administrator in the server and ran `Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH*'` to check if they openssh is installed
- Found and open the sshd_config file to uncomment, disable and enable some presets like pubkeyAuthenication, PasswordAuthenication, PermitEmptyPasswords. I ran `notepad "C:\ProgramData\ssh\sshd_config`
- Generated a key pair on the client pc and copied the public key (.pub) to the server in the `C:\ProgramData\ssh\adiministrator_authorized_keys` because the server account is part of the admins-`ssh-keygen -t ed25519 -c "smoke-20"`
-