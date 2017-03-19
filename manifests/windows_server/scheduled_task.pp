class profile::windows_server::scheduled_task()
{
  
  define windows_scheduled_task
  (
    String $description = "No description.",
    String $path = "",
    String $executionTimeLimit = "01.00:00:00",
    String $userName = "NT AUTHORITY\\SYSTEM",
    String $password = "",
    Boolean $deployEnabled = true,
    Array[Hash] $actions,
    Array[Hash] $triggers = []
  )
  {
    #  name (string)                - Specifies the name of the task
    #  description (string)         - Specifies a description of the task
    #  path (string)                - Specifies the folder to place the task in.  Default is "\" (the root folder).  NOTE:  This must begin with a slash but not end with one!  Example:  /Restore
    #  executionTimeLimit (string)  - Specifies the length of time the task can run before being automatically stopped.  Specify as a TimeSpan.
    #  deployEnabled (bool)         - Determines whether the task should deployed in an enabled state or not.  This state is not enforced going forward.
    #  actions (Hash[]) -
    #    workingDirectory (string)      - Specifies the working directory for the action.  Default is C:\windows\system32
    #    command (string)               - Specifies the command to execute.
    #    arguments (string[])           - Specifies the arguments to pass to the command.
    #    isPowerShell (bool)            - If specified, then the command and arguments are automatically constructed.  You only need pass the powershell script you want to run for the command.

    #  triggers (Hash[]) -
    #    atDateTime (String)          - Specifies the date and time to start running the task.
    #    repetitionInterval (string)  - Specifies how often to re-run the task after the atDateTime occurs.  Specify as a Timespan.
    #    repetitionDuration (string)  - Specifies how long to repeat the task executions for.  Specify as a Timespan.  Default is [Timespan]::MaxValue (forever)

    #  If your command is a PowerShell script, you have to escape double-quotes with backslashes. 
    #  Example:
    #  profile::windows_server::scheduled_task::windows_scheduled_task { 'Test Scheduled Task':
    #   userName          =>  $taskCredentials['userName'],
    #   password          =>  $taskCredentials['password'],
    #   path              => '\MyTasks',
    #   actions           => [{
    #    isPowerShell        => true,
    #    command             => "c:\\scripts\\Run-MyPowerShellScript.ps1 -Param1 value1 -Param2 \"value 2\" -Param3 ${puppetVariableHere}  "
    #   }],
    #   triggers              => [{
    #    atDateTime          => "9/1/2016 12:30 AM",
    #    repetitionInterval  => "00:30:00"
    #   }],
    #}

    exec { "scheduled_task_${title}" :
      command       => epp("profile/windows/scheduled_task_add.epp", {
                        name                => $name,
                        description         => $description,
                        path                => $path,
                        executionTimeLimit  => $executionTimeLimit,
                        userName            => $userName,
                        password            => $password,
                        deployEnabled       => $deployEnabled,
                        actions             => $actions,
                        triggers            => $triggers
                      }),
      onlyif        => "if ( ScheduledTasks\\Get-ScheduledTask | Where-Object { \$_.TaskName -ieq \"${name}\" -and \$_.TaskPath -ieq \"${path}\\\" } ) { \$host.SetShouldExit(99); exit 99 }",
      returns       => [0],
      provider      => powershell,
      logoutput     => true,
    }
  }
}