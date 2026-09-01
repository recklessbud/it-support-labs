# Automated User Management In Linux
This lab covers automated user onboarding and simple offboarding in Linux using a bash script that processes a CSV file. It addresses user creation, group assignment, password management, home directory permissions, and account disabling for secure access control.

### Preparation

Ensure you have the necessary permissions and tools installed:
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install dos2unix
```

### Files
1. **users.csv**: A CSV file containing user details for onboarding. Each line should contain the username, full_name, primary_group, secondary_groups.
   Example:
   ```
   username1,full_name,primary_group,secondary_groups
   username1,full_name,primary_group,secondary_groups
   ```

2. **onboarding.sh**: The bash script for onboarding and offloading users in the CSV file. The file performs the following:
- Create users and their home directories.
- Establish primary and secondary groups if absent.
- Assign a default password (Welcome123!) and require change on initial login.
- Set home directory permissions to 700 (owner-only access).
- Disable a specified user (e.g., rbrown) as an offboarding example.

### Usage
prepare the CSV for unix
```bash
dos2unix users.csv
```

Make the script executable:
```bash
chmod +x onboarding.sh
```

Run the script:
```bash
sudo ./onboarding.sh users.csv
```

### test
Verify the created users:
```bash
id jdoe
id asmith
id rbrown
```
Expected: the user's UID, GID, groups

Check homw permisions
```bash
ls -ld /home/*
```
Expected: users name and permissions which correspond to 700

Check password Expiration
```bash
sudo chage -l jdoe
```
Expected: Password expires 90 days after creation and must be changed on first login



### Conclusion
- Automate user creation from a CSV input.
- Assign primary and secondary groups dynamically.
- Set temporary passwords with enforced changes on first login.
- Secure home directories with 700 permissions.
- Disable user accounts for offboarding.
