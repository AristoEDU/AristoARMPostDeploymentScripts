#!/bin/bash
#Load /etc/environment so we have $SPARK_HOME set
source /etc/environment

TIMESTAMP=$(date "+%Y%m%d")

if [ -f "$SPARK_HOME/conf/log4j.properties" ]; then
   sudo mv $SPARK_HOME/conf/log4j.properties $SPARK_HOME/conf/log4j.properties_${TIMESTAMP}
fi

cat > $SPARK_HOME/conf/log4j.properties << EOF
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#


# Define some default values that can be overridden by system properties
log4jspark.root.logger=INFO,console,DRFA
log4jspark.log.dir=/var/log/sparkapp/\${user.name}
log4jspark.log.file=spark_\${jobName}.log
log4jspark.log.maxfilesize=1024MB
log4jspark.log.maxbackupindex=10

# Define the root logger to the system property "spark.root.logger".
log4j.rootLogger=\${log4jspark.root.logger}, EventCounter

# Set everything to be logged to the console
log4j.appender.console=org.apache.log4j.ConsoleAppender
log4j.appender.console.target=System.err
log4j.appender.console.layout=org.apache.log4j.PatternLayout
log4j.appender.console.layout.ConversionPattern=%d{yy/MM/dd HH:mm:ss} %p %c{1}: %m%n
log4j.appender.console.Threshold=INFO

# Settings to quiet third party logs that are too verbose
log4j.logger.org.eclipse.jetty=WARN
log4j.logger.org.eclipse.jetty.util.component.AbstractLifeCycle=ERROR
log4j.logger.org.apache.spark.repl.SparkIMain\$exprTyper=INFO
log4j.logger.org.apache.spark.repl.SparkILoop\$SparkILoopInterpreter=INFO

#
# Event Counter Appender
# Sends counts of logging messages at different severity levels to Hadoop Metrics.
#
log4j.appender.EventCounter=org.apache.hadoop.log.metrics.EventCounter
 
#
# Daily Rolling File Appender
#
log4j.appender.DRFA=org.apache.log4j.DailyRollingFileAppender
log4j.appender.DRFA.File=\${log4jspark.log.dir}/\${log4jspark.log.file}
# Rollver at midnight
log4j.appender.DRFA.DatePattern=.yyyy-MM-dd
log4j.appender.DRFA.layout=org.apache.log4j.PatternLayout
# Pattern format: Date LogLevel LoggerName LogMessage
###log4j.appender.DRFA.layout.ConversionPattern=%d{ISO8601} %p %c: %m%n
log4j.appender.DRFA.layout.ConversionPattern=%d{yyyyMMddHHmmss}  [%d] %p %m (%c)%n
log4j.appender.DRFA.encoding=UTF-8

# Rolling File Appender
log4j.appender.RFA=org.apache.log4j.RollingFileAppender
log4j.appender.RFA.File=\${log4jspark.log.dir}/\${log4jspark.log.file}
log4j.appender.RFA.MaxFileSize=\${log4jspark.log.maxfilesize}
log4j.appender.RFA.MaxBackupIndex=\${log4jspark.log.maxbackupindex}
log4j.appender.RFA.layout=org.apache.log4j.PatternLayout
log4j.appender.RFA.layout.ConversionPattern=%d{ISO8601} %-5p [%t] %c{2}: %m%n

#EtwLog Appender
#sends Spark logs to customer storage account
log4j.appender.ETW=com.microsoft.log4jappender.EtwAppender
log4j.appender.ETW.source=HadoopServiceLog
log4j.appender.ETW.component=\${etwlogger.component}
log4j.appender.ETW.layout=org.apache.log4j.TTCCLayout
log4j.appender.ETW.OSType=Linux

# Anonymize Appender
# Sends anonymized HDP service logs to our storage account
log4j.appender.Anonymizer.patternGroupResource=\${patternGroup.filename}
log4j.appender.Anonymizer=com.microsoft.log4jappender.AnonymizeLogAppender
log4j.appender.Anonymizer.component=\${etwlogger.component}
log4j.appender.Anonymizer.layout=org.apache.log4j.TTCCLayout
log4j.appender.Anonymizer.Threshold=DEBUG
log4j.appender.Anonymizer.logFilterResource=\${logFilter.filename}
log4j.appender.Anonymizer.source=CentralAnonymizedLogs
log4j.appender.Anonymizer.OSType=Linux
EOF

if [ ! -d "/var/log/sparkapp/$SSH_USERNAME" ]; then 
  sudo mkdir /var/log/sparkapp/$SSH_USERNAME
  sudo chmod 777 /var/log/sparkapp/$SSH_USERNAME/
fi
