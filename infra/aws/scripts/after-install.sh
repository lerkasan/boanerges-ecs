#!/bin/bash
set -xe

APPLICATION_NAME="boanerges"
DEPLOYMENT_GROUP_NAME="production"
BACKEND_IMAGE_NAME="$APPLICATION_NAME-backend"
FRONTEND_IMAGE_NAME="$APPLICATION_NAME-frontend"

REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/region)

DEPLOYMENT_ID=$(aws deploy list-deployments --application-name $APPLICATION_NAME --deployment-group-name $DEPLOYMENT_GROUP_NAME --region $REGION --include-only-statuses "InProgress" --query "deployments[0]" --output text --no-paginate)

GITHUB_TOKEN=$(aws ssm get-parameter --region $REGION --name ${APPLICATION_NAME^^}_GITHUB_TOKEN --with-decryption --query Parameter.Value --output text)
COMMIT_SHA=$(aws deploy get-deployment --deployment-id $DEPLOYMENT_ID --query "deploymentInfo.revision.gitHubLocation.commitId" --output text)
REPOSITORY=$(aws deploy get-deployment --deployment-id $DEPLOYMENT_ID --query "deploymentInfo.revision.gitHubLocation.repository" --output text)
GITHUB_USER=$(echo $REPOSITORY | cut -d "/" -f 1)

TOKEN=$(curl -u $GITHUB_USER:$GITHUB_TOKEN https://ghcr.io/token\?scope\="repository:$REPOSITORY:pull" | jq -r .token)
BACKEND_MANIFESTS_HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer $TOKEN" https://ghcr.io/v2/$REPOSITORY/$BACKEND_IMAGE_NAME/manifests/sha-$COMMIT_SHA)
FRONTEND_MANIFESTS_HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer $TOKEN" https://ghcr.io/v2/$REPOSITORY/$FRONTEND_IMAGE_NAME/manifests/sha-$COMMIT_SHA)

FRONTEND_TAG=$([ "$FRONTEND_MANIFESTS_HTTP_CODE" == 200 ] && echo "sha-$COMMIT_SHA" || echo "latest")
BACKEND_TAG=$([ "$BACKEND_MANIFESTS_HTTP_CODE" == 200 ] && echo "sha-$COMMIT_SHA" || echo "latest")

# FRONTEND_TAG=$([ $REPOSITORY == "lerkasan/boanerges-frontend" ] && echo "sha-$COMMIT_SHA" || echo "latest")
# BACKEND_TAG=$([ $REPOSITORY == "lerkasan/boanerges-backend" ] && echo "sha-$COMMIT_SHA" || echo "latest")

export FRONTEND_TAG=$FRONTEND_TAG
export BACKEND_TAG=$BACKEND_TAG

echo $GITHUB_TOKEN | docker login ghcr.io -u $GITHUB_USER --password-stdin

cd /home/ubuntu/app

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

docker compose pull