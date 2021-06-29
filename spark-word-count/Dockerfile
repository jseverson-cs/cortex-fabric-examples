FROM c12e/spark-base:<TAG>

USER root

COPY src/ src/
COPY target/*.jar target/
COPY submit-spark-job.sh submit-spark-job.sh

RUN apt-get update -y && apt-get install -y wget
RUN wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/2.7.0/hadoop-aws-2.7.0.jar -P ${SPARK_HOME}/jars/ \
&& wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk/1.7.4/aws-java-sdk-1.7.4.jar -P ${SPARK_HOME}/jars/ \
&& wget https://repo1.maven.org/maven2/com/googlecode/json-simple/json-simple/1.1/json-simple-1.1.jar -P ${SPARK_HOME}/jars/

CMD ["sh", "submit-spark-job.sh"]

USER ${spark_uid}
