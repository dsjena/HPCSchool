# HPCSchool: How to submit jobs example scripts

## Submitting Jobs
~~~~~~~~~~~~~~~
A job in SGE represents a task to be performed on a node in the cluster and contains the command line used to start the task. A job may have specific resource requirements but in general should be agnostic to which node in the cluster it runs on as long as its resource requirements are met.

------
All jobs require at least one available slot on a node in the cluster to run.
------

[red]#Submitting jobs is done using the 'qsub' command#. Let’s try submitting a simple job that runs the 'hostname' command on a given cluster node:
-----
sjena@usernode~$ qsub -V -b y -cwd hostname
Your job 1 ("hostname") has been submitted
-----

    - The -V option to qsub states that the job should have the same environment variables as the shell executing qsub (recommended)
    - The -b option to qsub states that the command being executed could be a single binary executable or a bash script. In this case the command hostname is a single binary. This option takes a y or n argument indicating either yes the command is a binary or no it is not a binary.
    - The -cwd option to qsub tells Sun Grid Engine that the job should be executed in the same directory that qsub was called.
    - The last argument to qsub is the command to be executed (hostname in this case)

Notice that the qsub command, when successful, will print the job number to stdout. You can use the job number to monitor the job’s status and progress within the queue as we’ll see in the next section.


NOTE: Job submissions are done in a dedicated Node called 'usernode' in our HPCIISERM, executions happen on 
all compute nodes. [red yellow-background large]#You are requested not to execute any job in 'usernode'# - node where you
login in. If you run manual jobs in usernode, jobs will be killed automatically. Therefore,  you [red]# MUST # 
use SGE commands for job submission, for instance, 'qsub' to submit job. If you use 'qsub', the submission will 
be taken care automatically.

NOTE: [red yellow-background large]#Never login to 'hpciiserm' as well as NEVER should submit any job in 'hpciiserm'# - Jobs will be terminated without notice and the automated script might block the account. 


Monitoring Jobs in the Queue
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Now that our job has been submitted, let’s take a look at the job’s status in the queue using the command 'qstat':
-------------------------------------------------------------------
[sjena@usernode ~]$ qstat
job-ID  prior name  user state submit/start at queue      slots      ja-task-ID 
...............................................................................
4001 0.55500 hostname   sjena r  03/03/2017 10:16:32 all.q@compute-0-0.local  1        
[sjena@usernode ~]$ 
-------------------------------------------------------------------

From this output, we can see that the job is in the 'r' state which is running in node compute-0-0. 
Once the job has finished, the job will be removed from the queue and will no longer appear in the 
output of 'qstat'. You should see the job outputs

Outputs
~~~~~~~

SGE creates stdout and stderr files in the job’s working directory for each job executed. If any additional files are created during a job’s execution, they will also be located in the job’s working directory unless explicitly saved elsewhere (I will discuss later).[red]#The job’s stdout and stderr files are named after the job with the extension ending in the job’s number#. For the simple job submitted above, we have:

---------------------------------
[sjena@usernode ~]$ ls
hostname.e4001  hostname.o4001  mpi
[sjena@usernode ~]$ cat hostname.e4001
[sjena@usernode ~]$ cat hostname.o4001
compute-0-0.local
[sjena@usernode ~]$ 
---------------------------------

Notice that SGE automatically named the job 'hostname' and created two output files: 'hostname.e4001' and 'hostname.o4001'. The 'e' stands for stderr and the 'o' for stdout. The '4001' at the end of the files’ extension is the job number. So if the job had been named 'extraordinary_job' and was job '#47' submitted, the output files would look like: 'extraordinary_job.e47' 'extraordinary_job.o47'

Deleting a Job
~~~~~~~~~~~~~~
What if a job is stuck in the queue, is taking too long to run, or was simply started with incorrect parameters? You can delete a job from the queue using the 'qdel' command in SGE. Below we launch a simple job 'mpi-ring.qsub', and we can kill it using 'qdel':
--------------------------------------------------
[sjena@usernode mpi]$ qsub -pe orte 24 mpi-ring.qsub
Your job 4009 ("mpi-ring.qsub") has been submitted
--------------------------------------------------


Check the Job status

--------------------------------------------------
[sjena@usernode mpi]$ qstat
job-ID  prior name  user state submit/start at queue      slots      ja-task-ID 
...............................................................................
   4009 0.00000 mpi-ring.q sjena        qw    03/03/2017 11:24:09            24       
--------------------------------------------------

'qw' means Job is in waiting stage. you can an kill it here, but we want job to run
and then kill. Checking again after few second:

--------------------------------------------------
[sjena@usernode mpi]$ qstat
job-ID  prior name  user state submit/start at queue      slots      ja-task-ID 
...............................................................................
   4009 0.55500 mpi-ring.q sjena r 03/03/2017 11:24:17 all.q@compute-0-5.local 24   
--------------------------------------------------

'r' means Job has started. Send a kill signal by 'qdel jobid'   and check the status. 

--------------------------------------------------
[sjena@usernode mpi]$ qdel 4009
sjena has registered the job 4009 for deletion

[sjena@usernode mpi]$ qstat
--------------------------------------------------
After running qdel you’ll notice the job is gone from the queue:
'qstat' returns nothing, i.e. 'qdel' has killed the job.

Monitoring Cluster Usage
~~~~~~~~~~~~~~~~~~~~~~~~

SGE uses 'qstat' to check the job status. I have submitted 10 jobs, which need 
10 core each. I would type 'qstat' and it will show me everything

--------------------------------------------------
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
--------------------------------------------------

You can also view the average load (load_avg) per node using the ‘-f’ option to qstat:
