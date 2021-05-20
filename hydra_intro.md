# Running jobs on HPC scheduler

Objectives:
* Learn how to connect to Hydra remotely and from the Smithsonian network.
* Learn some basic Unix commands for navigating the filesytem in Hydra.
* Learn best practices for organizing your project directories.
* Learn how to submit a job to the HPC scheduler.
* Learn how to transfer results to your local computer.

## Logging In

The way that you connect to Hydra and issue commands is through a command line terminal program.

### Usernames
Your Hydra username is typically the same as your SI username (the portion of your email address before `@si.edu`).

| When you see `{user}` in this tutorial, replace that with your Hydra username!|
|---|

### Password
Your Hydra password is independent of your Smithsonian network password.

*See the Password Reset section below if you need to reset your password.*

### telework.si.edu

The [telework.si.edu](https://telework.si.edu) is available from inside the Smithsonian network as well as remotely, There is a web-based terminal program to access Hydra.

After logging in, expand the "IT Tools" section choose "Hydra".

<img src="images/telework-hydra-icon.png" width=300px alt="Hydra icon on telework site">

Click on one of the "SSH terminal" links to start the web terminal connection to one of the login nodes.

<img src="images/web-terminal.png" width=400px alt="web based terminal options for hydra">

At the `login:` prompt, enter your Hydra username and at the `password:` prompt, enter your Hydra password.

### Windows

For Windows users, we recommend using the ssh client that is built in to the Command prompt of recent Windows 10 versions. (The free program, [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html), is an alternative option).

Open the command prompt from the Start menu (type "command" or "cmd" in the search bar).

In the command prompt window start the hydra connection with: `ssh {user}@hydra-login01.si.edu`. If you get an alert about the authenticity of the host, type `yes`. Enter your Hydra password at the `Password:` prompt.

### Mac

If you are on a Mac, open the Terminal program which can be found in the Utilities folder inside the Applications folder (or type "terminal" in the popup Spotlight search).

<img src="images/terminal.png" width=100px alt="Mac terminal.app icon">

Login with your Hydra username and password:
```
$ ssh {user}@hydra-login01.si.edu
```

### Resetting your password

Hydra has a self-service password reset system if your password expires or is forgotten.

There is a link to this page on the page that lists Hydra's web-based tools.
- Telework: go to the Hydra option in "IT Tools" on the Telework site and choose "Password Self Help"
- On-site/VPN: go to https://hydra-adm01.si.edu/

There are two pages in the Self Help system. The initial one is to change your password (password changes are required every 180 days).

To create a new password choose "Request an email with a password reset link"

<img src="images/reset-link.png" alt="Password reset link" width=350px>

Enter your Hydra **user name** (not email) in the "Login" box and then press Send

<img src="images/reset-user-name.png" alt="Password reset link" width=200px>

A reset link will be emailed to your institutional email account.

## Creating a project directory

Now that we are successfully logged in, you will see a little blurb about recent Hydra news. Make sure you read this.

You will also see a prompt that looks like this:

```
[{user}@hydra-login01 ~]$ _
```

By default, you are placed in your "home" directory when you first log in. You can see where you are at any point with the `pwd` command, which stands for "print working directory". Try entering it now.

```
$ pwd
/home/{user}
```
|Don't enter the `$` in these examples, that is showing the command prompt|
|---|

Another useful command for getting a feeling for the file system is `ls`, which is short for "list". It will list the files in your current working directory.

```
$ ls
```

Most commands Unix commands let you add extra *parameters* that give you more control over what you want the command to do. Let's enter the same `ls` command again, and add the `-l`, which stands for "long listing" that shows more information about the files.

```
$ ls -l
```

You can see the surprisingly large list of `ls` options in its manual page in the built-in help system `man`. Man pages are extensive and for a beginner be less helpful than Google-ing for the options you want.

```
$ man ls
```

**Use the arrow keys or space bar to scroll through the man page and enter `q` when you're done**

Your `/home` directory has a relatively small size limit, so you don't store data here. Your `/scratch` directory is where you should run your jobs from.

Let's move to the "/scratch" directory with the `cd` command, which stands for "change directory". Feel free to use the `pwd` and `ls` commands again to see what has changed.

```
$ cd /scratch/genomics/{user}
```

Now that we're in the correct location, it is best practice to create a separate directory for each "project" you are working on. You can make a new directory with the `mkdir` command.

```
$ mkdir hydra_workshop
```

And now enter the new project directory by using the `cd` command again.

```
$ cd hydra_workshop
```

Now that we're in our project directory, it's also best practice to create an organizational structure so that we can come back in a few weeks and remember what we did. This structure is a good start, but feel free change based on your needs as you gain experience.

We're going to create multiple directories in one command by listing them all. The `-p` option for `mkdir` is really useful, it creates the parent directory if it doesn't already exist. This automnatically create the `data` directory when we say we want `data/raw` and `data/results` created.

```
$ mkdir -p jobs logs data/raw data/results
```

Now that our scaffold is built, you can visualize it with the `tree` command.

```
$ tree
.
├── data
│   ├── raw
│   └── results
├── jobs
└── logs

5 directories, 0 files
```


## Modules

System-wide software installations on Hydra are packaged in the form of *modules*.

Modules are a way to set your system paths and environmental variables for use of a particular program or pipeline.

| If you would like to install your own software on Hydra, you can compile code from source or use a management system like Conda. Check out the [Conda tutorial](https://confluence.si.edu/display/HPC/Conda+tutorial) on the Hydra wiki for more info. |
| --- |

You can view available modules with the command:

```
$ module avail
```

This will output all modules installed on Hydra.

You can see module-specific help for any module with the `module help` command. These are written as part of the Hydra installation process, and should not be mistaken for the official documentation for the software.

```
$ module help bioinformatics/iqtree

-----------Module Specific Help for /share/apps/modulefiles/bioinformatics/iqtree/1.6.12:


Purpose
-------
This module file defines the system paths for IQTREE 1.6.12
The compiled binary that you can now call is:
iqtree
iqtree-mpi
iqtree-mpi-hybrid

Documentation
-------------
http://www.cibiv.at/software/iqtree/

<- Last updated: Fri Nov  1 07:54:22 EDT 2019 ->
```

Ok, now let's actually load IQ-TREE.

```
$ module load bioinformatics/iqtree
```

Nothing happens, but let's run a quick command to show that we have IQ-TREE loaded properly.

```
$ iqtree -h
IQ-TREE multicore version 1.6.12 for Linux 64-bit built Aug 15 2019
Developed by Bui Quang Minh, Nguyen Lam Tung, Olga Chernomor,
Heiko Schmidt, Dominik Schrempf, Michael Woodhams.

Usage: iqtree -s <alignment> [OPTIONS]

GENERAL OPTIONS:
  -? or -h             Print this help dialog
  -version             Display version number
  -s <alignment>       Input alignment in PHYLIP/FASTA/NEXUS/CLUSTAL/MSF format
...
```

|*In this exercise we loaded a module on the login node, but to run an analysis, we need to submit a job to the cluster*|
|---|

## Submitting a job

We're going to create an IQ-TREE job file to submit to be run on one of the compute nodes.

First of all, let's copy a sample input file into our `data/raw` directory. We will use the `cp` command, which takes in 2 *arguments*: the file you want to copy, and then the new location.

```
$ cp /data/genomics/workshops/intro_hydra/exon_50per_taxa.phy data/raw/
```

*Best practice: use tab completion to automatically extend a directory or file name without manually typing the whole name, this also avoids typos.*

This [sequence alignment](https://doi.org/10.17632/ty5h3y9rwx.1) is from [Wood et al.’s 2018 spider UCE paper](https://doi.org/10.1016/j.ympev.2018.06.038).

Now that the input file is in place, we'll need to generate a job submission file.

We will be using the Hydra QSub Generation Utility to create this file.

There is a link to this page on the page that lists Hydra's web-based tools.
- Telework: go to the Hydra option in "IT Tools" on the Telework site and choose "Password Self Help"
- On-site/VPN: go to https://hydra-adm01.si.edu/

* *CPU time*: short
* *Memory*: 4 GB
* *Type of PE*: multi-thread
* *Number of CPUs*: 2
* *Select the job's shell*: sh
* *Select which modules to add*: bioinformatics/iqtree
* *Job specific commands*:

```
iqtree -s ../data/raw/exon_50per_taxa.phy \
       -m GTR+F+R4 \
       -nt $NSLOTS \
       -pre ../data/results/exon_50per_taxa
```

* *Job Name*: iqtree
* *Log File Name*: iqtree.log
* *Err File Name*: [blank]
* *Change to CWD*: Y
* *Join output & error files*: Y
* *Send email notifications*: Y
* *Email*: [your email]

This will generate the contents of your "job file" at the bottom. Click on the "Check if OK" button for any errors and then "Save it" to save to your computer.

Now we need to get this into a file on Hydra. We'll use the utility ffsend hosted on the site https://send.vis.ee which uploads your files to a cloud service and returns a URL you can download the file from on Hydra.

Open the https://send.vis.ee website and upload your file.
Copy the link with the "Copy link" button.

Change directories into the "jobs" directory.

To download we need to first load the ffsend module and then download the file by pasting `ffdownload` and the copied url.

Note for users of the telework interface on Windows: to paste the URL you have to right click on the Hydra web page to get a pop-up menu. Choose "Paste from browser" and the use control-v to paste the ffsend url into the pop-up window at the top of the page and then press OK.

```
$ module load tools/ffsend
$ ffdownload https://send.vis.ee/download/id/#id
```

Confirm the file is as expected by showing its contents with the `cat` command

```
$ cat iqtree.job
```

You're finally ready to submit your job to the compute nodes, using the `qsub` command. ("q", short for "queue" and "sub" for "submit")

```
$ qsub iqtree.job
```

## Monitoring your job

This IQ-TREE analysis will take a few minutes to complete.

You can use `qstat` ("stat" for "status") to check on your cluster jobs.

```
$ qstat
```

If nothing appears here, then your job is finished, but you can't tell yet if it was successful or failed.

**Hint: if your job disappears from the `qstat` list in a few seconds it likely means it failed.**

 When `qstat` no longer shows your job, you can now `cd` into your `../data/results` directory to see if iqtree produced output files.

**If your job finishes without producing the expected output files, your first instinct should be to check the log file.**

TODO: I don't have the log file going into log

To check the log file, `cd` to the `log/` directory and read the entire contents with the `more` command.

```
$ more iqtree.log
```

*Use the space bar to page through the file.*

Note the job id that is listed in here on one of the first lines

```
+ Thu May 20 13:38:30 EDT 2021 job iqtree started in sThC.q with jobID=21884560
```

You can now use the jobID to look at resources used during your run. This is useful for troubleshooting when memory limits are hit. We'll use `qacct+` a Hydra specific wrapper to the standard `qacct` program.

```
$ module load tools/local
$ qacct+ -j {job ID}
```

*Pay specific attention to the maxvmem line of the output. This shows the maximum amount of virtual memory that your job used. If this is significantly less than the amount you requested, make sure to adjust in future jobs.*

## Transferring files

The best way to transfer files depends on your connection to Hydra.

TODO: work on this :)

If you haven't already, go ahead and install a file transfer client. We recommend FileZilla, which you can download from [https://filezilla-project.org/download.php?show_all=1](https://filezilla-project.org/download.php?show_all=1). DO NOT USE THE SKETCHY INSTALLER AT [https://filezilla-project.org/download.php?type=client](https://filezilla-project.org/download.php?type=client), which comes with "bundled offers".

In the Quickconnect toolbar at the top of the window enter:

* Host: hydra-login01.si.edu or hydra-login02.si.edu
* Username: your Hydra username
* Password: your Hydra password
* Port: 22

Press the "Quickconnect" button to start the connection.

The files listed on the left side of the window are on your local computer, those on the right are on Hydra.

Enter your `/scratch/genomics/{user}` filepath in the "Remote site" entry on the right side. You can than use the file tree on the right to navigate to your result files.

Drag the ".treefile" file to the left side in an appropriate directory on your local computer.

Now, go to [https://icytree.org/](https://icytree.org/) in a web browser, and open up the ".treefile" file to view the tree.

## Interactive queue

Hydra has another way of running jobs on the compute nodes, without using the job scheduler. Let's try to run the exact same iqtree command using this technique.

First, you need to use the `qrsh` command to enter this environment. The main parameter to know is how many threads you will be using.

```
$ qrsh -pe mthread 2
```

An important point to note with the interactive queue is that is always places you back in your `/home` directory, which can be confusing.

```
$ pwd
/home/{user}
```

So let's go back to our "hydra_workshop" directory.

```
$ cd /scratch/genomics/{user}/hydra_workshop
```

And now we can directly run the same commands that we listed out in our job file.

```
module load bioinformatics/iqtree
```

And then the same iqtree command -- but changing the data paths, since we're in the main project directory now.

```
iqtree -s data/raw/primates.dna.phy -nt 2 -pre data/results/primates.dna
```

Note: in the interactive queue, `$NSLOTS` is not set automnatically by the system, so we need to use `-nt 2` (2 for the two CPUs we requested in the `qrsh -mthread 2` command) instead of `-nt $NSLOTS`
