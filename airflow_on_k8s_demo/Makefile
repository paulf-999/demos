SHELL = /bin/sh

# note: only install is confidently working

config_file := config/envvars.json

$(eval eg_airflow_var=$(shell jq '.Parameters.eg_airflow_var' ${config_file}))
$(eval airflow_version=$(shell jq '.Parameters.airflow_version' ${config_file}))

installations: deps install clean

deps:
	$(info [+] Download the relevant dependencies)
	@pip install docker
	@pip install docker-compose
	@brew install kind
	@brew install helm
	@brew install kubectl
	@pip install jq

.PHONY: deps

install:
	$(info [+] Install the relevant dependencies)
	# create the k8s cluster - can take approx 3 mins
	@kind create cluster --name airflow-cluster --config config/kind-cluster.yaml
	# Create k8s namespace
	@kubectl create namespace airflow
	# download the airflow helm chart
	@helm repo add apache-airflow https://airflow.apache.org
	@helm repo update
	# deploy airflow on k8s using k8s!
	@helm install airflow apache-airflow/airflow --namespace airflow --debug --wait=false
.PHONY: install

setup_port_forwarding:
	$(info [+] To access the Airflow UI, open a new terminal and execute the following command)
	@kubectl port-forward svc/airflow-webserver 8080:8080 -n airflow --context kind-airflow-cluster

#note: this is only done if you're configuring a new custom airflow-cluster
configure_airflow_on_K8s:
	$(info [+] Configure Airflow on K8s for your needs (e.g., set the executor, add any desired Airflow vars/connections))
	helm show values apache-airflow/airflow > config/gened_values.yaml
	# change the Airflow executor type
	@sed -i -e 's/executor: \"CeleryExecutor\"/executor: \"KubernetesExecutor\"/g' config/values.yaml
	# Add any vars or connections that you want to export each time your Airflow instance gets deployed, by defining a ConfigMap
	@gsed -i -z "s/extraEnvFrom: ~\n# eg:\n# extraEnvFrom: |\n#   - secretRef:\n#       name: '{{ .Release.Name }}-airflow-connections'\n#   - configMapRef:\n#       name: '{{ .Release.Name }}-airflow-variables'/extraEnvFrom: |\n  - configMapRef:\n      name: '${eg_airflow_var}'/g" config/values.yaml
	# Add the ConfigMap to the cluster
	@kubectl apply -f config/variables.yaml
	# Deploy Airflow on K8s again
	@helm ls -n airflow
	@helm upgrade --install airflow apache-airflow/airflow -n airflow -f config/values.yaml --debug
	@helm ls -n airflow

install_deps_airflow_k8s:
	# create custom docker image
	@docker build -t airflow-custom:1.0.0 .
	@kind load docker-image airflow-custom:1.0.0 --name airflow-cluster
	# modify the file values.yaml
	# TODO: confirm that I do need to comment this out. Also confirm the SSH args
	@sed -i -e 's/defaultAirflowRepository: apache\/airflow/defaultAirflowRepository: airflow-custom/g' config/values.yaml
	# upgrade the helm chart
	@helm upgrade --install airflow apache-airflow/airflow -n airflow -f config/values.yaml --debug
	# deploy k8s again
	@helm ls -n airflow

deploy_dags_on_k8s_w_gitsync:
	@kubectl create secret generic airflow-ssh-git-secret --from-file=gitSshKey=/Your/path/.ssh/id_rsa -n airflow
	@kubectl get secrets -n airflow
	@helm upgrade --install airflow apache-airflow/airflow -n airflow -f config/values.yaml --debug

#TBC
logs_w_airflow_on_k8s:
	# set up the Persistent Volume to provide a durable location to prevent data from being lost
	@kubectl apply -f config/pv.yaml
	@kubectl get pv -n airflow
	# create a persistent volume claim so that you bind the PV with Airflow
	@kubectl apply -f config/pvc.yaml
	@kubectl get pvc -n airflow
	# update values.yaml
	@gsed -i -z "s/logs:\n  persistence:\n    # Enable persistent volume for storing logs\n    enabled: false\n    # Volume size for logs\n    size: 100Gi\n    # If using a custom storageClass, pass name here\n    storageClassName:\n    ## the name of an existing PVC to use\n    existingClaim:/logs:\n  persistence:\n    enabled: false\n    existingClaim: airflow-logs/g" config/gened_values.yaml
	# redeploy the Airflow instance
	@helm upgrade --install airflow apache-airflow/airflow -n airflow -f config/values.yaml --debug

check_airflow_providers:
	@kubectl exec <webserver_pod_id> -n airflow -- airflow providers list

clean:
	$(info [+] Remove any redundant files, e.g. downloads)
	@kind delete cluster --name airflow-cluster
	#@kubectl delete namespace airflow
	@helm repo remove apache-airflow
	rm config/*.yaml-e
.PHONY: clean
