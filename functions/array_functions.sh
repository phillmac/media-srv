#!/bin/echo Source this file:
#@ Name: array-funcs
#@ Version: 1.0
#@ Description: Functions for manipulating bash arrays
#@ Usage: . array-funcs
#@ Author: Chris F.A. Johnson
#@ Copyright: © 2013 Chris F.A. Johnson
#@ Released under the terms of the GNU General Public License V2 or later
#@ See the file COPYING for the full license

set -a
funcfile=array-funcs
array_funcs_created='3 Jan 2013'
array_funcs_modified=2013-06-17T14:52:43

lookup() #@ Look up value in array and return index in variable
{        #@ USAGE: lookup arrayname string varname:index
  local arrayname=${1:?} string=${2:?} val var=${3:-index}
  ## Copy the array, $arrayname, to local array
  eval "array=( \"\${$arrayname[@]}\" )"

  case ${array[*]} in
    ## If the string is not in the array, don't bother looking
    *"$string"*)
          for val in "${!array[@]}"
          do
            case ${array[val]} in
              *"$string"*)
                     eval "$var=\$val"
                     ;;
            esac
          done
          ;;
  esac
}

copy() #@ Copy array to new array
{      #@ USAGE: copy arrayname1 arrayname2
  local a1=${1:?} a2=${2:-copy}
  eval "$a2=( \"\${$a1[@]}\" )"
}

fib() #@ Add next number in fibonacci series to end of array
{     #@ USAGE: fib arrayname
  local arrayname=${1:?} array
  ## Copy the array, $arrayname, to local array
  eval "array=( \"\${$arrayname[@]}\" )"
  ## If there are no elements in the array, enter the first two
  if [ ${#array[@]} -eq 0 ]
  then
    array=( 0 1 )
  elif [ ${#array[@]} -eq 1 ]
  ## If there is one element in the array, enter a second
  then
    array[1]=$(( array[0] + 1 ))
  else
    array+=( $(( array[-1] + array[-2] )) )
  fi

  ## Copy array back to $arrayname
  eval "$arrayname=( \"\${array[@]}\" )"
}

concat() #@ Concatenate two arrays, store in third
{        #@ USAGE: concat arrayname1 arrayname2 arrayname3
  eval "${3:?}=( \"\${$1[@]}\" \"\${$2[@]}\" )"
}

rshove() #@ Add element to end of array and remove first element
{       #@ USAGE: rshove arrayname val
  local arrayname=${1:?} val=$2 max=$3 array n
  ## Copy the array, $arrayname, to local array
  eval "array=( \"\${$arrayname[@]}\" )"
  n=${#array[@]}
  ## Add $val to end of array
  array=( "${array[@]}" "$val" )
  ## Remove first element of array
  unset array[0]
  ## Copy array back to $arrayname
  eval "$arrayname=( \"\${array[@]}\" )"
}

shove() #@ Add element to beginning of array and remove last element
{       #@ USAGE: shove arrayname val
  local arrayname=${1:?} val=$2 max=$3 array n
  ## Copy the array, $arrayname, to local array
  eval "array=( \"\${$arrayname[@]}\" )"
  n=${#array[@]}
  ## Add $val to beginning of array
  array=( "$val" "${array[@]}" )
  ## Remove last element of array
  unset array[n]
  ## Copy array back to $arrayname
  eval "$arrayname=( \"\${array[@]}\" )"
}

show_pairs() #@ Pair corresponding elements of 2 arrays and print
{      #@ USAGE: pair arrayname1 arrayname2 arrayname3 sep::
  local a1=${1:?Array name required} a2=${2:?Array name required}
  local j=${3:?Array name required} sep=${4:-:} b1 b2 new

  ## Store both arrays in local arrays
  eval "b1=( \"\${$a1[@]}\" )"
  eval "b2=( \"\${$a2[@]}\" )"

  num=$(( ${#b1[@]} > ${#b2[@]} ? ${#b1[@]} : ${#b2[@]} ))
  n=-1
  while [ $(( n += 1 )) -lt $num ]
  do
    new+=( "${b1[n]}$sep${b2[n]}" )
    printf "%s\t%s" "${b1[n]}" "${b2[n]}"
  done

  ## Copy array into $j
  eval "$j=( \"\${new[@]}\" )"
}

show() #@ Print, or store in variable, all elements of array
{      #@ USAGE: show arrayname [-v[ ]varname] [outsep [pre [post]]]
  local var array arrayname outsep pre post

  ## If first arg is -v* get name of variable to store result
  case "$1" in
    -v) var=$2; shift 2 ;;
    -v*) var=${1#-v}; shift ;;
  esac

  ## Use array whose name is in the first argument
  arrayname=${1:?Array name required}

  ## If no separator is supplied, use a newline
  outsep=${2-$'\n'}

  ## String to print before each element
  pre=$3

  ## String to print after each element
  post=$4

  ## Copy the array, $arrayname, to local array
  eval "array=( \"\${$arrayname[@]}\" )"

  ## Check whether $var is set
  if [ -z "$var" ]
  ## If not, print array to stdout
  then
    printf "$pre%s$post$outsep" "${array[@]}"
    ## If $sep doesn't end with a newline and stdout is a terminal, then print a newline
    case $outsep in
      *$'\n') ;;
      *) [ -t 1 ] && echo ;;
    esac
  else
    ## ... otherwise print output to that variable
    printf -v "$var" "$pre%s$post$outsep" "${array[@]}"
  fi
}

burst() #@ Split string into array using SEP as delimiter
{       #@ USAGE: burst string arrayname [SEP]
  local string=${1:?} arrayname=${2:-array} IFS=$3
  ## If SEP is not supplied, use the last character of $string
  [ -z "$IFS" ] && IFS=${string: -1}
  read -a "$2" <<< "$string"
}

push() #@ Add value[s] to beginning of array
{      #@ USAGE: push arrayname value ...
  local arrayname=${1:?Array name required} #val=$2
  shift
  eval "$arrayname=( \"\$@\" \"\${$arrayname[@]}\" )"
}

pop() #@ Remove top element (array[0]) from stack and place in varname
{     #@ USAGE: pop arrayname varname:var
  local arrayname=${1:?Array name required} array val varname=${2:-var}
  ## Copy the array, $arrayname, to local array
  eval "array=( \"\${$arrayname[@]}\" )"
  ## Check that there is at least one element in the array
  if [ ${#array[@]} -lt 1 ]
  then
    eval "$varname="
    return 1
  fi
  ## Store first element of array in $varname
  eval "$varname=\${array[0]}"
  ## Remove first element
  unset array[0]
  ## Rebuild array
  eval "$arrayname=( \"\${array[@]}\" )"
}

add_end() #@ Add element to end of list
{         #@ USAGE: add arrayname value
  local arrayname=${1:?Array name required} val=$2
  eval "$arrayname+=( \"\$val\" )"
}

peek_end() #@ Get element from end of list
{          #@ USAGE: get_end arrayname varname:var
  local array arrayname=${1:?Array name required} varname=${2:-var} n
  eval "array=( \"\${$arrayname[@]}\" )"
  n=${#array[@]}
  printf -v "$varname" "${array[n-1]}"
}

pop_end() #@ Remove element from end of list and store in varname
{         #@ USAGE: pop_end arrayname varname:var
  local arrayname=${1:?Array name required} varname=${2:-var} n

  ## Copy the array, $arrayname, to local array
  eval "array=( \"\${$arrayname[@]}\" )"
  n=${#array[@]}

  ## Check that there is at least one element in the array
#  [ $n -lt 1 ] && return 1
  (( $n )) || return 1

  ## Store last element in $varname
  printf -v "$varname" "${array[n-1]}"
  unset array[n-1]

  ## Copy array back to $arrayname
  eval "$arrayname=( \"\${array[@]}\" )"
}

dup() #@ Duplicate top item on stack
{     #@ USAGE: dup arrayname
  local arrayname=${1:?Array name required}} n
  ## Check that there is at least one element in the array
  eval "n=\${#${arrayname[@]}" || return
  eval "$arrayname=( \"\${$arrayname[0]}\" \"\${$arrayname[@]}\" )"
}

peek() #@ Store top element of array in variable, but do not remove it
{      #@ USAGE: peek arrayname var:peek
  local arrayname=${1:?Array name required} val varname=${2:-peek}
  eval "[ ${#arrayname[@]} -gt 0 ] || return 1"
  eval "val=\${${arrayname}[0]}"
  printf -v "$varname" "%s" "$val"
}

exch() #@ Exchange top two elements on stack
{      #@ USAGE: exch arrayname
  local arrayname=${1:?Array name required} val1 val2 varname=${2:-var}
  eval "[ ${#arrayname[@]} -ge 2 ] || return 1"
  ## Store first two elements in variables val1 and val2
  eval "val1=\${${arrayname}[0]}"
  eval "val2=\${${arrayname}[1]}"
  ## rebuild array with variables switched
  eval "$arrayname=( \"\$val2\" \"\$val1\" \"\${$arrayname[@]:2}\" )"
  printf -v "$varname" "%s" "$val"
}

reverse() #@ Reverse order of array
{         #@ USAGE: reverse arrayname
  local arrayname=${1:?Array name required} array revarray e
  ## Copy the array, $arrayname, to local array
  eval "array=( \"\${$arrayname[@]}\" )"
  ## Copy elements to revarray in reverse order
  for e in "${array[@]}"
  do
    revarray=( "$e" "${revarray[@]}" )
  done
  ## Copy revarray back to $arrayname
  eval "$arrayname=( \"\${revarray[@]}\" )"
}

string2array() #@ Split string into array of characters
{              #@ USAGE: string2array arrayname string
  local array arrayname=${1:?Array name required} string=${2:?String required}
  ## Add characters to array
  while [ -n "$string" ] 
  do
    array+=( "${string:0:1}" )
    string=${string#?}
  done
  ## Copy array into $arrayname
  eval "$arrayname=( \"\${array[@]}\" )"
}

array2string()
{ :

}

move() #@ Move element to right or left
{      #@ USAGE: move arrayname enum num
  local arrayname=${1:?Arrayname required} enum=${2:?Element required} num=${3:-1}

  local array val left right newsub
  ## Copy the array, $arrayname, to local array
  eval "array=( \"\${$arrayname[@]}\" )"

  val=${array[enum]}
  newsub=$(( enum + num +1 ))
  [ $newsub -lt 0 ] && newsub=0
  if [ $num -gt 0 ]
  then
    left=( "${array[@]:0:newsub}" )
    right=( "${array[@]:newsub}" )
    array=( "${left[@]}" "$val" "${right[@]}" )
    unset array[enum]
  elif [ $num -lt 0 ]
  then
    unset array[enum]
    [ $newsub -le 0 ] && newsub=1
    left=( "${array[@]:0:newsub-1}" )
    right=( "${array[@]:newsub-1}" )
    array=( "${left[@]}" "$val" "${right[@]}" )
  fi
  ## Copy array back to $arrayname
  eval "$arrayname=( \"\${array[@]}\" )"
}

insert() #@ Insert element into array at position
{        #@ USAGE: insert arrayname string position
  local arrayname=${1:?Arrayname required} val=$2 num=${3:-1}
  local array
  ## Copy the array, $arrayname, to local array
  eval "array=( \"\${$arrayname[@]}\" )"
  ## If position is less than 0 set to 0
  [ $num -lt 0 ] && num=0 #? Should this be an error instead?
  array=( "${array[@]:0:num}" "$val" "${array[@]:num}" )
  ## Copy array back to $arrayname
  eval "$arrayname=( \"\${array[@]}\" )"
}

remove() #@ Remove element from array
{        #@ USAGE: remove arrayname position
  local arrayname=${1:?Arrayname required} num=${2:-1}
  local array
  [ $num -lt 0 ] && num=0 #? Or should this return an error???
  unset $arrayname[num]
  ## Copy array back to $arrayname
  eval "$arrayname=( \"\${$arrayname[@]}\" )"
}

roll() #@ Rotate top N elements; [N] moves to [0] with optional repeat
{      #@ USAGE: roll arrayname num:3 repeat:1
  # 1 2 3 => 3 1 2      #: default=3
  # 1 2 3 4 => 4 1 2 3  #: 4 in $2
  local arrayname=${1:?Array name required} num=${2:-${roldef:-3}} repeat=${3:-1}
  local array tmp
  ## Check that there are at least $num elements in the array
  eval "[ ${#arrayname[@]} -ge $num ] || return 1"
  ## Copy the array, $arrayname, to local array
  eval "array=( \"\${$arrayname[@]}\" )"
  while [ $(( repeat -= 1 )) -ge 0 ]
  do
    tmp=${array[num-1]}
    unset array[num-1]
    array=( "$tmp" "${array[@]}" )
  done
  ## Copy array back to $arrayname
  eval "$arrayname=( \"\${array[@]}\" )"
}

rolr() #@ Rotate top N elements; [0] moves to [N] with optional repeat
{      #@ USAGE: rolr arrayname num:3 repeat:1
  # 1 2 3 =>  2 3 1     #: default=3
  # 1 2 3 4 => 2 3 4 1  #: 4 in $2
  local arrayname=${1:?Array name required} num=${2:-${roldef:-3}}
  local repeat=${3:-1} array tmp
  ## Check that there are at least $num elements in the array
  eval "[ ${#arrayname[@]} -ge $num ] || return 1"
  ## Copy the array, $arrayname, to local array
  eval "array=( \"\${$arrayname[@]}\" )"
  while [ $(( repeat -= 1 )) -ge 0 ]
  do
    tmp=${array[0]}
    unset array[0]
    array=( "${array[@]:0:num-1}" "$tmp" "${array[@]:num-1}" )
  done
  ## Copy array back to $arrayname
  eval "$arrayname=( \"\${array[@]}\" )"
}

rotate() #@ Move element from one end of the array to the other with optional repeat
{         #@ USAGE: rotate arrayname [-]n
  local arrayname=${1:?Array name required} num=${2:-1} tmp n
  ## Copy the array, $arrayname, to local array
  eval "array=( \"\${$arrayname[@]}\" )"
  if [ $num -gt 0 ]
  then
    ## N > 0: move first element to end of array; repeat as necessary
    while [ $(( num -= 1 )) -ge 0 ]
    do
      tmp=${array[0]}
      unset array[0]
      array=( "${array[@]}" "$tmp" )
    done
  else
    ## n < 0: move last element to beginning of array; repeat as necessary
    n=$(( ${#array[@]} - 1 ))
    while [ $(( num += 1 )) -le 0 ]
    do
      tmp=${array[n]}
      unset array[n]
      array=( "$tmp" "${array[@]}" )
    done
  fi
  eval "$arrayname=( \"\${array[@]}\" )"
}

duplicate() #@ Create a copy of an array
{           #@ USAGE: duplicate array newarray
  local array1=${1:-} array2=${2:?}
  eval  "$array2=( \"\${$array1[@]}\" )"
}

pair() #@ Pair corresponding elements of 2 arrays to single element in new array
{      #@ USAGE: pair arrayname1 arrayname2 arrayname3 sep::
  local a1=${1:?Array name required} a2=${2:?Array name required}
  local j=${3:?Array name required} sep=${4:-:} b1 b2 new

  ## Store both arrays in local arrays
  eval "b1=( \"\${$a1[@]}\" )"
  eval "b2=( \"\${$a2[@]}\" )"

  num=$(( ${#b1[@]} > ${#b2[@]} ? ${#b1[@]} : ${#b2[@]} ))
  n=-1
  while [ $(( n += 1 )) -lt $num ]
  do
    new+=( "${b1[n]}$sep${b2[n]}" )
  done
  ## Copy array into $j
  eval "$j=( \"\${new[@]}\" )"
}

merge() #@ Merge 2 arrays
{       #@ USAGE: merge arrayname1 arrayame2 joinarray
  local a1=${1:?Array name required} a2=${2:?Array name required}
  local j=${3:?Array name required} b1 b2 new

  eval "b1=( \"\${$a1[@]}\" )"
  eval "b2=( \"\${$a2[@]}\" )"

  ## Set num to the number of elements in the larger array
  num=$(( ${#b1[@]} > ${#b2[@]} ? ${#b1[@]} : ${#b2[@]} ))
  n=-1
  while [ $(( n += 1 )) -lt $num ]
  do
#    new+=( "${b1[n]}" "${b2[n]}" )
    new+=( ${b1[n]+"${b1[n]}"} ${b2[n]+"${b2[n]}"} )
  done
  ## Copy new array into target array
  eval "$j=( \"\${new[@]}\" )"
}

mergex() #@ Merge 2 arrays including unset elements
{        #@ USAGE: mergex arrayname1 arrayame2 joinarray
  local a1=${1:?Array name required} a2=${2:?Array name required}
  local j=${3:?Array name required} b1 b2 new

  eval "b1=( \"\${$a1[@]}\" )"
  eval "b2=( \"\${$a2[@]}\" )"

  ## Set num to the number of elements in the larger array
  num=$(( ${#b1[@]} > ${#b2[@]} ? ${#b1[@]} : ${#b2[@]} ))
  n=-1
  while [ $(( n += 1 )) -lt $num ]
  do
    new+=( "${b1[n]}" "${b2[n]}" )
#    new+=( ${b1[n]+"${b1[n]}"} ${b2[n]+"${b2[n]}"} )
  done
  ## Copy new array into target array
  eval "$j=( \"\${new[@]}\" )"
  ## Should I merge merge and mergex?
}

compact() #@ Remove unset elements holding a place in array
{         #@ USAGE: compact arrayname
  local arrayname=${1:?Array name required}
  eval "$arrayname=( \"\${$arrayname[@]}\" )"
}

add() #@ Pop two elements, add them, leave result on top of stack and in varname
{     #@ USAGE: add arrayname
  local arrayname=${1:?Array name required} varname=${2:-var}
  ## Copy the array, $arrayname, to local array
  eval "array=( \"\${$arrayname[@]}\" )"
  array[1]=$(( ${array[0]} +  ${array[1]} ))
  eval "$varname=${array[1]}"
  unset array[0]
  ## Copy array back to $arrayname
  eval "$arrayname=( \"\$var\" \"\${array[@]}\" )"
}

sub() #@ Pop two elements, subtract, leave result on top of stack and in varname
{
  local arrayname=${1:?Array name required} varname=${2:-var}
  ## Copy the array, $arrayname, to local array
  eval "array=( \"\${$arrayname[@]}\" )"
  ## Subtract values, store in array[1]
  array[1]=$(( ${array[1]} - ${array[0]} ))
  ## Store result in variable
  printf -v "$varname"  "%d" "${array[1]}"
  unset array[0]
  ## Copy array back to $arrayname
  eval "$arrayname=( \"\$var\" \"\${array[@]}\" )"
}

mean() #@ Average integer elements in array
{      #@ USAGE: mean arrayname varname
  local arrayname=${1:?Array name required} varname=${2:-var}
  local total=0 v n=0
  ## Copy the array, $arrayname, to local array
  eval "array=( \"\${$arrayname[@]}\" )"
  for v in "${array[@]}"
  do
    case $v in *[!0-9-]*) continue ;; esac
    total=$(( total + v ))
    n=$(( n + 1 ))
  done
  printf -v "$varname" "%d" "$(( total / n ))"
}

total() #@ Add all numerical elements of array
{
  local arrayname=${1:?Array name required} varname=${2:-var}
  local total=0 v
  ## Copy the array, $arrayname, to local array
  eval "array=( \"\${$arrayname[@]}\" )"
  for v in "${array[@]}"
  do
    case $v in *[!0-9-]*) continue ;; esac
    total=$(( total + v ))
  done
  printf -v "$varname" "%d" "$total"
}

count() #@ Return number of elements in array
{       #@ USAGE: count arrayname varname:var 
  local arrayname=${1:?Array name required} varname=${2:-var}
  eval "$varname=( \"\${#$arrayname[@]}\" )"
}

forall() #@ Perform action on each element of the array
{
  :
}

longest() #@ Find the longest element (most characters)
{         #@ USAGE: longest arrayname var:longest
  local arrayname=${1:?Array name required} varname=${2:-longest}
  local IFS= string longest e
  ## Copy the array, $arrayname, to local array
  eval "array=( \"\${$arrayname[@]}\" )"
  longest=${array[0]}
  for e in "${array[@]}"
  do
    [ ${#e} -gt ${#longest} ] && longest=$e
  done
  [ "$varname" != longest ] && eval "$varname=\$longest}"
}

shortest() #@ Find the shortest element (fewest characters)
{          #@ USAGE: shortest arrayname var:shortest
  local arrayname=${1:?Array name required} varname=${2:-shortest}
  local IFS= string shortest e
  ## Copy the array, $arrayname, to local array
  eval "array=( \"\${$arrayname[@]}\" )"
  shortest=${array[0]}
  for e in "${array[@]}"
  do
    [ ${#e} -lt ${#longest} ] && shortest=$e
  done
  [ "$varname" != shortest ] && eval "$varname=\$shortest}"
}

max() #@ Find the element with the highest value (text or numeric)
{     #@ USAGE: max arrayname
  local arrayname=${1:?Array name required} varname=${2:-var}
  local IFS= string max e
  ## Copy the array, $arrayname, to local array
  eval "array=( \"\${$arrayname[@]}\" )"
  eval "string=\"\${$arrayname[*]}\""

  case $string in
    *[!0-9]*)
       ## Array contains non-numeric value, so use string comparison
       for e in "${array[@]}"
       do
         [ "$e" \> "$max" ] && max=$e
       done
       ;;
    *) max=${array[0]}
       for e in "${array[@]}"
       do
         ## Numeric comparison
         [ "$e" -gt "$max" ] && max=$e
       done
       ;;
  esac

  eval "$varname=\$max"
}

min() #@ Find the element with the lowest value (text or numeric)
{     #@ min arrayname
  local arrayname=${1:?Array name required} varname=${2:-var}
  local IFS= string min e
  ## Copy the array, $arrayname, to local array
  eval "array=( \"\${$arrayname[@]}\" )"
  eval "string=\"\${$arrayname[*]}\""
  case $string in
    *[!0-9]*)
       ## array contains non-numeric value
       min=${array[0]}
       for e in "${array[@]}"
       do
         [ "$e" \< "$min" ] && min=$e
       done
       ;;
    *) min=${array[0]}
       for e in "${array[@]}"
       do
         [ "$e" -lt "$min" ] && min=$e
       done
       ;;
  esac
  eval "$varname=\$min"
}
