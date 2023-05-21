# BruteForce-to-KeePass
This script complements the results obtained through the ***keepass-password-dumper*** tool when exploiting the CVE-2023-32784 vulnerability affecting KeePass.

# Description
This script prompts the user to input a list of characters and a known suffix. It then generates a list of possible strings (dictionary) by combining each character in the list with the known suffix. The results are saved to a file named "Dictionary.txt" in the current directory.
It then uses the base functionality of the "***PoshKPBrute***" tool (the code has been shortened and adapted) to identify the valid Master Key to access the KeePass database (kdbx file).

# Demo
![BruteForce-to-KeePass](https://infayer.com/wp-content/uploads/2023/05/ent_20230520_11.png)

# Acknowledgements
- The ***keepass-password-dumper*** tool was developed and released by **vdohney** (https://github.com/vdohney/keepass-password-dumper)
- The ***PoshKPBrute*** tool was developed and released by **Wayne Evans** (https://github.com/wevans311082/PoshKPBrute)

Please be sure to give full credit to them.

# References
- https://infayer.com/archivos/1785 (*spanish*)
