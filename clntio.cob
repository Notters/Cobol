000000 IDENTIFICATION DIVISION.
       PROGRAM-ID. clntio IS INITIAL.
       AUTHOR. Andrew Notman.
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           select ClientFile assign to "clnt.dat"
               organization is indexed
               access mode is dynamic
               record key is fd-clnt-id
               alternate record key is fd-clnt-surname with duplicates
               file status is file-status.


       DATA DIVISION.
       FILE SECTION.
       FD ClientFile.
           copy "clnt.fd".

       WORKING-STORAGE SECTION.
           copy "clnt.ws".

       01 ws-operation       pic X(1).      

       01 file-status pic X(2).
               88 success value "00".

       01 ws-navigation-status.
           02 next-allowed pic X(1).
           02 prev-allowed pic X(1).

       01 ws-next-clnt-id    pic 9(7).

       01 ws-msg pic X(80) value spaces.


       LINKAGE SECTION.
       01 ls-operation          pic X(1).
       01 ls-clnt-record        pic X(31).
       01 ls-navigation-status  pic X(2).
       01 ls-msg                pic X(80).

       PROCEDURE DIVISION USING ls-operation,
                                ls-clnt-record,
                                ls-navigation-status,
                                ls-msg.

       Main.
           open i-o ClientFile.
           move ls-operation to ws-operation.
           evaluate ws-operation
               when "Q" perform DoQuery                   
               when "I" perform DoInsert
               when "U" perform DoUpdate
               when "D" perform DoDelete
               when "F" perform DoFirst
               when "N" perform DoNext
               when "P" perform DoPrevious
               when "L" perform DoLast
               when other
                   move "Invalid operation" to ws-msg 
                   move ws-msg to ls-msg
           end-evaluate.
           close ClientFile.

           EXIT PROGRAM.

       DoQuery.
           move ls-clnt-record to ws-clnt-record.
           move ws-clnt-id to fd-clnt-id.
           read ClientFile
               key is fd-clnt-id
           end-read.

           if success
               move fd-clnt-record to ws-clnt-record
           else
               move "Client not found" to ws-msg 
           end-if.

           move ws-clnt-record to ls-clnt-record.
           move ws-msg to ls-msg.
                   

       DoInsert.
           move 9999999 to ws-next-clnt-id.
           move "99" to file-status.
           call 'contio' using "R", ws-next-clnt-id, file-status. 
           if success
               move ls-clnt-record to ws-clnt-record
               move ws-next-clnt-id to ws-clnt-id 
               move ws-clnt-record   to fd-clnt-record

               write fd-clnt-record
                   invalid key
                       move "Failed to add client." 
                            to ws-msg
                   not invalid key 
                       move "Client added successfully: " to ws-msg
                       move ws-next-clnt-id to ws-msg(27:)
               end-write
               
               move high-values to file-status
               call 'contio' using "I", 0000000, file-status
               if not success
                   move ". Failed to update cont." 
                       to ws-msg(35:)
               end-if

               move ws-clnt-record to ls-clnt-record
               move ws-msg to ls-msg 
           end-if.


       DoUpdate.
           move ls-clnt-record to ws-clnt-record. 

           move ws-clnt-id to fd-clnt-id.
           read ClientFile
               key is fd-clnt-id
               invalid key
                   move "Client not found" to ws-msg
           end-read.

           move ws-clnt-surname to fd-clnt-surname.
           move ws-clnt-dob     to fd-clnt-dob.
           rewrite fd-clnt-record
           end-rewrite.

           if success
               move "Client updated successfully" to ws-msg
           else
               move "Failed to update cient." to ws-msg
           end-if.

           move ws-msg to ls-msg.


       DoDelete.
           move ls-clnt-record(1:7) to fd-clnt-id.

           delete ClientFile record
               invalid key 
                   move "Client does not exist" to ws-msg
               not invalid key
                   move "Record deleted" to ws-msg
           end-delete.

           move ws-msg to ls-msg.

       DoFirst.
           move zeroes to fd-clnt-id.
           start ClientFile key is greater than fd-clnt-id
               invalid key 
                   move "No client records found" to ws-msg 
                   move "N" to next-allowed
               not invalid key
                   move "Y" to next-allowed
           end-start.

           if next-allowed = "Y"
               read ClientFile next record
               end-read

               if success
                   move fd-clnt-record to ls-clnt-record
               end-if
           end-if

           move ws-navigation-status to ls-navigation-status
           move ws-msg to ls-msg.

       DoNext.
           move ls-clnt-record to ws-clnt-record.
           move ws-clnt-id to fd-clnt-id.
           move ls-navigation-status to ws-navigation-status.
           start ClientFile key is greater than fd-clnt-id
               invalid key 
                   move "End of client file" to ws-msg
                   move "N" to next-allowed
               not invalid key
                   move "Y" to next-allowed
           end-start.

           if next-allowed = "Y"     
               read ClientFile next record
                   at end
                       move "N" to next-allowed 
               end-read 
     
               if success
                   move fd-clnt-record to ws-clnt-record
               end-if 
           end-if.

           move ws-clnt-record to ls-clnt-record.
           move ws-navigation-status to ls-navigation-status.
           move ws-msg to ls-msg.


       DoPrevious.
           move ls-clnt-record to ws-clnt-record.
           move ws-clnt-id to fd-clnt-id.
           move ls-navigation-status to ws-navigation-status.
           start ClientFile key is less than fd-clnt-id
               invalid key 
                   move "Start of client file" to ws-msg
                   move "N" to prev-allowed
               not invalid key
                   move "Y" to prev-allowed
           end-start.

           if prev-allowed = "Y"
               read ClientFile previous record
               end-read

               if success
                   move fd-clnt-record to ws-clnt-record
               end-if

           end-if.

           move ws-clnt-record to ls-clnt-record.
           move ws-navigation-status to ls-navigation-status.
           move ws-msg to ls-msg.


       DoLast.
           move high-values to fd-clnt-id.
           start ClientFile key is less than fd-clnt-id
               invalid key 
                   move "No Records to be displayed" to ws-msg
           end-start.

           read ClientFile previous record
           end-read.

           if success
               move fd-clnt-id      to ws-clnt-id
               move fd-clnt-surname to ws-clnt-surname
               move fd-clnt-dob     to ws-clnt-dob
               move fd-clnt-balance to ws-clnt-balance
               move ws-clnt-record to ls-clnt-record
           end-if.

           move ws-msg to ls-msg.

                          




