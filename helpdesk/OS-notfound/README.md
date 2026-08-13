# Ticket #: Windows Fails to Boot After Removing Linux Partition ("Operating System Not Found")


## Priority
- Critical

## Summary
User had a Windows/Ubuntu dual-boot setup. After installing the Ubuntu using the internal HDD , the system could no longer boot into Windows, showing "Operating system not found." Resolved with no data loss by rebuilding the Windows boot files.


## Environment
- Dual-boot system: Windows + Ubuntu on a single disk
- Disk partition style: MBR
- Boot mode: Legacy/BIOS

## Symptom
On restart, the system displayed **"Operating system not found"** instead of loading Windows. The Windows files themselves were confirmed intact and accessible from a recovery environment.

## Root Cause
The disk was originally configured to dual-boot, with **GRUB** (Ubuntu's bootloader) acting as the boot manager for both operating systems. GRUB only displayed ubuntu in the bootmanager making it harder to impossible to boot into windows, even though Windows itself was untouched.



## Diagnosis Steps
1. Booted into Ubuntu to try fix the problem with the boot-repair tool, checked repair-windows and ran
2. Booted from Windows installation media and opened Command Prompt via *Repair your computer > Troubleshoot > Advanced options*.
3. Ran `diskpart` → `list disk` to confirm partition style (no `*` in the GPT column confirmed **MBR**).
4. Attempted standard boot repair:
   ```
   bootrec /fixmbr
   bootrec /fixboot
   bootrec /scanos
   bootrec /rebuildbcd
   ```
   → Failed with "The requested system device cannot be found."
5. Ran `diskpart` → `list volume` to inspect all partitions and identify the actual Windows partition (confirmed via `dir X:\Windows` showing `System32`).
6. Found the small System Reserved (boot) partition had a filesystem of **RAW**: meaning it had no valid filesystem and could not be written to. This was the actual point of failure, not a missing BCD entry.

## Resolution
Rather than trying to repair the corrupted 500MB boot partition, boot files were rebuilt directly onto the main Windows partition instead:

1. Marked the Windows partition itself as **active**:
   ```
   diskpart
   select disk 0
   select partition [Windows partition number]
   active
   ```
2. Rebuilt the boot files targeting the Windows partition for both the source and destination:
   ```
   bcdboot X:\Windows /s X: /f BIOS
   ```
   (where `X:` = the Windows drive letter)
3. Received confirmation: *"Boot files successfully created."*
4. Removed installation media and rebooted  Windows loaded successfully.

## Outcome
- Windows booted normally with **zero data loss**.
- The corrupted 500MB partition was left in place temporarily (harmless) pending a few stable reboots, then scheduled for cleanup via Disk Management.

## Lessons Learned / Recommendations
- When dual-booting, **install Windows first, then Linux**: this avoids GRUB taking over as the primary bootloader, so deleting the Linux partition later doesn't strand Windows.
- If a boot partition is corrupted (RAW/unreadable), don't waste time repairing it: `bcdboot` can place boot files directly on the OS partition itself as a reliable workaround.
- Always confirm actual drive letters in the recovery environment via `list volume` rather than assuming they match the normal Windows session recovery mode frequently reassigns them.

---
*Tools used: Windows Recovery Environment, `diskpart`, `bootrec`, `bcdboot`*
*Time to resolution: ~30–45 minutes*
