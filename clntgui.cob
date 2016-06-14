       IDENTIFICATION DIVISION.
       PROGRAM-ID. clntgui.
       AUTHOR. Andrew Notman.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           CRT STATUS IS scr-status.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
           copy "clnt.ws".
           copy screenio.

       01 scr-status      pic 9(4).
       01 temp-clnt-id    pic 9(7) value zeroes.
       01 ws-menu         pic X(80) value spaces.
       01 ws-menu-confirm pic X(40) value spaces.

       01 ws-balance-packed  pic S9(5)V9(2) comp-3 value zeroes.

       01 ws-dob.
           05 ws-dob-year  pic 9(4).
           05 ws-dob-month pic 9(2).
           05 ws-dob-day   pic 9(2).

       01 ws-date-today-gregorian pic 9(8).
       01 ws-date-today-julian    pic 9(6).

       01 ws-navigation-status pic X(2) value "YY".         
           88 next-allowed value "YY", "YN".
           88 prev-allowed value "YY", "NY".

       01 ws-msg pic X(80) value spaces.

       01 ws-input-status pic X(1) value "N".
           88 input-is-valid   value "Y".
           88 input-is-invalid value "N".
           88 input-is-abandon  value "A".

       01 ws-char pic 9(1).
           

       SCREEN SECTION.
       01 scr-clear.
           05 display blank screen.
       
       01 scr-output.
           05 display blank screen.
           05 value "Client Screen" line 01 col 30.
           05 value "ID"         line 05 col 05.
           05 scr-output-id      line 05 col 20 
                                 from ws-clnt-id         
                                 blank when zeroes pic 9(7).
           05 value "Surname"    line 07 col 05.
           05 scr-output-surname line 07 col 20 
                                 from ws-clnt-surname    pic X(10).
           05 value "DoB"        line 09 col 05.
           05 scr-output-dob.
               10 out-dob-day    line 09 col 20
                                 from ws-dob-day
                                 blank when zeros        pic 9(2).
               10 value "/"      line 09 col 22.
               10 out-dob-month  line 09 col 23
                                 from ws-dob-month       
                                 blank when zeroes       pic 9(2).
               10 value "/"      line 09 col 25.
               10 out-dob-year   line 09 col 26
                                 from ws-dob-year
                                 blank when zeroes       pic 9(4).
           05 value "Balance"    line 11 col 05.
           05 scr-output-balance line 11 col 20
                                 from ws-balance-packed
                                 sign leading separate   pic +ZZZZ9.99.
           05 scr-msg            line 16 col 05
                                 from ws-msg             pic X(50).
           05 scr-menu           line 20 col 01 
                                 from ws-menu            pic X(80).

       01 scr-query.
           05 value "Client Screen" line 01 col 30.
           05 value "ID"      line 05 col 05.
           05 scr-query-id    line 05 col 20 
                              to ws-clnt-id         pic 9(7)
                              blank when zeroes.
           05 value "Surname" line 07 col 05.
           05 value "DoB"     line 09 col 05.
           05 value "Balance" line 11 col 05.


       01 scr-input.
           05 value "Client Screen" line 01 col 30.
           05 value "ID"         line 05 col 05.
           05 value "Surname"    line 07 col 05.
           05 scr-input-surname  line 07 col 20 
                                 using ws-clnt-surname pic X(10).
           05 value "DoB"        line 09 col 05.
           05 scr-input-dob.
               10 in-dob-day     line 09 col 20
                                 using ws-dob-day
                                 auto blank when zero  pic 9(2).
               10 value "/"      line 09 col 22.
               10 in-dob-month   line 09 col 23
                                 using ws-dob-month
                                 auto blank when zero  pic 9(2).
               10 value "/"      line 09 col 25.
               10 in-dob-year    line 09 col 26
                                 using ws-dob-year     
                                 blank when zero       pic 9(4).
           05 value "Balance"    line 11 col 05.

       01 scr-menu-confirm from ws-menu-confirm line 20 col 1 pic X(40).


       PROCEDURE DIVISION.
       Main.
           accept ws-date-today-gregorian from date yyyymmdd.
           call 'dates' using "J",
                              ws-date-today-julian,
                              ws-date-today-gregorian.
           perform DoInitialise.
           perform PrintScreenOutput.
           
           perform forever
               accept scr-status
               evaluate scr-status
                   when COB-SCR-F1
                       perform DoQuery
                   when COB-SCR-F2
                       perform DoBrowse
                   when COB-SCR-F3
                       perform DoInsert
                   when COB-SCR-F4
                       perform DoUpdate
                   when COB-SCR-F5
                       perform DoPrevious
                   when COB-SCR-F6
                       perform DoNext
                   when COB-SCR-F9
                       perform DoDelete
                   when COB-SCR-F12
                       exit perform
               end-evaluate
               perform PrintScreenOutput
           end-perform
           stop run.


       PrintScreenOutput.
           move function concatenate("F1=Query F2=Browse ",
                                     "F3=Add F4=Update ", 
                                     "F5=Prev F6=Next ",
                                     "F9=Delete F12=Exit")
               to ws-menu.
           display scr-clear.
           display scr-output.


       DoInitialise.
           call 'clntio' using "F",
                               ws-clnt-record,
                               ws-navigation-status,
                               ws-msg.
           call 'dates' using "G", ws-clnt-dob, ws-dob.

       DoQuery.
           move zeroes to scr-query-id.
           display scr-clear.
           display scr-query.
           accept scr-query-id.
           call 'clntio' using "Q",
                               ws-clnt-record,
                               ws-navigation-status,
                               ws-msg.
           call 'dates' using "G", ws-clnt-dob, ws-dob.

       DoBrowse.
           call 'clntbrws' using ws-clnt-id.
           call 'clntio' using "Q",
                               ws-clnt-record,
                               ws-navigation-status,
                               ws-msg.
           call 'dates' using "G", ws-clnt-dob, ws-dob.

       DoInsert.
           move ws-clnt-id to temp-clnt-id.
           move zeroes to ws-clnt-id.
           move low-values to ws-clnt-surname.
           move zeroes to ws-clnt-dob.
           move zeroes to ws-dob.
           move zeroes to ws-clnt-balance.
           move "Press F12 at any time to abandon" to ws-msg.
           display scr-clear.
           display scr-msg.
           set input-is-invalid to true.
           display scr-input.

           if not input-is-abandon
               set input-is-invalid to true
               perform AcceptSurname until input-is-valid 
                                        or input-is-abandon
           end-if.

           if not input-is-abandon
               set input-is-invalid to true
               perform AcceptDoB until input-is-valid
                                    or input-is-abandon
           end-if.

      *    display confirm message if insert is not abandoned
           if input-is-abandon
               move temp-clnt-id to ws-clnt-id
           else
               set input-is-invalid to true
               move "Create client? F1=Yes F12=No" to ws-menu-confirm
               display scr-menu-confirm 
               perform until input-is-valid
                   accept scr-status
                   evaluate scr-status
                       when COB-SCR-F1
                           call 'clntio' using "I",
                                               ws-clnt-record,
                                               ws-navigation-status,
                                               ws-msg
                           set input-is-valid to true
                       when COB-SCR-F12
                           move temp-clnt-id to ws-clnt-id
                           set input-is-valid to true
                   end-evaluate
               end-perform
           end-if.

           call 'clntio' using "Q",
                               ws-clnt-record,
                               ws-navigation-status,
                               ws-msg.           

       DoUpdate.
           move ws-clnt-id to temp-clnt-id.
           move "Press F12 at any time to abandon" to ws-msg.
           display scr-clear.
           display scr-output-id.
           display scr-output-balance.
           display scr-msg.
           set input-is-invalid to true.
           display scr-input.

           if not input-is-abandon
               set input-is-invalid to true
               perform AcceptSurname until input-is-valid 
                                        or input-is-abandon
           end-if.

           if not input-is-abandon
               set input-is-invalid to true
               perform AcceptDoB until input-is-valid
                                    or input-is-abandon
           end-if.

      *    display confirm if update is not abandoned
           if input-is-abandon
               move temp-clnt-id to ws-clnt-id
           else
               set input-is-invalid to true
               move "Update client? F1=Yes F12=No" to ws-menu-confirm
               display scr-menu-confirm 
               perform until input-is-valid
                   accept scr-status
                   evaluate scr-status
                       when COB-SCR-F1
                           call 'clntio' using "U",
                                               ws-clnt-record,
                                               ws-navigation-status,
                                               ws-msg
                           set input-is-valid to true
                       when COB-SCR-F12
                           move temp-clnt-id to ws-clnt-id
                           set input-is-valid to true
                   end-evaluate
               end-perform
           end-if.

           call 'clntio' using "Q",
                               ws-clnt-record,
                               ws-navigation-status,
                               ws-msg.           
           call 'dates' using "G", ws-clnt-dob, ws-dob.
       
       DoDelete.
           move spaces to ws-menu.
           display scr-menu.
           move spaces to ws-msg.
           move "Delete this record? F1=Yes F12=No" to ws-menu-confirm.
           display scr-menu-confirm.
           set input-is-invalid to true.
           perform until input-is-valid
               accept scr-status
               evaluate scr-status
                   when COB-SCR-F1
                       call 'clntio' using "D",
                                           ws-clnt-record,
                                           ws-navigation-status,
                                           ws-msg
                       set input-is-valid to true
                       move zeroes to ws-clnt-id
                       move spaces to ws-clnt-surname
                       move zeroes to ws-dob
                       move zeroes to ws-balance-packed
                   when COB-SCR-F12
                       set input-is-valid to true
               end-evaluate
           end-perform.

           display ws-msg.

           if ws-clnt-id = zeroes
               display scr-output-id
               display scr-output-surname
               display scr-output-dob
               display scr-output-balance
           end-if.


       DoPrevious.
           move spaces to ws-msg.
           call 'clntio' using "P",
                               ws-clnt-record,
                               ws-navigation-status,
                               ws-msg.
           call 'dates' using "G", ws-clnt-dob, ws-dob.

       DoNext.
           move spaces to ws-msg.
                          call 'clntio' using "N",
                          ws-clnt-record,
                          ws-navigation-status,
                          ws-msg.
           call 'dates' using "G", ws-clnt-dob, ws-dob.

       AcceptSurname.
           accept scr-input-surname
               on exception
                   if scr-status = COB-SCR-F12
                       set input-is-abandon to true
                   end-if
               not on exception
      *    Convert scr-input-surname to all blank spaces to low-value.
                   perform varying ws-char from 1 by 1 until ws-char>5
                       if ws-clnt-surname(ws-char:1) = space
                           move  low-value to ws-clnt-surname(ws-char:1)
                       end-if
                   end-perform 

                   if ws-clnt-surname not equal to low-values
                       set input-is-valid to true
                       move spaces to ws-msg
                       display scr-msg
                   else
                       move "Surname is required" to ws-msg
                       display scr-msg
                   end-if 
           end-accept.



       AcceptDoB.
           accept scr-input-dob
               on exception
                   if scr-status = COB-SCR-F12
                       set input-is-abandon to true
                   end-if
               not on exception
                   call 'dates' using "J", ws-clnt-dob, ws-dob 
      *    if Julian dob date = 0, it is an invalid date
      *    if Julian dob date < 109208 (01/01/1900), client is too old
      *    if Julian dob date > today, client isn't born yet
                   evaluate true
                       when ws-clnt-dob = 0
                       move "Invalid date" to ws-msg
                       display scr-msg
                   when ws-clnt-dob < 109208
                       move "DoB cannot be before 01/01/1900" to ws-msg
                       display scr-msg
                   when ws-clnt-dob > ws-date-today-julian
                       move "DoB cannot be in the future" to ws-msg
                       display scr-msg
                   when other
                       set input-is-valid to true
                       move spaces to ws-msg
                       display scr-msg
                   end-evaluate
           end-accept.
