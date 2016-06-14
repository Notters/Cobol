       IDENTIFICATION DIVISION.
       PROGRAM-ID. contio IS INITIAL.
       AUTHOR. Andrew Notman.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           select ContinueFile assign to "cont.dat"
               organization is indexed
               access mode is dynamic
               record key is fd-cont-id
               file status is file-status.

       DATA DIVISION.
       FILE SECTION.
       FD ContinueFile.
           copy "cont.fd".

       WORKING-STORAGE SECTION.
           copy "cont.ws".

       01 file-status pic X(2).
           88 success value "00".


       LINKAGE SECTION.
       01 ls-operation      pic X(1).
       01 ls-next-clnt-id   pic 9(7).
       01 ls-file-status    pic 9(2).

       PROCEDURE DIVISION USING ls-operation, 
                                ls-next-clnt-id,
                                ls-file-status.
           open i-o ContinueFile.
           evaluate ls-operation
               when "R" perform DoRetrieve
               when "I" perform DoIncrement
               when "A" perform DoAdd
               when "U" perform DoUpdate
               when other display "Invalid char."
           end-evaluate.

           close ContinueFile.
           EXIT PROGRAM.

       DoRetrieve.
           move 1 to fd-cont-id.
           read ContinueFile record
               key is fd-cont-id
           end-read.
           move fd-cont-next-clnt-id to ls-next-clnt-id.
           move file-status to ls-file-status.

       DoAdd.
           move 1 to fd-cont-id.
           move 1 to fd-cont-next-clnt-id.
           write fd-cont-record
           end-write.
           move file-status to ls-file-status.

       DoIncrement.
           move 1 to fd-cont-id.
           read ContinueFile
               key is fd-cont-id
           end-read.

           move fd-cont-next-clnt-id to ws-cont-next-clnt-id.
           add 1 to ws-cont-next-clnt-id.
           move ws-cont-next-clnt-id to fd-cont-next-clnt-id.
           rewrite fd-cont-record
           end-rewrite.

           move file-status to ls-file-status.

       DoUpdate.
           move 1 to fd-cont-id.
           read ContinueFile
               key is fd-cont-id
           end-read.

           move ls-next-clnt-id to fd-cont-next-clnt-id.
           rewrite fd-cont-record
           end-rewrite.

           move file-status to ls-file-status.
