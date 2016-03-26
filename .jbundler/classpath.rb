require 'jar_dependencies'
JBUNDLER_LOCAL_REPO = Jars.home
JBUNDLER_JRUBY_CLASSPATH = []
JBUNDLER_JRUBY_CLASSPATH.freeze
JBUNDLER_TEST_CLASSPATH = []
JBUNDLER_TEST_CLASSPATH.freeze
JBUNDLER_CLASSPATH = []
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/org/hibernate/hibernate-core/5.1.0.Final/hibernate-core-5.1.0.Final.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/org/apache/geronimo/specs/geronimo-jta_1.1_spec/1.1.1/geronimo-jta_1.1_spec-1.1.1.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/org/javassist/javassist/3.20.0-GA/javassist-3.20.0-GA.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/org/jboss/jandex/2.0.0.Final/jandex-2.0.0.Final.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/org/slf4j/slf4j-api/1.7.19/slf4j-api-1.7.19.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/com/fasterxml/classmate/1.3.0/classmate-1.3.0.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/hsqldb/hsqldb/1.8.0.10/hsqldb-1.8.0.10.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/org/hibernate/common/hibernate-commons-annotations/5.0.1.Final/hibernate-commons-annotations-5.0.1.Final.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/org/hibernate/javax/persistence/hibernate-jpa-2.1-api/1.0.0.Final/hibernate-jpa-2.1-api-1.0.0.Final.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/xml-apis/xml-apis/1.0.b2/xml-apis-1.0.b2.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/antlr/antlr/2.7.7/antlr-2.7.7.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/dom4j/dom4j/1.6.1/dom4j-1.6.1.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/org/jboss/logging/jboss-logging/3.3.0.Final/jboss-logging-3.3.0.Final.jar')
JBUNDLER_CLASSPATH.freeze
