apiVersion: v1
kind: Secret
metadata:
  name: cob-secrets
stringData:
  .env: |
    BUCKET_NAME=cob-bucket-challenge
    MONGODB_HOSTNAME=mongodb.platform.svc.cluster.local
    MONGODB_USERNAME=mongo
    MONGODB_PASSWORD=mongo
    AMQP_HOSTNAME=rabbitmq.platform.svc.cluster.local
    AMQP_USERNAME=rabbit
    AMQP_PASSWORD=rabbit
    PLATFORM_USERNAME=test
    PLATFORM_PASSWORD=test
    GOOGLE_APPLICATION_CREDENTIALS=$GOOGLE_APPLICATION_CREDENTIALS
    GLUSERNAME=$GLUSERNAME
    GLTOKEN=$GLTOKEN
    GLREGISTRY=$GLREGISTRY
    HELM_CHART_NAME=$HELM_CHART_NAME
    HELM_REPO_NAME=$HELM_REPO_NAME
    HELM_REPO_URL=$HELM_REPO_URL
    HELM_REPO_USERNAME=$HELM_REPO_USERNAME
    HELM_REPO_PASSWORD=$HELM_REPO_PASSWORD
    SMTP_API_KEY=$SMTP_API_KEY
  challenge-bucket-key.json: |
    $CHALLENGE_BUCKET_KEY
---
apiVersion: v1
kind: Secret
type: kubernetes.io/dockerconfigjson
metadata:
  name: docker-registry-credentials
data:
  .dockerconfigjson: $DOCKER_REGISTRY_CREDENTIALS
  .dockerconfig.json: $DOCKER_REGISTRY_CREDENTIALS
---
apiVersion: v1
data:
  tls.crt: $TLS_CRT
  tls.key: $TLS_KEY
kind: Secret
metadata:
  name: tls-cert
type: kubernetes.io/tls
