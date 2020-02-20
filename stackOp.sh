#!bin/sh

echo "replace default param values.......... in create "

echo "provide aws profile"
read profile
export AWS_DEFAULT_PROFILE=$profile
echo "action to perform is create or delete: " 
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
    ParameterKey=vpcName,ParameterValue=testName \
    --template-body file://networking.json
    echo "Created Stack ..!!"
    aws cloudformation describe-stacks --stack-name $stackName
elif [ "$operation" = "delete" ];
then
    echo "Deleting Stack ..!!"
    aws cloudformation delete-stack --stack-name $stackName --region $region
    echo "Waiting for stack to delete ..!!"
    aws cloudformation wait stack-delete-complete --stack-name $stackName --region $region
    echo "Deleted Stack ..!!"   
else
    echo 'Provide action to perform either create or delete'
fi