@echo off
java -classpath ../_schemacrawler/lib/*;lib/* schemacrawler.tools.hsqldb.Main -server=hsqldb -server=hsqldb -database=schemacrawler -user=sa -password= %*