{
  sum+=$5
  if(NR==1) {
    min=$5
    max=$5
    min_name=$9
    max_name=$9
  }
  if ($5 < min) {
    min=$5
    min_name=$9
  }
  if ($5 > max){
    max=$5
    max_name=$9
  }
}
END {
  print "Files Sum: ", sum/1024 ,"KB"
  if ((stats == 1) && !(ext == "")){
    print "."ext, "Files Max file name:", max_name, max/1024 ,"KB"
    print "."ext, "Files Min file name:", min_name, min/1024 ,"KB"
    print "."ext, "FILES: ", NR
    print ""
  }
  else{
      print "Max file name:", max_name, max/1024 ,"KB"
      print "Min file name:", min_name, min/1024 ,"KB"
      print "FILES: ", NR
      print ""
  }
}
