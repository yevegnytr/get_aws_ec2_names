#!/bin/bash
# A quick and dirty script to enum EC2 instances with IDs and name tags.
# Written by Yevgeny Trachtinov

# Text effects
bold=$(tput bold)
normal=$(tput sgr0)

# Get all available regions
echo "etting avaialble regions from AWS..."
aws ec2 describe-regions --query 'Regions[].{Name:RegionName}' --output text > regions.txt

# Select the region from menu
prompt="${bold}Please select a region:${normal}"
options=(`cat regions.txt`)

PS3="$prompt "
select opt in "${options[@]}" "Quit" ; do
    if (( REPLY == 1 + ${#options[@]} )) ; then
        exit

    elif (( REPLY > 0 && REPLY <= ${#options[@]} )) ; then
        echo  "You picked $opt which is region $REPLY"
        break
    else
        echo "Invalid option. Try another one."
    fi
done

AWS_REGION=$opt
echo Our region is $AWS_REGION

# Start collecting data from the region
echo "Getting all instance IDs in the region..."
INSTANCE_IDS=`aws ec2 describe-instances --region $AWS_REGION --query 'Reservations[*].Instances[*].[InstanceId]' --output text`

echo "Getting all unstance name tags from the IDs...."
for i in $INSTANCE_IDS
  do aws ec2 describe-tags \
  --filters Name=resource-id,Values=$i Name=key,Values=Name \
  --query Tags[].Value --output text --region $AWS_REGION
done > instance_names.txt

# Output collected results into text files that can construct a table (that can later be used Excel)
INSTANCE_NAMES=`cat instance_names.txt`
aws ec2 describe-instances --region $AWS_REGION --query 'Reservations[*].Instances[*].[InstanceId]' --output text > instance_ids.txt

# Combine the results into a table then create a CSV
echo ""
echo "${bold}Here are the results:${normal}"
paste instance_names.txt instance_ids.txt | column -s $'\t' -t

echo ""
echo "Creating a CSV with the results..."
echo Instance ID,Name > ec2-name-result.csv
paste instance_names.txt instance_ids.txt | tr "\\t" "," >> ec2-name-result.csv
echo 'Your result is saved as "ec2-name-result.csv"'

# Clean up result files
rm instance_ids.txt
rm instance_names.txt
rm regions.txt
