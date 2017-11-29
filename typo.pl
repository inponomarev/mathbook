while (<STDIN>) {
   my $infilename = $_;

   $_ =~ m/([^.]+)/;
   my $outfilename = $1.'.tex';

   open INFILE, '<'.$infilename;
   open OUTFILE, '>new\\'.$outfilename;

   my $token = '\[';

   while (<INFILE>) {
     my $line = $_;
     #-------ЗАМЕНЫ---------
     
     #Унификация стиля выключенных формул
     while ($line =~ s/\$\$/$token/) {
       if ($token eq '\[') {$token = '\]'}
       else {$token = '\['};
     }
     $line =~ s/\\\[ +/\\\[/g;
     $line =~ s/ +\\\]/\\\]/g;

     #Унификация стиля внутристрочных формул
     $line =~ s/\\\(/\$/g;
     $line =~ s/\\\)/\$/g;
     
     #Повторяющиеся пробелы
     $line =~ s/ +/ /g;
     
     #Пробелы в хвосте строки
     $line =~ s/ $//g;
     
     #Длинные тире
     $line =~ s/ --- /~--- /g;

     #Ссылки
     $line =~ s/ \\(ref|pageref)\{/~\\$1\{/g;

     #Одно- и двухбуквенные слова (дважды для идущих подряд)
     $line =~ s/([ ~(][А-Яа-я][а-я]?) /$1~/g;
     $line =~ s/([ ~(][А-Яа-я][а-я]?) /$1~/g;

     #Сокращения вида т. е., т. о., и т. д., инициалы.
     $line =~ s/([ ~(].)\. (.)\./$1\.~$2\./g;

     #Короткие формулы
     $line =~ s/([а-я]) (\$[^\$]{1,10}\$)/$1~$2/g;
     
     print OUTFILE "$line";
     
     #-------ПОИСК ОПЕЧАТОК----------
     #повторяющиеся повторяющиеся слова
     undef $word;
     while ($line =~ m/([^ ]+)/g) {
       if (($word eq $1) && ($word =~ m/^[А-Яа-я]+/g)) {
         print "====Повторяющееся слово в файле $outfilename?: $word====\n";
         print $line;
         print "\n\n";
       }
       $word = $1;
     }

     #Забытый или лишний пробел
     while ($line =~ m/(([.,;:)][А-Яа-я])|([А-Яа-я] [.,;:)]))/g) {
         print "====Забытый или лишний пробел в файле $outfilename?: $1====\n";
         print $line;
         print "\n\n";
     }

     #Баланс скобок внутри формул
     while ($line =~ m/\$([^\$]+)\$/g) {
         my $formula = $1;
         
         undef $balance;
         while ($balance >= 0 && $formula =~ m/(\(|\))/g) {
            if ($1 eq '(') {$balance = $balance + 1}
            else {$balance = $balance - 1}
         }
         
         if (!($balance == 0)) {
            print "Файл: $outfilename, формула: $formula, баланс скобок: $balance.\n\n"
         }
     }
     #Подозрительное использование кванторов
    #### \\(exists|forall) +([A-Z\(]|\\neg)

   }
   close(INFILE);
   close(OUTFILE);
}
