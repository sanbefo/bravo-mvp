# --- Settings ---
APP_NAME := bravo-mvp
TAG := latest
IMAGE := $(APP_NAME):$(TAG)
NAMESPACE := bravo-mvp

.PHONY: verify-docker verify-minikube verify-kubectl \
        build-docker build-minikube \
        run-bravo-minikube clean-minikube help

# --- 1. Verification Commands ---

## verify-docker: Inline check for Docker daemon
verify-docker:
	@echo "Checking Docker status..."
	@docker info >/dev/null 2>&1 || (echo "❌ Docker is not running." && exit 1)
	@echo "✅ Docker is up."

## verify-minikube: Inline check for Minikube status
verify-minikube: verify-docker
	@echo "Checking Minikube status..."
	@minikube status >/dev/null 2>&1 || (echo "❌ Minikube is not running." && exit 1)
	@echo "✅ Minikube is active."

## verify-kubectl: Inline check for kubectl installation and connectivity
verify-kubectl: verify-minikube
	@echo "Checking kubectl status..."
	@command -v kubectl >/dev/null 2>&1 || (echo "❌ kubectl is not installed." && exit 1)
	@kubectl cluster-info >/dev/null 2>&1 || (echo "❌ kubectl cannot connect to a cluster." && exit 1)
	@echo "✅ kubectl is configured."

# --- 2. Build Commands ---

## build-docker: Calls verify-docker then builds the image locally
build-docker: verify-docker
	@echo "Building Rails Docker image locally..."
	docker build -t $(IMAGE) .
	@echo "✅ Local build complete."

## build-minikube: Calls verify-minikube then builds directly into its registry
build-minikube: verify-minikube
	@echo "Building inside Minikube environment..."
	@eval $$(minikube docker-env) && \
	docker build -t $(IMAGE) .
	@echo "✅ Minikube build complete."

# --- 3. Deployment & Cleanup ---

## run-bravo-minikube: Builds image and deploys all K8s manifests with health checks
run-bravo-minikube: verify-kubectl build-minikube
	@echo "🚀 Starting Deployment: bravo-minikube"

	@echo "1. Applying Namespace..."
	@kubectl apply -f k8s/namespace.yaml
	@sleep 2

	@echo "2. Deploying Postgres..."
	@kubectl apply -f k8s/postgres.yaml
	@kubectl wait --for=condition=ready pod -l app=postgres -n bravo-mvp --timeout=300s
	@echo "✅ Postgres is up."

	@echo "3. Deploying Redis..."
	@kubectl apply -f k8s/redis.yaml
	@kubectl wait --for=condition=ready pod -l app=redis -n bravo-mvp --timeout=300s
	@echo "✅ Redis is up."

	@echo "4. Deploying Sidekiq..."
	@kubectl apply -f k8s/sidekiq.yaml
	@kubectl wait --for=condition=ready pod -l app=sidekiq -n bravo-mvp --timeout=300s
	@echo "✅ Sidekiq is up."

	@echo "5. Deploying Rails Application..."
	@kubectl apply -f k8s/rails-service.yaml
	@kubectl apply -f k8s/rails-development.yaml
	@kubectl wait --for=condition=ready pod -l app=rails -n bravo-mvp --timeout=300s
	@echo "✅ Rails app is up."

	@echo "6. Configuring Networking..."
	@kubectl apply -f k8s/ingress.yaml
	@echo "✅ Ingress applied."
	@echo "---"
	@echo "🎉 All systems go!"

## clean-minikube: Safely deletes all resources in reverse order
clean-minikube: verify-kubectl
	@echo "🗑️  Cleaning up bravo-minikube resources..."
	@kubectl delete -f k8s/ingress.yaml --ignore-not-found
	@kubectl delete -f k8s/rails-development.yaml --ignore-not-found
	@kubectl delete -f k8s/rails-service.yaml --ignore-not-found
	@kubectl delete -f k8s/sidekiq.yaml --ignore-not-found
	@kubectl delete -f k8s/postgres.yaml --ignore-not-found
	@kubectl delete -f k8s/redis.yaml --ignore-not-found
	@kubectl delete -f k8s/namespace.yaml --ignore-not-found
	@echo "⏳ Waiting for namespace $(NAMESPACE) to terminate..."
	@kubectl wait --for=delete namespace/$(NAMESPACE) --timeout=300s || true
	@echo "✨ Environment is clean."

# --- Database Commands ---

## db-setup: Runs create, migrate, and seed inside the running Rails container
db-setup: verify-kubectl
	@echo "🔍 Finding Rails Pod..."
	$(eval POD_NAME=$(shell kubectl get pods -l app=rails -n bravo-mvp -o jsonpath='{.items[0].metadata.name}'))
	@if [ -z "$(POD_NAME)" ]; then \
		echo "❌ No Rails Pod found. Is the app running?"; exit 1; \
	fi
	@echo "🚀 Executing DB setup on $(POD_NAME)..."
	@kubectl exec -n $(NAMESPACE) $(POD_NAME) -- bundle exec rails db:create
	@kubectl exec -n $(NAMESPACE) $(POD_NAME) -- bundle exec rails db:migrate
	@kubectl exec -n $(NAMESPACE) $(POD_NAME) -- bundle exec rails db:seed
	@echo "✅ Database is ready."
# --- 4. Help ---

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Available targets:"
	@grep -E '^##' $(MAKEFILE_LIST) | sed -e 's/## //g' | column -t -s ':'
