       IDENTIFICATION DIVISION.
       PROGRAM-ID. clntbrws IS INITIAL.
       AUTHOR. Andrew Notman.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           CRT STATUS IS scr-status.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
           copy "clnt.ws".
           copy screenio.

       01 scr-status pic 9(4).
       01 temp-clnt-id pic 9(7) value zeroes.
       01 ws-clients-table.
           05 ws-clients-table-item occurs 10 times.
               10 ws-clients-table-id      pic 9(7).
               10 ws-clients-table-surname pic X(10).

       01 idx pic 9(2).
       01 ws-number-of-rows-filled pic 9(2).

       01 ws-navigation-status pic X(2) value "YY".
           88 next-allowed value "YY", "YN".
           88 prev-allowed value "YY", "NY".

       01 ws-msg pic X(40) values spaces.

       01 ws-top-line    pic 9(2).
       01 ws-bottom-line pic 9(2).
       01 ws-line-cursor pic 9(2).

       01 ws-cursors-table.
           05 ws-cursor occurs 10 times pic X(1) value spaces.

       01 ws-menu pic X(80).

       LINKAGE SECTION.
       01 ls-clnt-id pic 9(7).

       SCREEN SECTION.
       01 scr-clear. 
           05 display blank screen.

       01 scr-output.
           05 value "Client Browser" line 01 col 30.
           05 value "Client ID"      line 04 col 05.
           05 value "Client Surname" line 04 col 15.
           05 scr-clnt-id-1          line 05 col 05
                                     from ws-clients-table-id(1)   
                                     pic 9(7) blank when zeroes.
           05 scr-clnt-surname-1     line 05 col 15
                                     from ws-clients-table-surname(1)
                                     pic X(10).
           05 scr-clnt-id-2          line 06 col 05
                                     from ws-clients-table-id(2)  
                                     pic 9(7) blank when zeroes.
           05 scr-clnt-surname-2     line 06 col 15
                                     from ws-clients-table-surname(2)
                                     pic X(10).
           05 scr-clnt-id-3          line 07 col 05
                                     from ws-clients-table-id(3)  
                                     pic 9(7) blank when zeroes.
           05 scr-clnt-surname-3     line 07 col 15
                                     from ws-clients-table-surname(3)
                                     pic X(10).
           05 scr-clnt-id-4          line 08 col 05
                                     from ws-clients-table-id(4)  
                                     pic 9(7) blank when zeroes.
           05 scr-clnt-surname-4     line 08 col 15
                                     from ws-clients-table-surname(4)
                                     pic X(10).
           05 scr-clnt-id-5          line 09 col 05
                                     from ws-clients-table-id(5)  
                                     pic 9(7) blank when zeroes.
           05 scr-clnt-surname-5     line 09 col 15
                                     from ws-clients-table-surname(5)
                                     pic X(10).
           05 scr-clnt-id-6          line 10 col 05
                                     from ws-clients-table-id(6)  
                                     pic 9(7) blank when zeroes.
           05 scr-clnt-surname-6     line 10 col 15
                                     from ws-clients-table-surname(6)
                                     pic X(10).
           05 scr-clnt-id-7          line 11 col 05
                                     from ws-clients-table-id(7)  
                                     pic 9(7) blank when zeroes.
           05 scr-clnt-surname-7     line 11 col 15
                                     from ws-clients-table-surname(7)
                                     pic X(10).
           05 scr-clnt-id-8          line 12 col 05
                                     from ws-clients-table-id(8)  
                                     pic 9(7) blank when zeroes.
           05 scr-clnt-surname-8     line 12 col 15
                                     from ws-clients-table-surname(8)
                                     pic X(10).
           05 scr-clnt-id-9          line 13 col 05
                                     from ws-clients-table-id(9)  
                                     pic 9(7) blank when zeroes.
           05 scr-clnt-surname-9     line 13 col 15
                                     from ws-clients-table-surname(9)
                                     pic X(10).
           05 scr-clnt-id-10         line 14 col 05
                                     from ws-clients-table-id(10)  
                                     pic 9(7) blank when zeroes.
           05 scr-clnt-surname-10    line 14 col 15
                                     from ws-clients-table-surname(10)
                                     pic X(10).
           05 scr-menu               line 20 col 05
                                     from ws-menu
                                     pic X(80).

       01 scr-query.
           05 value "Enter a client number: " line 15 col 05.
           05 scr-query-id to ws-clnt-id      line 15 col 29 pic 9(7)
                                              blank when zeroes.

       01 scr-cursor.
           05 scr-cursor-1  from ws-cursor(1)  line 05 col 03 pic X(1).
           05 scr-cursor-2  from ws-cursor(2)  line 06 col 03 pic X(1).
           05 scr-cursor-3  from ws-cursor(3)  line 07 col 03 pic X(1).
           05 scr-cursor-4  from ws-cursor(4)  line 08 col 03 pic X(1).
           05 scr-cursor-5  from ws-cursor(5)  line 09 col 03 pic X(1).
           05 scr-cursor-6  from ws-cursor(6)  line 10 col 03 pic X(1).
           05 scr-cursor-7  from ws-cursor(7)  line 11 col 03 pic X(1).
           05 src-cursor-8  from ws-cursor(8)  line 12 col 03 pic X(1).
           05 scr-cursor-9  from ws-cursor(9)  line 13 col 03 pic X(1).
           05 scr-cursor-10 from ws-cursor(10) line 14 col 03 pic X(1).
       

       PROCEDURE DIVISION using ls-clnt-id.
       Main.
           perform DoFirst.
           move function concatenate("F1=Query ",
                                     "F3=First F4=Last ",
                                     "F5=Next F6=Prev F7=Down F8=Up "
                                     "F9=Select F12=Exit")
               to ws-menu.

           perform forever
               display scr-clear
               move spaces to ws-cursors-table
               display scr-output
               if ws-number-of-rows-filled > 0
                   move "*" to ws-cursor(ws-line-cursor)
               end-if
               display scr-cursor
               accept scr-status
               evaluate scr-status
                   when COB-SCR-F1
                       perform DoQuery
                   when COB-SCR-F3
                       perform DoFirst
                   when COB-SCR-F4
                       perform DoLast
                   when COB-SCR-F5
                       perform DoPrevious
                   when COB-SCR-F6
                       perform DoNext
                   when COB-SCR-F7
                       if ws-number-of-rows-filled > 0
                           if ws-line-cursor < ws-bottom-line
                               add 1 to ws-line-cursor
                           end-if
                       end-if
                   when COB-SCR-F8
                       if ws-number-of-rows-filled > 0
                           if ws-line-cursor > ws-top-line
                               subtract 1 from ws-line-cursor
                           end-if
                       end-if
                   when COB-SCR-F9
                       if ws-number-of-rows-filled <> 0
                           perform DoSelect
                           exit perform
                       end-if
                   when COB-SCR-F12
                       move zeroes to ls-clnt-id
                       exit perform
               end-evaluate
           end-perform.
           
           EXIT PROGRAM.

       PopulateClientsTable.
           move zeroes to ws-number-of-rows-filled.
           move zeroes to ws-top-line.
           move zeroes to ws-bottom-line.
           move zeroes to ws-line-cursor.
           perform varying idx from 1 by 1 until idx > 10
               move zeroes to ws-clients-table-id(idx)
               move spaces to ws-clients-table-surname(idx)
               call 'clntio' using "N", 
                                   ws-clnt-record,
                                   ws-navigation-status,
                                   ws-msg 
               if next-allowed
                   move ws-clnt-id to ws-clients-table-id(idx)
                   move ws-clnt-surname to ws-clients-table-surname(idx)
                   add 1 to ws-number-of-rows-filled
               end-if
           end-perform.
           if ws-number-of-rows-filled > 0
               move 1 to ws-top-line
               move ws-number-of-rows-filled to ws-bottom-line
               move 1 to ws-line-cursor
           end-if.

       DoQuery.
           move high-values to ws-clnt-id.
           display scr-query.
           accept scr-query-id.
           if ws-clnt-id not zeroes
               subtract 1 from ws-clnt-id
           end-if.
           perform PopulateClientsTable.

       DoFirst.
           move zeroes to ws-clnt-id.
           perform PopulateClientsTable.

       DoLast.
           move high-values to ws-clients-table-id(1).
           perform DoPrevious.

       DoNext.
           if ws-number-of-rows-filled = 10
               move ws-clients-table-id(10) to ws-clnt-id
               perform PopulateClientsTable
           end-if.

       DoPrevious.
           if ws-number-of-rows-filled <> 0
               move ws-clients-table-id(1) to ws-clnt-id
               perform 10 times
                   call 'clntio' using "P",
                                       ws-clnt-record,
                                       ws-navigation-status,
                                       ws-msg
               end-perform

      * The following if statement is to prevent the shifting up
      * of clients when the user presses on the Prev button.
      * For example, if client 11 was at the top of the page, the loop
      * will finish reading at client 1. When the PopulateClientsTable
      * routine is called, it'll start the index value at 1 and read
      * the next client number (i.e. client 2) into the first line
      * rather than client 1 
               if prev-allowed
                   call 'clntio' using 'P',
                                       ws-clnt-record,
                                       ws-navigation-status,
                                       ws-msg
                   if not prev-allowed
                       move zeroes to ws-clnt-id
                   end-if
               else
                   move zeroes to ws-clnt-id
               end-if
               perform PopulateClientsTable
           end-if.

       DoSelect.
           move ws-clients-table-id(ws-line-cursor) to ls-clnt-id.
