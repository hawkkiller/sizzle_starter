if [ -f packages/app_database/coverage/lcov.info ]; then
  cp packages/app_database/coverage/lcov.info coverage/app_database_lcov.info
else
  touch coverage/app_database_lcov.info
fi

if [ -f packages/rest_client/coverage/lcov.info ]; then
  cp packages/rest_client/coverage/lcov.info coverage/rest_client_lcov.info
else 
  touch coverage/rest_client_lcov.info
fi

cat coverage/app_database_lcov.info coverage/rest_client_lcov.info >> coverage/lcov.info