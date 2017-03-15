# PuppetResources #

This repository is a collection of custom-made Puppet resources I use.  

##  Manifests  ##

These are actual Puppet code files (.pp).  These are typically moved to your code repository in your manifests folder.  In many of my manifests, I specify a subfolder that becomes part of the namespace of the class.  For instance:

    class sqlserver::sql_agent_job()

This file is located in a subfolder called "sqlserver" under your manifests folder.  If you store it in a different folder structure, you will have to adjust the class name.

##  Templates ##

These are the Puppet template files (.epp) files I reference.  These go in a subfolder called "templates" in your repository folder.  This is usually at the same level in the directory structure as the "manifests" folder.  

In my repository, I store the templates in a descriptive subfolder (e.g. "sqlserver") for organizational purposes.  If you change this, then don't forget to also adjust the path to the template in the epp() function call in the .pp file that calls it.  

For example, sql-agent_job.epp is called from sql_agent_job.pp here:

    sqlserver_tsql { "${title}_${sqlInstanceName}_sql_agent_job" : 
      instance    => $sqlInstanceName,
      command     => epp("sqlserver/sql_add_job.epp", { 
                        name            => $name, 
                        description     => $description,
                        notifyOperator  => $notifyOperator,
                        steps           => $steps,
                        schedules       => $schedules
                      }),

If you stored the .epp file directly in the root templates folder, you'd have to change your code to reflect that:

    sqlserver_tsql { "${title}_${sqlInstanceName}_sql_agent_job" : 
      instance    => $sqlInstanceName,
      command     => epp("sql_add_job.epp", { 
                        name            => $name, 
                        description     => $description,
                        notifyOperator  => $notifyOperator,
                        steps           => $steps,
                        schedules       => $schedules
                      }),

See Puppet's documentation here for more details:  https://docs.puppet.com/puppet/4.9/lang_template.html
