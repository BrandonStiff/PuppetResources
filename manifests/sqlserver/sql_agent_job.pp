class sqlserver::sql_agent_job()
{

  define sql_agent_job
  (
    String $sqlInstanceName,
    String $description,
    String $notifyOperator,
    Array[Hash] $steps,
    Any $schedules = undef
  )
  {
    #  This class adds a SQL Agent job to the SQL server.

    #  PARAMETERS:
    # name                          => (namevar) Specifies the name of the agent job.   - https://msdn.microsoft.com/en-us/library/ms182079.aspx
    # sqlInstanceName               => Specifies the SQL Server instance.
    # description                   => Specifies the description on the job.
    # notifyOperator                => Specifies the name of the job operator to notify.
    # steps                         => An array of hashes specifying the job steps:
    #   name                          => String - The name of the job step
    #   command                       => String - The T-SQL to execute
    #   database                      => String - The name of the database to execute against if the subsystem is TSQL.
    #   onSuccess                     => Integer - 3(next)|2(quitfail)|1(quitsuccess)|4(gotostep), default is 1 
    #   onFail                        => Integer - 3(next)|2(quitfail)|1(quitsuccess)|4(gotostep), default is 2
    #   onSuccessStepId               => Integer - The stepid to go to on success
    #   onFailStepId                  => Integer - The stepid to to go in failure
    #   subsystem                     => String - Specify either "TSQL" or "CmdExec".  Default is TSQL.
    #   outputFileName                => String - Specify the path to the file to write the output to.
    # schedules                     => (optional) A hash specifying a job schedule.     - https://msdn.microsoft.com/en-us/library/ms366342.aspx
    #   frequencyType                 => Integer - 1(once)|4(daily)|8(weekly)|16(monthly), default 4
    #   frequencyInterval             => Integer - (once) - not used | (daily) - every frequencyInterval days | (weekly) - frequencyinterval determines day of wek | (monthly) - determines day of the month
    #   frequencySubdayType           => Integer - 1(attime)|4(minutes)|8(hours), default 1
    #   frequencySubdayInterval       => Integer - number of minutes/hours
    #   frequencyRecurrenceFactor     => Integer - Number of weeks/months between exectutions.  Nonzero value required if frequencytype is 8|16|32 (not used otherwise).  Default is 0.
    #   activeStartTime               => "HHMMSS, default 0", 
    #   activeEndTime                 => "HHMMSS, default 235959"   

    sqlserver_tsql { "${title}_${sqlInstanceName}_sql_agent_job" : 
      instance    => $sqlInstanceName,
      command     => epp("sqlserver/sql_add_job.epp", { 
                        name            => $name, 
                        description     => $description,
                        notifyOperator  => $notifyOperator,
                        steps           => $steps,
                        schedules       => $schedules
                      }),
      onlyif      => "IF NOT EXISTS ( SELECT * FROM msdb.dbo.sysjobs WHERE name = '${name}' ) BEGIN
                        THROW 51000, '${name} job not present.', 10;
                    END;"
    } 
  }
}
