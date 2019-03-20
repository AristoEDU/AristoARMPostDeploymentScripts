#Load /etc/environment so we have $SPARK_HOME set
source /etc/environment

echo "About to make changes to the logger file"
echo "The spark home about to be set is $SPARK_HOME"

#overwrite the former log4j properties with the new one
sudo sed -i "s/log4jspark.log.dir=.*/log4jspark.log.dir=\/var\/log\/sparkapp\/\${user.name}/g" $SPARK_HOME/conf/log4j.properties
sudo sed -i "s/log4jspark.log.file=.*/log4jspark.log.file=\/var\/log\/sparkapp\/sanity_test/spark.log/g" $SPARK_HOME/conf/log4j.properties
sudo sed -i 's/log4jspark.root.logger=.*/log4jspark.root.logger=INFO,console,DRFA/g' $SPARK_HOME/conf/log4j.properties                                             
sudo sed -i 's/log4j.appender.DRFA.DatePattern=.*/log4j.appender.DRFA.DatePattern=.yyyyMMdd/g' $SPARK_HOME/conf/log4j.properties 
sudo sed -i 's/log4j.appender.DRFA.layout=.*/log4j.appender.DRFA.layout=org.apache.log4j.PatternLayout/g' $SPARK_HOME/conf/log4j.properties
sudo sed -i 's/log4j.appender.DRFA.layout.ConversionPattern=.*/log4j.appender.DRFA.layout.ConversionPattern=%d{yyyyMMddHHmmss}  [%d] %p %m (%c)%n/g' $SPARK_HOME/conf/log4j.properties
sudo sed -i '/log4j.appender.DRFA.encoding=UTF-8/d' $SPARK_HOME/conf/log4j.properties
sudo sed -i -e '$a\' $SPARK_HOME/conf/log4j.properties 
echo 'log4j.appender.DRFA.encoding=UTF-8' >> $SPARK_HOME/conf/log4j.properties
