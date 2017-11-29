while (<STDIN>) {


   $_ =~ m/([^.]+)/;
   my $infilename = $1.'.tex';
#   my $outfilename = $1.'.tex';

   open INFILE, '<'.$infilename;
   print "Файл: $infilename.\n\n";
   
   #undef $balance;
   my $balance = 0;
   my $line;
   while (<INFILE>) {
     $line = $_;
     #Баланс скобок внутри файла
     while ($balance >= 0 && $line =~ m/(\(|\))/g) {
            if ($1 eq '(') {$balance = $balance + 1}
            else {$balance = $balance - 1}
     #while ($balance >= 0 && $line =~ m/(\[|\])/g) {
     #       if ($1 eq '[') {$balance = $balance + 1}
     #       else {$balance = $balance - 1}
     #while ($balance >= 0 && $line =~ m/(\{|\})/g) {
      #      if ($1 eq '{') {$balance = $balance + 1}
       #     else {$balance = $balance - 1}

     }
     if ($balance < 0) {
     #if (!($balance == 0)) {
      print "Файл: $infilename, параграф: '$line', баланс скобок: $balance.\n\n"
     }
   }
   if (!($balance == 0)) {
      print "Файл: $infilename, параграф: '$line', баланс скобок: $balance.\n\n"
   }
   close(INFILE);
}


