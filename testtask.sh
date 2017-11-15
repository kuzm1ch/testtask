#!/bin/bash

#take name and instance-id of our instances  using aws cli (skip task about Tag "backup" and  with key "true", sorry)
array=`aws ec2 describe-instances | grep 'Name' | awk '{print $3}'|xargs`
array2=`aws ec2 describe-instances | grep 'INSTANCES' | awk '{print $9}'|xargs`

arr=($array)
arr2=($array2)

#create ami  with name = instances name + date in format like 15-11-2017
i=0
while [ $i -lt ${#arr[*]} ]; do
    aws ec2 create-image --instance-id ${arr2[$i]} --name "${arr[$i]} `date +"%d-%m-%Y"`"
    i=$(( $i + 1));
done

#grep id_s of all amis wtich don't contain accapteble date (date +"%Y-%m-%d, full column looks like 2017-11-15T12:45:37) , therefore they are old
# also we coud use this example https://digiplot.wordpress.com/2017/02/24/bash-script-to-remove-amis-and-associated-snapshots-older-than-7-days/ but it more  harder (in my opinion)
ami=$( aws ec2 describe-images --owners 962249044915 | grep -v "`date +"%Y-%m-%d"`\|`date +"%Y-%m-%d" -d "-1 days"`\|`date +"%Y-%m-%d" -d "-2 days"`\|`date +"%Y-%m-%d" -d "-3 days"`\|`date +"%Y-%m-%d" -d "-4 days"`\|`date +"%Y-%m-%d" -d "-5 days"`\|`date +"%Y-%m-%d" -d "-6 days"`\|`date +"%Y-%m-%d" -d "-7 days"`" | grep ami | awk '{ print $6 }' | xargs )
amiarr=($ami)
c=0
while [ $c -lt ${#amiarr[*]} ]; do
    echo  -e  "\e[33mecs ami_id ${amiarr[$c]}"
    aws ec2 deregister-image --image-id ${amiarr[$c]}
    c=$(( $c + 1));
done

#just used the same grep only without -v and change colour output 
ami2=$( aws ec2 describe-images --owners 962249044915 | grep  "`date +"%Y-%m-%d"`\|`date +"%Y-%m-%d" -d "-1 days"`\|`date +"%Y-%m-%d" -d "-2 days"`\|`date +"%Y-%m-%d" -d "-3 days"`\|`date +"%Y-%m-%d" -d "-4 days"`\|`date +"%Y-%m-%d" -d "-5 days"`\|`date +"%Y-%m-%d" -d "-6 days"`\|`date +"%Y-%m-%d" -d "-7 days"`" | grep ami | awk '{ print $6 }' | xargs )
amiarr2=($ami2)
v=0
while [ $v -lt ${#amiarr2[*]} ]; do
    echo  -e  "\e[92mecs ami_id ${amiarr2[$v]} "
    v=$(( $v + 1));
done


