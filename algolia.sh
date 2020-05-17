source .env
firebase functions:config:set algolia.appid="$ALGOLIA_APP_ID" algolia.apikey="$ALGOLIA_ADMIN_API_KEY"

firebase deploy --only functions:sendCollectionToAlgolia
firebase deploy --only functions:setAlgoliaSearchAttributes
firebase deploy --only functions:onUserCreated
firebase deploy --only functions:onUserUpdated

curl https://us-central1-get-canteen.cloudfunctions.net/sendCollectionToAlgolia
curl https://us-central1-get-canteen.cloudfunctions.net/setAlgoliaSearchAttributes