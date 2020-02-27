#!bin/sh

echo "replace default param values.......... in create "

echo "provide aws profile"
read profile
export AWS_DEFAULT_PROFILE=$profile
echo "action to perform is create or delete or deleteS3 " 
read operation 
echo "stack name: " 
read stackName
echo  "aws region: " 
read region

if [ "$operation" = "create" ];
then
    echo "Creating Stack ..!!"
    aws cloudformation create-stack \                                                                
    --stack-name $stackName \
    --region $region \
    --parameters ParameterKey=vpcCidr,ParameterValue=0.0.0.0/0 \
    ParameterKey=subnetCidr,ParameterValue="0.0.0.0/0\,0.0.0.0/0\,0.0.0.0/0" \
    ParameterKey=vpcName,ParameterValue=[your-VPCName]] \
    ParameterKey=EC2VolSize,ParameterValue=20 \
    ParameterKey=RDSPublicAccessibility,ParameterValue=false \
    ParameterKey=DbStorage,ParameterValue=50 \
    ParameterKey=EC2AMI,ParameterValue=[your-ami] \
    ParameterKey=awsKeyname,ParameterValue=[your-key]] \
    ParameterKey=DbPass,ParameterValue=[your-dbPass] \
    ParameterValue=DbUsername,ParameterValue=[your-DbUsername]] \
    --template-body file://application.json --capabilities CAPABILITY_NAMED_IAM

    echo "Created Stack ..!!"
    aws cloudformation describe-stacks --stack-name $stackName
elif [ "$operation" = "delete" ];
then
    echo "Deleting Stack ..!!"
    aws cloudformation delete-stack --stack-name $stackName --region $region
    echo "Waiting for stack to delete ..!!"
    aws cloudformation wait stack-delete-complete --stack-name $stackName --region $region
    echo "Deleted Stack ..!!"   
elif [ "$operation" = "deleteS3"];
then
    echo "Delete objects in s3"
    echo "provide bucketname profile"
    read bucketName
    aws s3 rm s3://$bucketName --recursive --region $region
else
    echo 'Provide action to perform either create or delete operations'
fi