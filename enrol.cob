       IDENTIFICATION DIVISION.
       PROGRAM-ID. enrol.
       AUTHOR. Andrew Notman.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           select ClientsCSV assign to "clients.csv"
               organization is line sequential.

       DATA DIVISION.
       FILE SECTION.
       FD ClientsCSV.
       01 fd-clients-csv-record pic X(21).
           88 EOF value high-values.

       WORKING-STORAGE SECTION.
           copy "clnt.ws".

       01 ws-clients-csv-record pic X(21).

       01 ws-csv-surname pic X(10).
       01 ws-csv-dob     pic X(10).
       01 ws-dob-gregorian.
           05 ws-dob-year  pic 9(4).
           05 ws-dob-month pic 9(2).
           05 ws-dob-day   pic 9(2).
       01 ws-dob-julian  pic 9(6).

       01 ws-navigation-status pic X(2).
       01 ws-msg               pic X(80).


       PROCEDURE DIVISION.
       Main.
           open input ClientsCSV.
           read ClientsCSV
               at end set EOF to true
           end-read.

           perform until EOF
               move fd-clients-csv-record to ws-clients-csv-record

               unstring ws-clients-csv-record delimited by ";"
                   into ws-csv-surname, ws-csv-dob
                   
               unstring ws-csv-dob delimited by "/"
                   into ws-dob-day, ws-dob-month, ws-dob-year

               call 'dates' using "J", ws-dob-julian, ws-dob-gregorian

               move zeroes to ws-clnt-id
               move ws-csv-surname to ws-clnt-surname
               move ws-dob-julian to ws-clnt-dob
               move zeroes to ws-clnt-balance
               
               call 'clntio' using "I",
                                   ws-clnt-record,
                                   ws-navigation-status,
                                   ws-msg    
               
               read ClientsCSV
                   at end set EOF to true
               end-read
           end-perform.

           close ClientsCSV.

           stop run.
