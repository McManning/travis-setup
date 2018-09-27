#/bin/sh

echo "Authenticating with Travis"
travis login --org --auto

echo "Sending encrypted private key to Travis"
msg=$(travis encrypt-file /id-rsa --no-interactive)
deploy_key_label=$(echo $msg | sed -r 's/.*encrypted_([0-9a-z]+)_key .*/\1/')

echo "Adding additional environment variables to Travis"
travis env set DEPLOY_KEY_ENC `base64 /id_rsa.enc | tr -d '\n'` --private
travis env set DEPLOY_KEY_LABEL "$deploy_key_label"

echo "Done!"
