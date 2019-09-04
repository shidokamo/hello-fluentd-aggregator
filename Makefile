IMAGE_REPOSITORY=gcr.io
GCP_PROJECT:= $(shell gcloud config get-value project)
PREFIX := ${IMAGE_REPOSITORY}/${GCP_PROJECT}
TEST_LOGGER_IMAGE := ${PREFIX}/test-logger:v2.0.0
FLUENTD_IMAGE := ${PREFIX}/fluentd:v1.7.0b
GCS_BUCKET := test-aggregator
SERVICE_ACCOUNT_NAME := aggregator
KEY_FILE := key.json
export

# Make sure to remove key file after deployment
deploy:key clean
	cat aggregator-fluentd-configmap.yaml | envsubst | kubectl apply -f -
	cat aggregator-deployment.yaml | envsubst |  kubectl apply -f -
	kubectl apply -f aggregator-service.yaml
	kubectl apply -f forwarder-fluentd-configmap.yaml
	cat forwarder-deployment.yaml | envsubst | kubectl apply -f -
clean:
	-kubectl delete deployment forwarder
	-kubectl delete configmap forwarder-fluentd-config
	-kubectl delete deployment aggregator
	-kubectl delete service aggregator
	-kubectl delete configmap aggregator-fluentd-config
key:
	gcloud iam service-accounts keys create ${KEY_FILE} \
		--iam-account ${SERVICE_ACCOUNT_NAME}@${GCP_PROJECT}.iam.gserviceaccount.com
	-kubectl create secret generic gcs-key --from-file=${KEY_FILE}
	rm ${KEY_FILE}
