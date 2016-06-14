       IDENTIFICATION DIVISION.
       PROGRAM-ID. dropclnt.
       AUTHOR. Andrew Notman.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           select ContinueFile assign to "cont.dat"
               organization is indexed
               access mode is dynamic
               record key is fd-cont-id
               file status is cont-file-status.

           select ClientFile assign to "clnt.dat"
               organization is indexed
               access mode is dynamic
               record key is fd-clnt-id
               alternate record key is fd-clnt-surname with duplicates
               file status is clnt-file-status.

       DATA DIVISION.
       FILE SECTION.
       FD ContinueFile.
           copy "cont.fd".

       FD ClientFile.
           copy "clnt.fd".

       WORKING-STORAGE SECTION.

       01 cont-file-status pic X(2).
           88 cont-success value "00".

       01 clnt-file-status pic X(2).
           88 clnt-success value "00".


       PROCEDURE DIVISION.
       Main.
           open output ContinueFile.
           close ContinueFile.
           open output ClientFile.
           close ClientFile.
           call 'contio' using "A",0000000,cont-file-status.
           if cont-success
               display "cont file updated successfully"
           else
               display "cont file error: ", clnt-file-status
           end-if.

           stop run.
