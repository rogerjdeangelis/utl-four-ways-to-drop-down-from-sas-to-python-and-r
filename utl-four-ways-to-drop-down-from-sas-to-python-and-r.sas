%let pgm=utl-four-ways-to-drop-down-from-sas-to-python-and-r;

  Four ways to drop down from sas to python and r

  github
  https://tinyurl.com/2p9b2svx
  https://github.com/rogerjdeangelis/utl-four-ways-to-drop-down-from-sas-to-python-and-r

  Four ways to drop down from sas to python and r

         1. Drop down to python using parmcards4 (require c:/temp not very elegant)
            (handles quating and semi-colons more directly)

         2. Drop down to python using 32k string with python program

         3. Drop down to R using parmcards4 (require c:/temp not very elegant)
            (handles quating and semi-colons more directly)

         4. Drop down to R using 32k string with python program


 Macros on end of this message

/*                               _
 _ __  _   _    ___ __ _ _ __ __| |___   _ __   __ _ _ __ ___
| `_ \| | | |  / __/ _` | `__/ _` / __| | `_ \ / _` | `_ ` _ \
| |_) | |_| | | (_| (_| | | | (_| \__ \ | |_) | (_| | | | | | |
| .__/ \__, |  \___\__,_|_|  \__,_|___/ | .__/ \__, |_| |_| |_|
|_|    |___/                            |_|    |___/
*/

* simple py program;

%utl_pybegin39;
parcards4;
print("Hello World")
;;;;
%utl_pyend39;

* SAS Output Window

 Hello World

/*             _________  _
 _ __  _   _  |___ /___ \| | __  _ __   __ _ _ __ ___
| `_ \| | | |   |_ \ __) | |/ / | `_ \ / _` | `_ ` _ \
| |_) | |_| |  ___) / __/|   <  | |_) | (_| | | | | | |
| .__/ \__, | |____/_____|_|\_\ | .__/ \__, |_| |_| |_|
|_|    |___/                    |_|    |___/
*/

%utl_submit_py64_39('
 print("Hellow World");
 ');

* SAS Output Window

 Hello World

/*                        _
 _ __    ___ __ _ _ __ __| |___   _ __   __ _ _ __ ___
| `__|  / __/ _` | `__/ _` / __| | `_ \ / _` | `_ ` _ \
| |    | (_| (_| | | | (_| \__ \ | |_) | (_| | | | | | |
|_|     \___\__,_|_|  \__,_|___/ | .__/ \__, |_| |_| |_|
                                 |_|    |___/
*/

%utl_rbegin;
parmcards4;
print("Hello World")
;;;;
%utl_rend;

* SAS Output Window

> print("Hello World")
[1] "Hello World"
>

/*      _________  _
 _ __  |___ /___ \| | __  _ __   __ _ _ __ ___
| `__|   |_ \ __) | |/ / | `_ \ / _` | `_ ` _ \
| |     ___) / __/|   <  | |_) | (_| | | | | | |
|_|    |____/_____|_|\_\ | .__/ \__, |_| |_| |_|
                         |_|    |___/
*/

%utl_submit_r64('
print("Hello World")
');

* SAS Output Window

> print("Hello World")
[1] "Hello World"
>

/*_  __    _    ____ ____   ___  ____
|  \/  |  / \  / ___|  _ \ / _ \/ ___|
| |\/| | / _ \| |   | |_) | | | \___ \
| |  | |/ ___ \ |___|  _ <| |_| |___) |
|_|  |_/_/   \_\____|_| \_\\___/|____/
     _                       _                                                       _     _  _
  __| |_ __ ___  _ __     __| | _____      ___ __    _ __  _   _    ___ __ _ _ __ __| |___| || |
 / _` | `__/ _ \| `_ \   / _` |/ _ \ \ /\ / / `_ \  | `_ \| | | |  / __/ _` | `__/ _` / __| || |_
| (_| | | | (_) | |_) | | (_| | (_) \ V  V /| | | | | |_) | |_| | | (_| (_| | | | (_| \__ \__   _|
 \__,_|_|  \___/| .__/   \__,_|\___/ \_/\_/ |_| |_| | .__/ \__, |  \___\__,_|_|  \__,_|___/  |_|
                |_|                                 |_|    |___/
*/

%macro utl_pybegin39;

%utlfkil(c:/temp/py_pgm.py);
%utlfkil(c:/temp/py_pgm.log);
filename ft15f001 "c:/temp/py_pgm.py";

%mend utl_pybegin39;


%macro utl_pyend39;
run;quit;

* EXECUTE THE PYTHON PROGRAM;
options noxwait noxsync;
filename rut pipe  "c:\Python39\python.exe c:/temp/py_pgm.py 2> c:/temp/py_pgm.log";
run;quit;

data _null_;
  file print;
  infile rut;
  input;
  put _infile_;
  putlog _infile_;
run;quit;

data _null_;
  infile " c:/temp/py_pgm.log";
  input;
  putlog _infile_;
run;quit;

%mend utl_pyend39;

/*   _                       _                                     _________  _
  __| |_ __ ___  _ __     __| | _____      ___ __    _ __  _   _  |___ /___ \| | __
 / _` | `__/ _ \| `_ \   / _` |/ _ \ \ /\ / / `_ \  | `_ \| | | |   |_ \ __) | |/ /
| (_| | | | (_) | |_) | | (_| | (_) \ V  V /| | | | | |_) | |_| |  ___) / __/|   <
 \__,_|_|  \___/| .__/   \__,_|\___/ \_/\_/ |_| |_| | .__/ \__, | |____/_____|_|\_\
                |_|                                 |_|    |___/
*/

%macro utl_submit_py64_39(
      pgm
     ,return=  /* name for the macro variable from Python */
     )/des="Semi colon separated set of python commands - drop down to python";

  * delete temporary files;
  %utlfkil(%sysfunc(pathname(work))/py_pgm.py);
  %utlfkil(%sysfunc(pathname(work))/stderr.txt);
  %utlfkil(%sysfunc(pathname(work))/stdout.txt);

  filename py_pgm "%sysfunc(pathname(work))/py_pgm.py" lrecl=32766 recfm=v;
  data _null_;
    length pgm  $32755 cmd $1024;
    file py_pgm ;
    pgm=&pgm;
    semi=countc(pgm,";");
      do idx=1 to semi;
        cmd=cats(scan(pgm,idx,";"));
        if cmd=:". " then
           cmd=trim(substr(cmd,2));
         put cmd $char384.;
         putlog cmd $char384.;
      end;
  run;quit;
  %let _loc=%sysfunc(pathname(py_pgm));
  %let _stderr=%sysfunc(pathname(work))/stderr.txt;
  %let _stdout=%sysfunc(pathname(work))/stdout.txt;
  filename rut pipe  "c:\Python39\python.exe &_loc 2> &_stderr";
  data _null_;
    file print;
    infile rut;
    input;
    put _infile_;
  run;
  filename rut clear;
  filename py_pgm clear;

  * use the clipboard to create macro variable;
  %if "&return" ^= "" %then %do;
    filename clp clipbrd ;
    data _null_;
     length txt $200;
     infile clp;
     input;
     putlog "*******  " _infile_;
     call symputx("&return",_infile_,"G");
    run;quit;
  %end;

%mend utl_submit_py64_39;

/*   _                       _                                                _     _  _
  __| |_ __ ___  _ __     __| | _____      ___ __    _ __    ___ __ _ _ __ __| |___| || |
 / _` | `__/ _ \| `_ \   / _` |/ _ \ \ /\ / / `_ \  | `__|  / __/ _` | `__/ _` / __| || |_
| (_| | | | (_) | |_) | | (_| | (_) \ V  V /| | | | | |    | (_| (_| | | | (_| \__ \__   _|
 \__,_|_|  \___/| .__/   \__,_|\___/ \_/\_/ |_| |_| |_|     \___\__,_|_|  \__,_|___/  |_|
                |_|
*/

%macro utl_rbegin;

%utlfkil(c:/temp/r_pgm.r);
%utlfkilreturnvar (c:/temp/r_pgm.log);
filename ft15f001 "c:/temp/r_pgm.r";
%mend utl_rbegin;


%macro utl_rend(returnvar=N);
run;quit;

* EXECUTE THE R PROGRAM;
options noxwait noxsync;

filename rut pipe "D:\r412\R\R-4.1.2\bin\R.exe --vanilla --quiet --no-save < c:/temp/r_pgm.r 2> c:/temp/r_pgm.log";
run;quit;

  data _null_;
    file print;
    infile rut recfm=v lrecl=32756;
    input;
    put _infile_;
    putlog _infile_;
  run;

  filename ft15f001 clear;

  * use the clipboard to create macro variable;
  %if %upcase(%substr(&returnVar.,1,1)) ne N %then %do;
    filename clp clipbrd ;
    data _null_;
     length txt $200;
     infile clp;
     input;
     putlog "macro variable &returnVar = " _infile_;
     call symputx("&returnVar.",_infile_,"G");
    run;quit;
  %end;

data _null_;
  file print;
  infile rut;
  input;
  put _infile_;
  putlog _infile_;
run;quit;

data _null_;
  infile "c:/temp/r_pgm.log";
  input;
  putlog _infile_;
run;quit;

%mend utl_rend;

/*   _                       _                              _________  _
  __| |_ __ ___  _ __     __| | _____      ___ __    _ __  |___ /___ \| | __
 / _` | `__/ _ \| `_ \   / _` |/ _ \ \ /\ / / `_ \  | `__|   |_ \ __) | |/ /
| (_| | | | (_) | |_) | | (_| | (_) \ V  V /| | | | | |     ___) / __/|   <
 \__,_|_|  \___/| .__/   \__,_|\___/ \_/\_/ |_| |_| |_|    |____/_____|_|\_\
                |_|
*/

%macro utl_submit_r64(
      pgmx
     ,returnVar=N           /* set to Y if you want a return SAS macro variable from python */
     )/des="Semi colon separated set of R commands - drop down to R";
  * write the program to a temporary file;
  filename r_pgm "%sysfunc(pathname(work))/r_pgm.txt" lrecl=32766 recfm=v;
  data _null_;
    length pgm $32756;
    file r_pgm;
    pgm=&pgmx;
    put pgm;
    putlog pgm;
  run;
  %let __loc=%sysfunc(pathname(r_pgm));
  * pipe file through R;
  filename rut pipe "D:\r412\R\R-4.1.2\bin\R.exe --vanilla --quiet --no-save < &__loc";

  data _null_;
    file print;
    infile rut recfm=v lrecl=32756;
    input;
    put _infile_;
    putlog _infile_;
  run;
  filename rut clear;
  filename r_pgm clear;

  * use the clipboard to create macro variable;
  %if %upcase(%substr(&returnVar.,1,1)) ne N %then %do;
    filename clp clipbrd ;
    data _null_;
     length txt $200;
     infile clp;
     input;
     putlog "macro variable &returnVar = " _infile_;
     call symputx("&returnVar.",_infile_,"G");
    run;quit;
  %end;

%mend utl_submit_r64;













