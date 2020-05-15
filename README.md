# A Minimal Know How - HPC Computing Facility

The HPC cluster is configured on CentOS 6.6 with 252 64bit CPU cores, 1TB
aggregated RAM (48GB/node), with 1G Ethernet plus 40-10G QDR Infiniband
interconnects. About 5TB of share storage for user data with large 1TB per-node
'/tmp' disk space as scratch space available for local needs. A sets of
application softwares are being installed (detail can be found [here](http://172.16.22.206/packages.html) - incomplete!!!).
Following sections show very basic information about using this cluster facility.

We have setup a google group for discussions ['<hpciiserm@googlegroups.com>'](mailto:hpciiserm@googlegroups.com).
Please send you querries to this mail id.

## How do I connect to HPC?

To connect using a Mac or Linux, open the Terminal application and type:

    ssh -Y yourlogin@172.16.22.201
    # the '-Y' requests that the X11 protocol is tunneled back to you, encrypted inside of ssh.

Login IP is 172.16.22.201

Be sure to use the '-Y' or '-X' options, if you want to view X11 graphics. Occasionally you may
get the error below when you try to log into HPC or among the HPC nodes:

    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
    Someone could be eavesdropping on you right now (man-in-the-middle attack)!
    It is also possible that the RSA host key has just been changed.
    The fingerprint for the RSA key sent by the remote host is
    31:5f:75:e9:5c:0e:b9:6a:11:e1:7f:98:ee:c2:e8:71.
    Please contact your system administrator.
    Add correct host key in /root/.ssh/known_hosts to get rid of this message.
    Offending key in /root/.ssh/known_hosts:5
    Password authentication is disabled to avoid man-in-the-middle attacks.
    Keyboard-interactive authentication is disabled to avoid man-in-the-middle attacks.
    Agent forwarding is disabled to avoid man-in-the-middle attacks.
    X11 forwarding is disabled to avoid man-in-the-middle attacks.

The reason for this error is that the computer to which you’re connecting to has changed its
identification key (Since you were using IISERM HPC earlier, you might get above
connection error). The fix is buried in the error message itself.

    Offending key in /root/.ssh/known_hosts:5

Simply edit that file and delete the line referenced. When you log in again, there will be a
notification that the key has been added to your 'known\_hosts' file. More simply, you can also
just delete your '~/.ssh/known\_hosts' file. The missing connection info will be regenerated when
you ssh to new nodes.

After you log in…​

The default shell (or environment in which you type commands) for your
HPC login is 'bash'. I am sure, you’re going to be using HPC for more than a few times,
it’s useful to set up a file of aliases to useful commands and then 'source' that
file from your '~/.bashrc'.

## Changing Password

Once you logged into the usernode, you can change password. To change password you must
do following

    [sjena@usernode ~]$ ssh hpciiserm

It will initiate a login session without any password in the server.

NEVER change password in 'usernode', if you do so, it will reset to your
old password.

You should see following prompt like:

    [sjena@hpciiserm ~]$
    then do
    [sjena@hpciiserm ~]$ passwd

change your password and exit.

Once you done above procedure, it will take some time 'at least 90 minutes' (automatic)
to sync. If you exit from 'usernode' and you want to re-login within this time, your old password
should work.

Once you are logged in to 'usernode', you don’t need password to login to any computing node as
the HPC is like a single computer with several cores available to you. However, password is needed
to login from outside to HPC through 'usernode'. HPC is like a single computer with
several cores available to you.

## Other Basic Info - coming soon.

On the login node, you shouldn’t do anything too computationally strenuous. If you run something
that takes more than an hour or so to complete, you should be running on an interactive node or
submit it to one of the batch queues (via 'qsub batch\_script.sh').

### Can I compile code?

Yes.  

We have the full GNU tool-chain available on both the login nodes so normal compilation tools such
as autoconf, automake, libtool, make, gcc, g++, gfortran, gdb, ddd, java, python, perl,
etc are available to you. Please let us know if there are other tools or libraries you need
that aren’t available.

### Compiling your own code

Use gnu-tool chain.

### Adding a Package

Adding a package is similar to keeping the executation or your own program. If you keep any 'executable'
in your area, it will be accessible in all computenode.

The detail is given [here](http://172.16.22.206/hpchowto.html#_installation_of_new_software_packages).

## Storage & Quota

### Disk Space

HPC disk storage is limited and an user quota has been set for all user spaces (/home). All users
are given 10GB of user space. There is no notification system to inform you if you exceed the quota
limit. When you exced the quota limit you won’t be able to perform write operation i.e. can’t create
file or run jobs if you pass the hard quota limit.

10GB of user space to keep your codes and important files. To keep large files, outputs of jobs etc., you should
use '/home/storage1/$USER'.

HPC has about 7TB of storage on to be shared among IISER HPCs users, and the instantaneous needs
of those users varies tremendously. We do not use disk quotas on this storage to enforce user
limits to allow substantial dynamic storage use. However, if you use hundreds of GB, the onus is
on you to clean up your files and decrease that usage as soon as you’re done with it.

(Very Important) Avoid creating huge number of files in a single directory. It will
affect storage performance especially when your job is accessing such directories frequently.
This is called Directory Cache Thrashing.

### Scratch Space

If your code accessing large I/O, you should use local scratch space. This is to prevent this network jam, there is a large '/tmp' directory on each node (writable by all
users, but 'sticky' - files written can only be deleted by the user who wrote them or by admin.
However, if you use hundreds of GB, the onus is on you to clean up your files and decrease that
usage as soon as you’re done with it. (automatic script as regular cleanup will be added if needed).

### Monitoring Disk Usage & Quota

Use 'quota -s' command to see your ussage.

    sjena@usernode~$ quota -s
    Disk quotas for user sjena (uid 500):
         Filesystem  blocks   quota   limit   grace   files   quota   limit   grace
          /dev/sda1   7009M  10240M  11264M           21140   58000   60000

This means:

    Filesystem = /dev/sda1 : this is your home directory
    blocks     = 7009M     : Current data usage is 7009 MB
    quota      = 10240M    : Soft quota limit is 10GB
    limit      = 11264M    : Hard quota limit is 11GB
    grace      =           : if you exceed, it will set a grace period to cleanup
    files      = 21140     : Number of files in your account
    quota      = 58000     : Soft limit for maximum number of files you can create
    limit      = 60000     : Hard limit for maximum number of files you can create

## Batch Job & Queues

### Job Scheduler

Our cluster is configured with SGE Batch Job Submission tool. The Sun Grid Engine (SGE) queuing system is useful when you have a lot of tasks to execute and want to distribute the tasks over a cluster of machines. It has three basic features

-   Scheduling - allows you to schedule a virtually unlimited amount of work to be performed when resources become available. This means you can simply submit as many tasks (or jobs) as you like and let the queuing system handle executing them all.

-   Load Balancing - automatically distributes tasks across the cluster such that any one node doesn’t get overloaded compared to the rest.

-   Monitoring/Accounting - ability to monitor all submitted jobs and query which cluster nodes they are running on, whether they’re finished, encountered an error, etc. Also allows querying job history to see which tasks were executed on a given date, by a given user, etc.

If you would like to know more, you may prefer to check a plenty of documents available in the web. Let me start with what minimal set of information (mostly taken from web from several sources)

### Submitting Jobs

A job in SGE represents a task to be performed on a node in the cluster and contains the command line used to start the task. A job may have specific resource requirements but in general should be agnostic to which node in the cluster it runs on as long as its resource requirements are met.

    All jobs require at least one available slot on a node in the cluster to run.

Submitting jobs is done using the 'qsub' command. Let’s try submitting a simple job that runs the 'hostname' command on a given cluster node:

    sjena@usernode~$ qsub -V -b y -cwd hostname
    Your job 1 ("hostname") has been submitted

-   The -V option to qsub states that the job should have the same environment variables as the shell executing qsub (recommended)

-   The -b option to qsub states that the command being executed could be a single binary executable or a bash script. In this case the command hostname is a single binary. This option takes a y or n argument indicating either yes the command is a binary or no it is not a binary.

-   The -cwd option to qsub tells Sun Grid Engine that the job should be executed in the same directory that qsub was called.

-   The last argument to qsub is the command to be executed (hostname in this case)

Notice that the qsub command, when successful, will print the job number to stdout. You can use the job number to monitor the job’s status and progress within the queue as we’ll see in the next section.

Job submissions are done in a dedicated Node called 'usernode' in our HPCIISERM, executions happen on
all compute nodes. You are requested not to execute any job in 'usernode' - node where you
login in. If you run manual jobs in usernode, jobs will be killed automatically. Therefore, you \[red\]\# MUST \#
use SGE commands for job submission, for instance, 'qsub' to submit job. If you use 'qsub', the submission will
be taken care automatically.

Never login to 'hpciiserm' as well as NEVER should submit any job in 'hpciiserm' - Jobs will be terminated without notice and the automated script might block the account.

### Monitoring Jobs in the Queue

Now that our job has been submitted, let’s take a look at the job’s status in the queue using the command 'qstat':

    [sjena@usernode ~]$ qstat
    job-ID  prior name  user state submit/start at queue      slots      ja-task-ID
    ...............................................................................
    4001 0.55500 hostname   sjena r  03/03/2017 10:16:32 all.q@compute-0-0.local  1
    [sjena@usernode ~]$

From this output, we can see that the job is in the 'r' state which is running in node compute-0-0.
Once the job has finished, the job will be removed from the queue and will no longer appear in the
output of 'qstat'. You should see the job outputs

### Outputs

SGE creates stdout and stderr files in the job’s working directory for each job executed. If any additional files are created during a job’s execution, they will also be located in the job’s working directory unless explicitly saved elsewhere (I will discuss later).The job’s stdout and stderr files are named after the job with the extension ending in the job’s number. For the simple job submitted above, we have:

    [sjena@usernode ~]$ ls
    hostname.e4001  hostname.o4001  mpi
    [sjena@usernode ~]$ cat hostname.e4001
    [sjena@usernode ~]$ cat hostname.o4001
    compute-0-0.local
    [sjena@usernode ~]$

Notice that SGE automatically named the job 'hostname' and created two output files: 'hostname.e4001' and 'hostname.o4001'. The 'e' stands for stderr and the 'o' for stdout. The '4001' at the end of the files’ extension is the job number. So if the job had been named 'extraordinary\_job' and was job '\#47' submitted, the output files would look like: 'extraordinary\_job.e47' 'extraordinary\_job.o47'

### Deleting a Job

What if a job is stuck in the queue, is taking too long to run, or was simply started with incorrect parameters? You can delete a job from the queue using the 'qdel' command in SGE. Below we launch a simple job 'mpi-ring.qsub', and we can kill it using 'qdel':

    [sjena@usernode mpi]$ qsub -pe orte 24 mpi-ring.qsub
    Your job 4009 ("mpi-ring.qsub") has been submitted

Check the Job status

    [sjena@usernode mpi]$ qstat
    job-ID  prior name  user state submit/start at queue      slots      ja-task-ID
    ...............................................................................
       4009 0.00000 mpi-ring.q sjena        qw    03/03/2017 11:24:09            24

'qw' means Job is in waiting stage. you can an kill it here, but we want job to run
and then kill. Checking again after few second:

    [sjena@usernode mpi]$ qstat
    job-ID  prior name  user state submit/start at queue      slots      ja-task-ID
    ...............................................................................
       4009 0.55500 mpi-ring.q sjena r 03/03/2017 11:24:17 all.q@compute-0-5.local 24

'r' means Job has started. Send a kill signal by 'qdel jobid' and check the status.

    [sjena@usernode mpi]$ qdel 4009
    sjena has registered the job 4009 for deletion

    [sjena@usernode mpi]$ qstat

After running qdel you’ll notice the job is gone from the queue:
'qstat' returns nothing, i.e. 'qdel' has killed the job.

### Monitoring Cluster Usage

SGE uses 'qstat' to check the job status. I have submitted 10 jobs, which need
10 core each. I would type 'qstat' and it will show me everything

    [sjena@usernode mpi]$ qstat
    job-ID  prior name  user state submit/start at queue      slots      ja-task-ID
    ...................................................................................
       4010 0.55500 mpi-ring.q sjena  r 03/03/2017 11:35:02 all.q@compute-0-11.local 10
       4011 0.55500 mpi-ring.q sjena  r 03/03/2017 11:35:02 all.q@compute-0-11.local 10
       4012 0.55500 mpi-ring.q sjena  r 03/03/2017 11:35:02 all.q@compute-0-12.local 10
       4013 0.55500 mpi-ring.q sjena  r 03/03/2017 11:35:02 all.q@compute-0-13.local 10
       4014 0.55500 mpi-ring.q sjena  r 03/03/2017 11:35:02 all.q@compute-0-14.local 10
       4015 0.55500 mpi-ring.q sjena  r 03/03/2017 11:35:02 all.q@compute-0-15.local 10
       4016 0.55500 mpi-ring.q sjena  r 03/03/2017 11:35:02 all.q@compute-0-19.local 10
       4017 0.55500 mpi-ring.q sjena  r 03/03/2017 11:35:02 all.q@compute-0-19.local 10
       4018 0.55500 mpi-ring.q sjena  r 03/03/2017 11:35:02 all.q@compute-0-16.local 10
       4019 0.55500 mpi-ring.q sjena  r 03/03/2017 11:35:02 all.q@compute-0-17.local 10
    [sjena@usernode mpi]$

You can also view the average load (load\_avg) per node using the ‘-f’ option to qstat:

    [sjena@usernode mpi]$ qstat -f
    queuename                      qtype resv/used/tot. load_avg arch      states
    ..............................................................................
    all.q@compute-0-0.local        BIP   0/0/12         0.00     linux-x64
    ..............................................................................
    all.q@compute-0-1.local        BIP   0/0/12         0.00     linux-x64
    ..............................................................................ZZZZ
    all.q@compute-0-10.local       BIP   0/0/12         0.00     linux-x64
    ..............................................................................
    all.q@compute-0-11.local       BIP   0/12/12        0.00     linux-x64
       4010 0.55500 mpi-ring.q sjena        r     03/03/2017 11:35:02    10
       4011 0.55500 mpi-ring.q sjena        r     03/03/2017 11:35:02     2
    ..............................................................................
    all.q@compute-0-12.local       BIP   0/12/12        0.00     linux-x64
       4011 0.55500 mpi-ring.q sjena        r     03/03/2017 11:35:02     8
       4012 0.55500 mpi-ring.q sjena        r     03/03/2017 11:35:02     4
    ....

    ....
    ..............................................................................
    all.q@compute-0-8.local        BIP   0/0/12         0.00     linux-x64
    ..............................................................................
    all.q@compute-0-9.local        BIP   0/0/12         0.00     linux-x64
    ..............................................................................
    [sjena@usernode mpi]$

### qsub scripts

In the ‘Submitting a Job’ section we submitted a single command 'hostname'. This is useful for simple jobs but for more complex jobs where we need to incorporate some logic we can use a so-called 'job script'. A job script is essentially a bash script that contains some logic and executes any number of external programs/scripts.
The shell script that you submit (for example 'job\_name.sh') should be written in 'bash' and should
completely describe the job, including where the inputs and outputs are to be written (if not
specified, the default is your home directory). The following is a simple shell script that
defines 'bash' as the job environment, calls 'date', waits 20s and then calls it again.

    #!/bin/bash

    # request Bourne shell as shell for job
    #$ -S /bin/bash

    # print date and time
    date
    # Sleep for 20 seconds
    sleep 20
    # print date and time again
    date

Note that your script has to include (usually at the end) at least one line that executes something
- generally a compiled program but it could also be a Perl or Python script (which could also
invoke a number of other programs). Otherwise your SGE job won’t do anything.

And to submit above script 'job\_name.sh', you would do:

    [sjena@usernode mpi]$ qsub -V job_name.sh
    Your job 4048 ("job_name.sh.sh") has been submitted
    ----------------------------

    Using qsub scripts to keep data local
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    HPC depends on a network-shared '/data' filesystem.  The actual disks are on a network file server
    node so users are local to the data when they log in.  However, when you submit an SGE job, unless
    otherwise specified, the nodes have to read the data over the network and write it back across the
    network.  This is fine when the total data involved is a few MB, such as is often the case with
    molecular dynamics runs - small data in, lots of computation, small data out.  However, if your
    jobs involve 100s or 1000s of MB, the network traffic can grind the entire cluster to a halt.

    To prevent this network jam, there is a large '/tmp' directory on each node (writable by all
    users, but 'sticky' - files written can only be deleted by the user who wrote them or by admin.
    However, if you use hundreds of GB, the onus is on you to clean up your files and decrease that
    usage as soon as you’re done with it. (automatic script as regular cleanup will be added if needed).

    following is an example script (self explanatory)

    -----------------------------------------------
    #!/bin/bash
    ################################
    # Example to use /tmp space - qsub script
    # Written for IISER HPC community
    # Author: S. Jena
    # Sat Mar  4 14:23:52 IST 2017
    ################################
    #
    ###### BEGIN SGE PARAMETERS - note the '#$' prefix ######
    ###### DO NOT SET THE -cwd flag for a /tmp job
    #
    #$ -S /bin/bash
    # specify the name of the job displayed in 'qstat' output
    #$ -N sjena-job
    #
    ######## Where to keep Log Output #########
    # Make sure you have  a directory log in your HOME
    #$ -o log/
    #$ -e log/

    ###### BEGIN  /tmp DIR CODE  ######
    # set the STDATA to point to the node-local /tmp dir and make sure you
    # place the files in your own subdir. '${USER}' is global environment
    # variable inherited by all your processes, so you shouldn't have to
    # define it explicitly

    #JOB_ID get the job number and we keep output in folder with this number

    COPUT="ANYINDEX${JOB_ID}  # change ANYINDEX to anything of your choice

    STDATA="/tmp/${USER}/"${COPUT}  # STDATA - Standard output folder in /tmp

    ####$HOME is another automatic global variable

    MYAPP="${HOME}/test/my_executable_bin"  # Path to executable
    FOUTPUTD="${HOME}/test/output"          # final output folder (global)

    # 'mkdir -p' creates all the nec dirs to the final dir specified if
    # needed and does not complain if it exists already

    mkdir -p ${STDATA}  # creates dir on the local compute node /tmp/user
    mkdir -p ${FOUTPUTD} # creates the dir in your $HOME - final output

    cd ${STDATA}

    # since this job will be done on many nodes, just to check where it runs

    cd ${STDATA}
    FILE=`hostname`
    pwd

    ${MYAPP} > output.${JOB_ID}.txt   # keeping outut into a file with JOB_ID name

    # Once Done move out the outputs form /tmp directory

    cd ../
    cp -r ${COPUT} ${FOUTPUTD}/.

    # and clean up your mess on /tmp
    rm -rf ${COPUT} # clean up the /scratch
    -------------------------------------------------------

    In this example all data output will be stored in '$HOME/test/output' and this is
    expected to be small output. If it is large output, you must redirect it to the
    NFS data-space.

    Similarly, you can write scripts for parallel jobs.

    == Parallel Jobs

    We have already set the OpenMPI and integrated to SGE. This integration allows Sun Grid Engine
    to handle assigning hosts to parallel jobs and to properly account for parallel jobs.

    OpenMPI Parallel Environment
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    StarCluster by default sets up a parallel environment, called 'orte', that has been
    configured for OpenMPI integration within SGE and has a number of slots equal to the
    total number of processors in the cluster. You can inspect the SGE parallel environment
    by running:

    -------------------------------------------
    [sjena@usernode ~]$ qconf -sp orte
    pe_name            orte
    slots              9999
    user_lists         NONE
    xuser_lists        NONE
    start_proc_args    /bin/true
    stop_proc_args     /bin/true
    allocation_rule    $fill_up
    control_slaves     TRUE
    job_is_first_task  FALSE
    urgency_slots      min
    accounting_summary TRUE
    [sjena@usernode ~]$
    -------------------------------------------
    NOTE: at this stage we don't support 'allocation_rule for round_robin'. This is important for those who are using it.
    This is the default configuration. With this allocation, if a user requests 8 slots and a single machine has 8 slots
    available, that job will run entirely on one machine. If 5 slots are available on one host and 3 on another, it will
    take all 5 on that host, and all 3 on the other host.

    Submitting OpenMPI Jobs
    ~~~~~~~~~~~~~~~~~~~~~~~

    The general workflow for running MPI code is: Compile the code using 'mpi compilers' like 'mpicc'.. The produced executable can be used in parallel environment of SGE.
    It is important that the path to the executable is identical on all nodes for mpirun to correctly launch your parallel code. The easiest approach is to copy the executable somewhere under '/home/user' on the usernode since '/home/user' is NFS-shared across all nodes in the cluster.

     Run the code on X number of machines using:
    ----------------------------------------------------------
        $ mpirun -np X -hostfile myhostfile ./mpi-executable arg1 arg2 [...]
    ----------------------------------------------------------
    where the hostfile looks something like:
    ------------------------
    $ cat /path/to/hostfile
    compute-0-0    slots=4
    compute-0-1    slots=4
    compute-0-11   slots=4
    compute-0-12   slots=4
    compute-0-13   slots=4
    ------------------------

    However, when using an SGE parallel environment with OpenMPI you no longer have to specify the -np, -hostfile, -host, etc. options to mpirun.
    This is because SGE will automatically assign hosts and processors to be used by OpenMPI for your job. You also do not need to pass the -byslot and -bynode options to mpirun given that these mechanisms are now handled by the fill_up and round_robin modes specified in the SGE parallel environment.

    Instead of using the above formulation create a simple job script that contains a very simplified mpirun call:
    ----------------------
    $ cat myjobscript.sh
    mpirun /path/to/mpi-executable arg1 arg2 [...]
    ----------------------
    Then submit the job using the qsub command and the orte parallel environment automatically configured for you by StarCluster:

    ----------------------
    $ qsub -pe orte 24 ./myjobscript.sh
    ----------------------
    The -pe option species which parallel environment to use and how many slots to request. The above example requests 24 slots (or processors) using the orte parallel environment. The parallel environment automatically takes care of distributing the MPI job amongst the SGE nodes using the allocation_rule defined in the environment’s settings.

    NOTE: If you believe I have made some mistake, or the new implimentation needs more
    clarification, let me know.

    == Installation of New Software/Packages

    There are several softwares/packages are installed (open source) centrally and the list is
    available http://172.16.22.206/packages.html[here].

    On contrary, it is also possible to install application/software by 'user' into their
    own area. Once a user compiles and install, the binary will be automatically available
    in every compute-node. In case of software with large (>2GB) size,
    'user' may request to 'sysad' to install the application/software centrally (follow point 2).

    NOTE: (1): There might be a situation where an 'user' wants to install a package which
    is purchased by him/her: install it in your own area. Please note that, it will be the
    responsibility of respective 'user' to take care the licensing and authorizations.

    NOTE: (2): Central installation (open-source package): 'user' may request
    to install it centrally. In this case, 'user' should provide us the detail of software
    (like sources, web links etc.), the dependencies, pre-requisites and compilation procedure.
    In some occasion, 'sysad' may ask the concerned user to assist installation.

    NOTE: (3): Central installation (licenced package): The licencing should be of
    'cluster' type or 'group-licence' type.  'user' should provide info as above and
     provide the licencing process (may help to secure lincence).


    == Author's Note

    This document is very naive and under continuous change depending on the requests we recieve.
    It is being written from the information available with me and from several sources available
    on internet. So, Do not hesitate to contact us.

    By mailto:sjena@iisermohali.ac.in[S. Jena] +
    Document version: V1.1.1 12/06/2017 +
    Document version: V1.1.0 23/03/2017 +
    Document version: V1.0.2 16/03/2017 +
    Document version: V1.0.1 04/03/2017 +
