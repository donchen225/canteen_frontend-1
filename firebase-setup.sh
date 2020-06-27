
# Declare environent to setup
ENVIRONMENT="staging"

echo "Setting up Firebase $ENVIRONMENT environment..."

# Switch to firebase project to set up
# firebase use $ENVIRONMENT

# Set up algolia
## Load algolia config
if [ "$ENVIRONMENT" == "production" ]
then
    BUCKET_ENVIRONMENT="prod"
elif [ "$ENVIRONMENT" == "staging" ]
then
    BUCKET_ENVIRONMENT="staging"
else
    BUCKET_ENVIRONMENT="dev"
fi

gsutil cp gs://canteen-secrets-${BUCKET_ENVIRONMENT}/algolia-keys.json .

ALGOLIA_APP_ID=$(cat algolia-keys.json| jq -r ".ALGOLIA_APP_ID")
ALGOLIA_ADMIN_API_KEY=$(cat algolia-keys.json| jq -r ".ALGOLIA_ADMIN_API_KEY")

# firebase functions:config:set algolia.appid="$ALGOLIA_APP_ID" algolia.apikey="$ALGOLIA_ADMIN_API_KEY"

# # Set up firestore entries
# ## Create groups in firestore
# for file in groups/*
# do
#     if [[ -f $file ]]; then
#         gcloud functions call createGroup --data '{"data":'"$(cat $file)"'}'
#     fi
# done