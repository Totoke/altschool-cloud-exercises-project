# LINUX COMMANDS
Linux commands are programs or utilities that run on the console and interact with the system. They are prompts for the system to execute.
Here is a list of some linux commands
## 1. df Command
The _df_ command is used to report the system's disk space usage. The directory's system disk space can be displayed in different options or format, either in **MBs**, **KBs** or **system type**. Here is a screenshot of a directory space shown in **Mb**. ![df command](df%20command.png)
## 2. du Command
Like the _df_ command, the _du_ command is used to check the space a file or directory takes up.This command can be used to identfy which file or directory takes up the largest part of the storage space. Below is an image of the outcome of the command. ![du command](du%20command.jpg)
## 3. Unix name (uname) Command
The **unix name** 0r _uname_ command shows a detailed information of the linux systemand hardware including the machine name, operating system and kernel. To run this command, simply enter **uname** with the appropriate flag (be it **-a** for all information, **-s** for the kernel name or **-n** for the node hostname). Here is a screenshot of the _uname_ command. ![uname command outcome](uname%20command.jpg)
## 4. History Command
History command shows all previously executed commands. The command can display up to five hundred (500) previously executed commands. This command can be modified to perform other functions such as:
* clearing the entire history llist using **history -c**
* appending history line with **history -a** etc...
![History command output](His.%20cmmand.jpg)
## 5. The Process Status (ps) Command
The **ps** command when executed shows the running process in the system, when executed with the appropriate flag, it displays the running processes with the **unique process ID (PID)**, **the terminal type (TTY)**, the running time and the command that launches the process **(CMD)**. See the image below.
![](ps%20command.jpg)
## 6. Find Command
The find command is used to find files located within a given directory. It can be modified for usage in a couple of ways such as finding the empty files in a specified directory and mamy more. See image below.
![output of executed find cmmand](find%20command.jpg)