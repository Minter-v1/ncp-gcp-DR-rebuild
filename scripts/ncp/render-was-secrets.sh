#!/usr/bin/env bash

set -Eeuo pipefail

# MARK: - Runtime paths

readonly METADATA_URL="http://169.254.169.254/latest"
readonly SECRET_API_URL="https://ocapi-kr.ncloud.com"
readonly SECRET_API_PREFIX="/secretmanager/api/v1"
readonly SECRET_DIRECTORY="/run/greentech-was/secrets"
readonly CONTAINER_UID="10001"
readonly CONTAINER_GID="10001"

# MARK: - Runtime prerequisites

for command_name in curl jq openssl findmnt install; do
  if ! command -v "${command_name}" >/dev/null 2>&1; then
    printf 'Required command not found: %s\n' "${command_name}" >&2
    exit 1
  fi
done

if [[ "$(findmnt -n -o FSTYPE /run)" != "tmpfs" ]]; then
  printf '/run is not mounted as tmpfs\n' >&2
  exit 1
fi

# MARK: - Metadata API v2 credentials

metadata_token=$(curl -fsS -X PUT \
  "${METADATA_URL}/api/token" \
  -H "X-NCP-METADATA-TOKEN-TTL-SECONDS: 300")

role_id=$(curl -fsS \
  -H "X-NCP-METADATA-TOKEN: ${metadata_token}" \
  "${METADATA_URL}/meta-data/iam/security-credentials")

sts_response=$(curl -fsS \
  -H "X-NCP-METADATA-TOKEN: ${metadata_token}" \
  "${METADATA_URL}/meta-data/iam/security-credentials/${role_id}")

sts_access_key=$(printf '%s' "${sts_response}" | jq -er '.AccessKeyId')
sts_secret_key=$(printf '%s' "${sts_response}" | jq -er '.SecretAccessKey')

# MARK: - Secret Manager API request

request_secret_api() {
  local request_path="$1"
  local request_timestamp
  local request_signature

  request_timestamp=$(date +%s%3N)

  request_signature=$(printf 'GET %s\n%s\n%s' \
    "${request_path}" \
    "${request_timestamp}" \
    "${sts_access_key}" \
    | openssl dgst -sha256 \
        -hmac "${sts_secret_key}" \
        -binary \
    | openssl base64)

  curl -fsS \
    "${SECRET_API_URL}${request_path}" \
    -H "x-ncp-apigw-timestamp: ${request_timestamp}" \
    -H "x-ncp-iam-access-key: ${sts_access_key}" \
    -H "x-ncp-apigw-signature-v2: ${request_signature}"
}

# MARK: - Secret discovery

secret_list=$(request_secret_api "${SECRET_API_PREFIX}/secrets")

find_secret_id() {
  local secret_name="$1"

  printf '%s' "${secret_list}" \
    | jq -er \
        --arg secret_name "${secret_name}" \
        '.data.secretList[]
         | select(.secretName == $secret_name)
         | .secretId'
}

read_active_secret() {
  local secret_name="$1"
  local secret_id
  local secret_response

  secret_id=$(find_secret_id "${secret_name}")

  secret_response=$(request_secret_api \
    "${SECRET_API_PREFIX}/secrets/${secret_id}/values")

  printf '%s' "${secret_response}" \
    | jq -er '.data.decryptedSecretChain.active'
}

db_secret=$(read_active_secret "greentech-db")
app_secret=$(read_active_secret "greentech-app")
object_secret=$(read_active_secret "greentech-obj")

# MARK: - Runtime secret directory

install \
  -d \
  -m 0750 \
  -o root \
  -g "${CONTAINER_GID}" \
  "${SECRET_DIRECTORY}"

write_secret_file() {
  local file_name="$1"
  local file_value="$2"
  local file_path="${SECRET_DIRECTORY}/${file_name}"

  install \
    -m 0400 \
    -o "${CONTAINER_UID}" \
    -g "${CONTAINER_GID}" \
    /dev/null \
    "${file_path}"

  printf '%s' "${file_value}" > "${file_path}"
}

# MARK: - Database secrets

db_host=$(printf '%s' "${db_secret}" | jq -er '.host')
db_port=$(printf '%s' "${db_secret}" | jq -er '.port')
db_database=$(printf '%s' "${db_secret}" | jq -er '.database')

write_secret_file \
  "DB_URL" \
  "jdbc:mysql://${db_host}:${db_port}/${db_database}"

write_secret_file \
  "DB_USERNAME" \
  "$(printf '%s' "${db_secret}" | jq -er '.username')"

write_secret_file \
  "DB_PASSWORD" \
  "$(printf '%s' "${db_secret}" | jq -er '.password')"

# MARK: - Application secrets

write_secret_file \
  "JWT_SECRET" \
  "$(printf '%s' "${app_secret}" | jq -er '.jwtSecret')"

write_secret_file \
  "FIELD_ENCRYPTION_KEY" \
  "$(printf '%s' "${app_secret}" | jq -er '.fieldEncryptionKey')"

write_secret_file \
  "ADMIN_USERNAME" \
  "$(printf '%s' "${app_secret}" | jq -er '.adminUsername')"

write_secret_file \
  "ADMIN_PASSWORD" \
  "$(printf '%s' "${app_secret}" | jq -er '.adminPassword')"

# MARK: - Object Storage secrets

write_secret_file \
  "NCP_STORAGE_ACCESS_KEY" \
  "$(printf '%s' "${object_secret}" | jq -er '.accessKey')"

write_secret_file \
  "NCP_STORAGE_SECRET_KEY" \
  "$(printf '%s' "${object_secret}" | jq -er '.secretKey')"

# MARK: - Cleanup

unset metadata_token
unset role_id
unset sts_response
unset sts_access_key
unset sts_secret_key
unset secret_list
unset db_secret
unset app_secret
unset object_secret
unset db_host
unset db_port
unset db_database

printf 'WAS runtime secrets rendered successfully\n'