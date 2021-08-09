#!/usr/bin/gawk -f

(ARGIND==1){

   FS="\t"
   query_actual_taxonomy[$2]=$1

}

(ARGIND==2) {

   FS="\t"

   query=$1
   print(query_actual_taxonomy[query] "\t" $0)


}
