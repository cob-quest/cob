.DEFAULT_GOAL := ports

ports:
	kubectl port-forward -n platform service/mongodb 27017:27017 &
	kubectl port-forward -n platform service/rabbitmq 15672:15672 &
	kubectl port-forward -n platform service/platform-api 8080:8080 &
	minikube tunnel

