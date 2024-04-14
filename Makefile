.DEFAULT_GOAL := ports

ports:
	kubectl port-forward -n platform service/mongodb 27017:27017 &
	kubectl port-forward -n platform service/rabbitmq 15672:15672 &
	kubectl port-forward -n platform service/platform-api 8080:8080 &
	minikube tunnel

someother:
	kubectl port-forward -n platform service/mongodb 27017:27017 &
	kubectl port-forward -n platform service/rabbitmq 15672:15672 &
	kubectl port-forward -n platform service/platform-api 8080:8080 &
	minikube tunnel

setup-vlt:
	vlt login
	vlt config init

secrets:
	vlt run -c 'envsubst -i secrets.tpl' > secrets.yml
