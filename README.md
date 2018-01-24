# get_aws_ec2_names.sh
A quick and dirty BASH shell script to get a table of EC2 instances.
Tested on MacOS High Sierra

# Backround
Recently, I had few tasks involving getting simple EC2 inventory from several accounts.
Using Ansible dynamic inventory or boto3 was looking like a serious overkill for this task so I wrote this shell script. The script will be expanded with more options in the future.

# Usage
The script use aws cli in order to fetch data and make a readeatle table from it. In addition, it will generate a CSV file that can be used later. You will need to connect to the AWS account first so `aws` command can be used.

# Example:
`
$ get_ec2_instance_names.sh
Retrieving avaialble regions from AWS...
1) ap-south-1        5) ap-northeast-2   9) ap-southeast-1  13) us-east-2
2) eu-west-3         6) ap-northeast-1  10) ap-southeast-2  14) us-west-1
3) eu-west-2         7) sa-east-1       11) eu-central-1    15) us-west-2
4) eu-west-1         8) ca-central-1    12) us-east-1       16) Quit
Please select a region: 11
You picked eu-central-1 which is region 11
Our region is eu-central-1
Getting all instance IDs in the region...
Getting all unstance name tags from the IDs....

Here are the results:
some-name                               i-abcd9876
some-other-name                         i-qwerty1234
...

Creating a CSV with the results...
Your result is saved as "ec2-name-result.csv"
`
# TODO:
 - Command line options
 - Unique name for each report based on account ID


## Found a bug or want to suggest a feature?
Email me at jendoz[at]gmail[dot]com
