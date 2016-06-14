       IDENTIFICATION DIVISION.
       PROGRAM-ID. dates IS INITIAL.
       AUTHOR. Andrew Notman.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 gregorian-date pic 9(8) value 16001231.
       01 julian-date    pic 9(6) value 000000.
       01 convert-to     pic X(1) value 'J'.
       
       LINKAGE SECTION.
       01 ls-convert-to pic 9(1).
       01 ls-jul-date   pic 9(6).
       01 ls-greg-date  pic 9(8).

       PROCEDURE DIVISION USING ls-convert-to, 
                                ls-jul-date,
                                ls-greg-date.
           evaluate ls-convert-to
               when 'J'
                   move ls-greg-date to gregorian-date
                   move function integer-of-date(gregorian-date)
                       to julian-date
                   move julian-date to ls-jul-date 
               when 'G'
                   move ls-jul-date to julian-date
                   move function date-of-integer(julian-date)
                       to gregorian-date
                   move gregorian-date to ls-greg-date
           end-evaluate.

           EXIT PROGRAM.
